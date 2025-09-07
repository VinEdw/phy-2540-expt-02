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

= Results

@tb_misc_quantities contains various quantities, both measured and given, that will be relevant to the analysis.
They were collected in a table to assist with lookup.

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
    )
  },
  caption: [Miscellaneous Quantities]
) <tb_misc_quantities>

= Analysis

