using CSV
using JSON3
using DataFrames
using Plots
using LaTeXStrings

function linear_fit(x::AbstractVector, y::AbstractVector)
    N = length(x)
    @assert N == length(y) "Array lengths do not match"
    # A b = c
    sum_x = sum(x)
    A = [N sum_x; sum_x sum(x.^2)]
    c = [sum(y), sum(y .* x)]
    b = A \ c
    return b
end

function main()
    # Data reading
    df = CSV.read("data/raw-mass-length-data.csv", DataFrame)
    misc_json = read("data/raw-misc-data.json", String)
    misc_data = JSON3.read(misc_json, Dict{Symbol, Real})

    (; m, L) = df

    # Convert the air column length from mm to m
    L /= 1000


    # Calculations

    # Convert the temperature from °F to K
    misc_data[:T] = 5/9 * (misc_data[:T] - 32) + 273.15

    # Find the cross-sectional area of the cylinder in m^2
    # The diameter is in mm
    misc_data[:A] = π/4 * (misc_data[:D] / 1000)^2

    # Convert the atmospheric pressure from inHg to Pa
    misc_data[:P_0] = misc_data[:P_0] * 25.4 * 101_325 / 760

    # Calculate the combined mass of the piston+platform and the added weights in g
    M = @. m + misc_data[:m_p]
    insertcols!(df, :M => M)

    # Calculate the force exerted by the piston in N
    F_g = @. M / 1000 * misc_data[:g]
    insertcols!(df, :F_g => F_g)

    # Calculate the absolute pressure of the gas in Pa
    P = @. misc_data[:P_0] + F_g / misc_data[:A]
    insertcols!(df, :P => P)

    # Calculate the inverse of the pressure
    P_inv = @. 1/P
    insertcols!(df, :P_inv => P_inv)

    # Calculate the fit parameters for L vs 1/P
    (intercept, slope) = linear_fit(P_inv, L)
    misc_data[:intercept] = intercept
    misc_data[:slope] = slope

    # Calculate the volume of the bottle and tubing in L
    misc_data[:V_0] = -intercept * misc_data[:A] * 1000

    # Calculate the moles of gas
    misc_data[:n] = slope * misc_data[:A] / (misc_data[:R] * misc_data[:T])


    # Plot the L vs 1/P
    plt = plot(xlabel=L"P^{-1}~(\mathrm{Pa^{-1}})", ylabel=L"L~(\mathrm{m})", legend=false)
    plot!(plt, P_inv, L, seriestype=:scatter)
    Plots.abline!(plt, slope, intercept)


    # Output writing

    CSV.write("data/main-data.csv", df)

    open("data/misc-data.json", "w") do f
        JSON3.pretty(f, JSON3.write(misc_data))
    end

    savefig(plt, "media/L-v-P-inverse.svg")

    return
end

main()
