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

