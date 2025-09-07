#import "phys-conf.typ": conf, csv_helper, sample_calculation, sig_figs, decimal_places
#import "@preview/zero:0.5.0"
#import "@preview/zero:0.5.0": num, zi

#show: conf.with(
  title: [Equation of State for an Ideal Gas],
  author: (first_name: "Vincent", last_name: "Edwards"),
  partner: (first_name: "Gina", last_name: "Herrera"),
  date: datetime(year: 2025, month: 9, day: 12),
)

#let misc_data = json("data/misc-data.json")
#let raw_misc_data = json("data/raw-misc-data.json")

#let degreeF = zi.declare($degree "F"$)

#let T = misc_data.at("T")
#let T_disp = zi.K(T, ..decimal_places(2))

= Results

@tb_misc_quantities contains various quantities, both measured and given, that will be relevant to the analysis.
They were collected in a table to assist with lookup.

#[
  #let T_F = raw_misc_data.at("T")
  #let T_F_disp = degreeF(T_F)

  $T$ is the temperature of the room measured using a digital thermometer.
  The temperature was initially measured as #T_F_disp, then converted to kelvins as show in @eq_temperature_conversion.

  $
  T = (5/9 (#T_F - 32) + 273.15) space.quarter #zi.K() = #T_disp
  $ <eq_temperature_conversion>
]

#figure(
  {
    let format = (none, auto)
    show table: zero.format-table(..format)
    table(
      columns: format.len(),
      table.header(
        [Quantity],
        [Value],
      ),
      $T$, T_disp,
    )
  },
  caption: [Miscellaneous Quantities]
) <tb_misc_quantities>

= Analysis

