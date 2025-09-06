#let conf(
  doc,
  title: [Clever Title],
  author: (
    first_name: "First",
    last_name: "Last",
  ),
  partner: (
    first_name: "First",
    last_name: "Last",
  ),
  date: datetime.today(),
) = {
  // Document Metadata
  let author_name = author.first_name + " " + author.last_name
  let partner_name = partner.first_name + " " + partner.last_name
  set document(
    title: title,
    author: author_name + " and " + partner_name,
  )

  // Page size and numbering
  set page(
    "us-letter",
    header: context {
      if counter(page).get().first() > 1 { 
        emph(title)
        h(1fr)
        author.last_name
        sym.space
        counter(page).display("1")
      }
    },
  )

  // Headings
  set heading(numbering: "1.a.")

  // Equation numbering
  set math.equation(numbering: "(1)")

  // LaTeX-ish Look
  set page(margin: 1in)
  set par(justify: true)
  set text(font: "New Computer Modern")
  show raw: set text(font: "New Computer Modern Mono")
  show heading: set block(above: 1.4em, below: 1em)

  // Tables
  show figure.where(
    kind: table
  ): set figure.caption(position: top)
  set table(stroke: (x, y) => (
    top: if y == 0 { 1pt } else if y == 1 { none } else { 0pt },
    bottom: if y > 0 { 1pt } else { 0.5pt },
  ))

  // Title
  stack(
    dir: direction.ttb,
    spacing: 1em,
    text(17pt, weight: "bold", title),
    text(12pt, [By #author_name]),
    text(12pt, [Lab Partner: #partner_name]),
    text(12pt, date.display("[month repr:long] [day padding:none], [year]")),
  )
  // Main Document
  doc
}

#let csv_helper(fname, desired_cols) = {
  let data = csv(fname, row-type: dictionary)

  let cells = for row in data {
    for col in desired_cols {
      (row.at(col),)
    }
  }

  return cells
}

#let sample_calculation(body, name: [Trial 1]) = {
  block(
    stroke: black,
    inset: 1.2em,
    width: 100%,
    {
      strong[Sample Calculation (#name)]
      v(1.2em)
      body
    }
  )
}

// Helper function for setting significant figures with the Zero package
#let sig_figs(sig_figs) = (round: (mode: "figures", precision: sig_figs))
// Helper function for setting decimal places with the Zero package
#let decimal_places(places) = (round: (mode: "places", precision: places))

