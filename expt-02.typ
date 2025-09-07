#import "phys-conf.typ": conf, csv_helper, sample_calculation, sig_figs, decimal_places
#import "@preview/zero:0.5.0": num, zi, format-table

#show: conf.with(
  title: [Equation of State for an Ideal Gas],
  author: (first_name: "Vincent", last_name: "Edwards"),
  partner: (first_name: "Gina", last_name: "Herrera"),
  date: datetime(year: 2025, month: 9, day: 12),
)

#let main_data_fname = "data/main-data.csv"
#let sample_row = csv(main_data_fname, row-type: dictionary).at(1)
#let s(attr) = sample_row.at(attr)

#let misc_data = json("data/misc-data.json")
#let raw_misc_data = json("data/raw-misc-data.json")

#let degreeF = zi.declare($degree "F"$)
#let inHg = zi.declare($"in" "Hg"$)
#let mmHg = zi.declare($"mm" "Hg"$)
#let J-molK = zi.declare("J/mol/K")
#let m-s2 = zi.declare("m/s^2")
#let m2 = zi.declare("m^2")
#let m3 = zi.declare("m^3")
#let Pa-1 = zi.declare("Pa^-1")
#let mPa = zi.declare("m Pa")

#let T = misc_data.at("T")
#let T_disp = zi.K(T, ..decimal_places(2))
#let P_0 = misc_data.at("P_0")
#let P_0_disp = zi.Pa(P_0, ..decimal_places(0))
#let m_p = misc_data.at("m_p")
#let m_p_disp = zi.gram(m_p, ..decimal_places(1))
#let D = misc_data.at("D")
#let D_disp = zi.mm(D)
#let R = misc_data.at("R")
#let R_disp = J-molK(R)
#let g = misc_data.at("g")
#let g_disp = m-s2(g)
#let A = misc_data.at("A")
#let A_disp = m2(A, ..sig_figs(3))
#let slope = misc_data.at("slope")
#let slope_disp = mPa(slope, ..decimal_places(0))
#let intercept = misc_data.at("intercept")
#let intercept_disp = zi.m(intercept, ..decimal_places(3))
#let n = misc_data.at("n")
#let n_disp = zi.mol(n, ..sig_figs(3))
#let V_0 = misc_data.at("V_0")
#let V_0_disp = zi.liter(V_0, ..sig_figs(3))

= Results

@tb_misc_quantities contains various quantities, both measured and given, that were relevant to the analysis.
They are collected in a table to assist with lookup.

#[
  #let T_F = raw_misc_data.at("T")
  #let T_F_disp = degreeF(T_F)

  $T$ is the temperature of the room measured using a digital thermometer.
  The temperature was initially measured as #T_F_disp, then converted to kelvins as show in @eq_temperature_conversion.

  $
  T = (5/9 (#T_F - 32) + 273.15) space.quarter #zi.K() = #T_disp
  $ <eq_temperature_conversion>
]

#[
  #let P_0_weird = raw_misc_data.at("P_0")
  #let P_0_weird_disp = inHg(P_0_weird)

  $P_0$ is the atmospheric pressure measured using a digital barometer.
  The pressure was initially measured as #P_0_weird_disp, then converted to pascals as shown in @eq_pressure_conversion.

  $
  P_0 = (#P_0_weird_disp) dot (mmHg(25.4))/(inHg(1)) dot (zi.Pa(101325))/(mmHg(760)) = #P_0_disp
  $ <eq_pressure_conversion>
]

$m_p$ is the mass of the piston & platform, taken from the label on the gas law apparatus.
$D$ is the piston diameter, taken from the label on the gas law apparatus.

Some constants that were needed in the analysis were the universal gas constant $R$ and the acceleration due to gravity $g$.
Both values were taken from the lab manual.
Note that the value of $g$ used is for the science building, where the experiment was performed.

#figure(
  {
    let format = (none, auto)
    show table: format-table(..format)
    table(
      columns: format.len(),
      table.header(
        [Quantity],
        [Value],
      ),
      $T$, T_disp,
      $P_0$, P_0_disp,
      $m_p$, m_p_disp,
      $D$, D_disp,
      $R$, R_disp,
      $g$, g_disp,
    )
  },
  caption: [Miscellaneous Quantities]
) <tb_misc_quantities>

@tb_m_L contains the measurements of the mass put on the piston platform $m$ and the resulting length of the column of air in the cylinder $L$.
#(csv(main_data_fname).len()-1) samples were collected all together.
The piston-holding thumbscrew was used to keep the piston in place at the top of the cylinder while connecting the cylinder to the 2-liter bottle.
After the connection was made, the thumbscrew was released and the piston dropped down slightly.
If the piston continued to slide down, without stopping, it would have indicated that air was escaping from the cylinder, tubing, or bottle.
After finding the location of the leak and patching it, the piston would need to be reset to its highest position and the bottle reconnected.
However, a small amount of air leakage was unavoidable.
Thus, care was taken to quickly measure $L$ after placing the slotted masses on the platform, only waiting a few seconds for the reading to stabilize before moving on to the next sample.

#figure(
  {
    let format = (none,) + (auto,) * 2
    show table: format-table(..format)
    table(
      columns: format.len(),
      table.header(
        [Sample],
        [$m$ (#zi.gram())],
        [$L$ (#zi.mm())],
      ),
      ..csv_helper(
        main_data_fname,
        (
          "sample",
          "m",
          "L",
        )
      ),
    )
  },
  caption: [Samples of Mass Added and Air Column Length]
) <tb_m_L>

= Analysis

The cross-sectional area of the cylinder $A$ is given by @eq_area.
Substituting in the diameter $D$ yields an area of #A_disp, as shown in @eq_area_calculation.
$
A = pi (D/2)^2
$ <eq_area>
$
A = pi (#D_disp/2 dot zi.m(1)/zi.mm(1000))^2 = #A_disp
$ <eq_area_calculation>

@tb_pressure_calculation contains various quantities involved in finding the pressure of the gas $P$ and its reciprocal $P^(-1)$ at each sample.
$M$ is the combined mass of the piston, platform, and the slotted masses put on the platform, calculated using @eq_combined_mass.

$
M = m + m_p
$ <eq_combined_mass>

#sample_calculation(name: [Sample 2 $M$])[
  #let m = s("m")
  #let m_disp = zi.gram(m, ..decimal_places(0))
  #let M = s("M")
  #let M_disp = zi.gram(M, ..decimal_places(0))

  $ M = (#m_disp) + (#m_p_disp) $
  $ M = #M_disp $
]

$F_g$ is the force of gravity on the combined mass $M$, calculated using equation @eq_F_g.

$
F_g = M g
$ <eq_F_g>

#sample_calculation(name: [Sample 2 $F_g$])[
  #let M = s("M")
  #let M_disp = zi.gram(M, ..decimal_places(0))
  #let F_g = s("F_g")
  #let F_g_disp = zi.N(F_g, ..decimal_places(2))

  $ F_g = (#M_disp dot zi.kg(1)/zi.gram(1000)) (#g_disp) $
  $ F_g = #F_g_disp $
]

$P$ is the total pressure exerted on the gas, calculated using equation @eq_pressure.
$P^(-1)$ is the reciprocal of the pressure $P$, calculated using equation @eq_pressure_reciprocal.

$
P = P_0 + F_g / A
$ <eq_pressure>

$
P^(-1) = 1/P
$ <eq_pressure_reciprocal>

#sample_calculation(name: [Sample 2 $P$ & $P^(-1)$])[
  #let F_g = s("F_g")
  #let F_g_disp = zi.N(F_g, ..decimal_places(2))
  #let P = s("P")
  #let P_disp = zi.Pa(P, ..sig_figs(5))
  #let P_inv = s("P_inv")
  #let P_inv_disp = Pa-1(P_inv, ..sig_figs(5))

  $ P = (#P_0_disp) + ((#F_g_disp)) / ((#A_disp)) $
  $ P = #P_disp $

  $ P^(-1) = 1/((#P_disp)) $
  $ P^(-1) = #P_inv_disp $
]

#figure(
  {
    let format = (none, decimal_places(0), decimal_places(2),) + (sig_figs(5),) * 2
    show table: format-table(..format)
    table(
      columns: format.len(),
      table.header(
        [Sample],
        [$M$ (#zi.gram())],
        [$F_g$ (#zi.N())],
        [$P$ (#zi.Pa())],
        [$P^(-1)$ (#Pa-1())],
      ),
      ..csv_helper(
        main_data_fname,
        (
          "sample",
          "M",
          "F_g",
          "P",
          "P_inv",
        )
      ),
    )
  },
  caption: [Quantities Calculated to Find Pressure and its Reciprocal]
) <tb_pressure_calculation>

#figure(
  image("media/L-v-P-inverse.svg"),
  caption: [
    Response of the Enclosed Gas to Additional Force
    $ L = (#slope_disp) P^(-1) + (#intercept_disp) $ <eq_linear_fit>
  ],
) <fg_L_vs_P_inv>

@fg_L_vs_P_inv plots $L$ versus $P^(-1)$.
As more mass $m$ was put on the piston platform, the pressure $P$ of the enclosed gas increased, thereby decreasing the reciprocal of the pressure $P^(-1)$.
At the same time, the height of the column of air in the cylinder $L$ decreased.

Boyle's law states that if a fixed amount of gas is kept at a constant temperature, then its volume and absolute pressure will be inversely proportional.
In the experiment, the temperature $T$ and the moles of gas enclosed $n$ were both kept roughly constant.
Thus, the results of this experiment can be used to support or contradict Boyle's law.

The ideal gas law, which implies Boyle's law, is given by @eq_ideal_gas_law.

$
P V = n R T
$ <eq_ideal_gas_law>

In the experiment, the volume of the enclosed gas $V$ consists of the volume of air in the cylinder $L A$ plus the volume of air in the bottle and hose $V_0$.
That combined volume $V$ is given by @eq_total_volume.

$
V = V_0 + L A
$ <eq_total_volume>

Combining @eq_ideal_gas_law and @eq_total_volume and rearranging yields @eq_L_P_inv_linear_relation.

$ P (V_0 + L A) = n R T $
$ P L A = n R T - P V_0 $
$ L = underbrace((n R T)/A, "slope") P^(-1) underbrace(-V_0/A, "y-intercept") $ <eq_L_P_inv_linear_relation>

Notice that $L$ is linear with respect to $P^(-1)$.
The slope of such a plot is given by @eq_slope, and the y-intercept is given by @eq_intercept.
Since the data in @fg_L_vs_P_inv lie on a straight line as predicted, the experiment verifies Boyle's law.

$ "slope" = (n R T)/A $ <eq_slope>
$ "y-intercept" = -V_0/A $ <eq_intercept>

The equation for the line of best fit for the data is given by @eq_linear_fit.
The slope has a value of #slope_disp, and the y-intercept has a value of #intercept_disp.

Rearranging @eq_slope yields @eq_mol, which can be used to find the moles of gas enclosed $n$.
Substituting in values gives #n_disp, as shown in @eq_mol_calculation.

$
n = ("slope" dot A) / (R T)
$ <eq_mol>
$
n = ((#slope_disp) (#A_disp)) / ((#R_disp) (#T_disp)) = #n_disp
$ <eq_mol_calculation>

Rearranging @eq_intercept yields @eq_V_0, which can be used to find the volume of the 2-liter bottle and tubing $V_0$.
Substituting in values gives #V_0_disp, as shown in @eq_V_0_calculation.
This volume, slightly larger than #zi.liter(2), is consistent with the fact that a 2-liter bottle was used with a small connecting tube.

$
V_0 = -("y-intercept") A
$ <eq_V_0>
$
V_0 = -(#intercept_disp) (#A_disp) dot zi.liter(1000)/m3(1) = #V_0_disp
$ <eq_V_0_calculation>
