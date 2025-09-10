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

#let T = zi.K(misc_data.at("T"), ..decimal_places(2))
#let P_0 = zi.Pa(misc_data.at("P_0"), ..decimal_places(0))
#let m_p = zi.gram(misc_data.at("m_p"), ..decimal_places(1))
#let D = zi.mm(misc_data.at("D"))
#let R = J-molK(misc_data.at("R"))
#let g = m-s2(misc_data.at("g"))
#let A = m2(misc_data.at("A"), ..sig_figs(3))
#let slope = mPa(misc_data.at("slope"), ..decimal_places(0))
#let intercept = zi.m(misc_data.at("intercept"), ..decimal_places(3))
#let n = zi.mol(misc_data.at("n"), ..sig_figs(3))
#let V_0 = zi.liter(misc_data.at("V_0"), ..sig_figs(3))

= Results

@tb_misc_quantities contains various quantities, both measured and provided, that were relevant to the analysis.
They are collected in a table to assist with lookup.

#[
  #let T_F_val = raw_misc_data.at("T")
  #let T_F = degreeF(T_F_val)

  $T$ is the temperature of the room measured using a digital thermometer.
  The temperature was initially measured as #T_F, then converted to kelvins as show in @eq_temperature_conversion.

  $
  T = (5/9 (#T_F_val - 32) + 273.15) space.quarter #zi.K() = #T
  $ <eq_temperature_conversion>
]

#[
  #let P_0_weird = inHg(raw_misc_data.at("P_0"))

  $P_0$ is the atmospheric pressure measured using a digital barometer.
  The pressure was initially measured as #P_0_weird, then converted to pascals as shown in @eq_pressure_conversion.

  $
  P_0 = (#P_0_weird) dot (mmHg(25.4))/(inHg(1)) dot (zi.Pa(101325))/(mmHg(760)) = #P_0
  $ <eq_pressure_conversion>
]

$m_p$ is the mass of the piston & platform, taken from the label on the gas law apparatus.
$D$ is the piston diameter, also taken from the label on the gas law apparatus.

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
      $T$, T,
      $P_0$, P_0,
      $m_p$, m_p,
      $D$, D,
      $R$, R,
      $g$, g,
    )
  },
  caption: [Miscellaneous Measured Quantities and Constants]
) <tb_misc_quantities>

@tb_m_L contains the measurements of the mass put on the piston platform $m$ and the resulting length of the column of air in the cylinder $L$.
#(csv(main_data_fname).len()-1) samples were collected all together.
The piston-holding thumbscrew was used to keep the piston in place at the top of the cylinder while connecting the cylinder to the 2-liter bottle.
After the connection was made, the thumbscrew was released and the piston dropped down slightly.
If the piston continued to slide down, without stopping, it would have indicated that air was escaping from the cylinder, tubing, or bottle.
After finding the location of the leak and patching it, the piston would need to be reset to its highest position and the bottle reconnected.
However, a small amount of air leakage was unavoidable.
Thus, care was taken to quickly measure $L$ after placing the slotted masses on the platform, only waiting about five seconds for the reading to stabilize before moving on to the next sample.

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
Substituting in the diameter $D$ yields an area of #A, as shown in @eq_area_calculation.
$
A = pi (D/2)^2
$ <eq_area>
$
A = pi (#D/2 dot zi.m(1)/zi.mm(1000))^2 = #A
$ <eq_area_calculation>

@tb_pressure_calculation contains various quantities involved in finding the pressure of the gas $P$ and its reciprocal $P^(-1)$ at each sample.
$M$ is the combined mass of the piston, platform, and the slotted masses put on the platform, calculated using @eq_combined_mass.

$
M = m + m_p
$ <eq_combined_mass>

#sample_calculation(name: [Sample 2 $M$])[
  #let m = zi.gram(s("m"), ..decimal_places(0))
  #let M = zi.gram(s("M"), ..decimal_places(0))

  $ M = (#m) + (#m_p) $
  $ M = #M $
]

$F_g$ is the force of gravity on the combined mass $M$, calculated using equation @eq_F_g.

$
F_g = M g
$ <eq_F_g>

#sample_calculation(name: [Sample 2 $F_g$])[
  #let M = zi.gram(s("M"), ..decimal_places(0))
  #let F_g = zi.N(s("F_g"), ..decimal_places(2))

  $ F_g = (#M dot zi.kg(1)/zi.gram(1000)) (#g) $
  $ F_g = #F_g $
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
  #let F_g = zi.N(s("F_g"), ..decimal_places(2))
  #let P = zi.Pa(s("P"), ..sig_figs(5))
  #let P_inv = Pa-1(s("P_inv"), ..sig_figs(5))

  $ P = (#P_0) + ((#F_g)) / ((#A)) $
  $ P = #P $

  $ P^(-1) = 1/((#P)) $
  $ P^(-1) = #P_inv $
]

#figure(
  {
    let format = (none,) + (auto,) * 2 + (decimal_places(0), decimal_places(2),) + (sig_figs(5),) * 2
    show table: format-table(..format)
    table(
      columns: format.len(),
      table.header(
        [Sample],
        [$m$ (#zi.gram())],
        [$L$ (#zi.mm())],
        [$M$ (#zi.gram())],
        [$F_g$ (#zi.N())],
        [$P$ (#zi.Pa())],
        [$P^(-1)$ (#Pa-1())],
      ),
      ..csv_helper(
        main_data_fname,
        (
          "sample",
          "m",
          "L",
          "M",
          "F_g",
          "P",
          "P_inv",
        )
      ),
    )
  },
  caption: [Quantities Used to Find Pressure and its Reciprocal]
) <tb_pressure_calculation>

#figure(
  image("media/L-v-P-inverse.svg"),
  caption: [
    Response of the Enclosed Gas to Additional Force
    $ L = (#slope) P^(-1) + (#intercept) $ <eq_linear_fit>
  ],
) <fg_L_vs_P_inv>

@fg_L_vs_P_inv plots $L$ versus $P^(-1)$.
As more mass $m$ was put on the piston platform, the force exerted on the enclosed gas increased, thereby increasing the pressure $P$.
As $P$ increased, the reciprocal of the pressure $P^(-1)$ decreased.
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

Combining @eq_ideal_gas_law with @eq_total_volume and rearranging yields @eq_L_P_inv_linear_relation.

$ P (V_0 + L A) = n R T $
$ P L A = n R T - P V_0 $
$ L = underbrace((n R T)/A, "slope") P^(-1) underbrace(-V_0/A, "y-intercept") $ <eq_L_P_inv_linear_relation>

Notice that $L$ is linear with respect to $P^(-1)$.
The slope of such a plot is given by @eq_slope, and the y-intercept is given by @eq_intercept.
Since the data in @fg_L_vs_P_inv lie on a straight line as predicted, the experiment verifies Boyle's law.

$ "slope" = (n R T)/A $ <eq_slope>
$ "y-intercept" = -V_0/A $ <eq_intercept>

The equation for the line of best fit for the data is given by @eq_linear_fit.
The slope has a value of #slope, and the y-intercept has a value of #intercept.

Rearranging @eq_slope yields @eq_mol, which can be used to find the moles of gas enclosed $n$.
Substituting in values gives #n, as shown in @eq_mol_calculation.

$
n = ("slope" dot A) / (R T)
$ <eq_mol>
$
n = ((#slope) (#A)) / ((#R) (#T)) = #n
$ <eq_mol_calculation>

Rearranging @eq_intercept yields @eq_V_0, which can be used to find the volume of the 2-liter bottle and tubing $V_0$.
Substituting in values gives #V_0, as shown in @eq_V_0_calculation.
This volume, slightly larger than #zi.liter(2), is consistent with the fact that a 2-liter bottle was used with a small connecting tube.

$
V_0 = -("y-intercept") A
$ <eq_V_0>
$
V_0 = -(#intercept) (#A) dot zi.liter(1000)/m3(1) = #V_0
$ <eq_V_0_calculation>

@tb_calculated_quantities provides a summary of all the calculated quantities that were not made for an individual sample in particular.

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
      $A$, A,
      $"slope"$, slope,
      $"y-intercept"$, intercept,
      $n$, n,
      $V_0$, V_0,
    )
  },
  caption: [Summary of Calculated Quantities]
) <tb_calculated_quantities>

