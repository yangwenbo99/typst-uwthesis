// https://github.com/zagoli/simple-typst-thesis/blob/main/template.typ
#let buildMainHeader(mainHeadingContent) = {
  [
    #align(center, smallcaps(mainHeadingContent)) 
    #line(length: 100%)
  ]
}

#let buildSecondaryHeader(mainHeadingContent, secondaryHeadingContent) = {
  [
    #smallcaps(mainHeadingContent)  #h(1fr)  #emph(secondaryHeadingContent) 
    #line(length: 100%)
  ]
}

// To know if the secondary heading appears after the main heading
#let isAfter(secondaryHeading, mainHeading) = {
  let secHeadPos = secondaryHeading.location().position()
  let mainHeadPos = mainHeading.location().position()
  if (secHeadPos.at("page") > mainHeadPos.at("page")) {
    return true
  }
  if (secHeadPos.at("page") == mainHeadPos.at("page")) {
    return secHeadPos.at("y") > mainHeadPos.at("y")
  }
  return false
}

#let getHeader() = {
  locate(loc => {
    // Find if there is a level 1 heading on the current page
    let nextMainHeading = query(selector(heading).after(loc), loc).find(headIt => {
     headIt.location().page() == loc.page() and headIt.level == 1
    })
    if (nextMainHeading != none) {
      return buildMainHeader(nextMainHeading.body)
    }
    // Find the last previous level 1 heading -- at this point surely there's one :-)
    let lastMainHeading = query(selector(heading).before(loc), loc).filter(headIt => {
      headIt.level == 1
    }).last()
    // Find if the last level > 1 heading in previous pages
    let previousSecondaryHeadingArray = query(selector(heading).before(loc), loc).filter(headIt => {
      headIt.level > 1
    })
    let lastSecondaryHeading = if (previousSecondaryHeadingArray.len() != 0) {previousSecondaryHeadingArray.last()} else {none}
    // Find if the last secondary heading exists and if it's after the last main heading
    if (lastSecondaryHeading != none and isAfter(lastSecondaryHeading, lastMainHeading)) {
      return buildSecondaryHeader(lastMainHeading.body, lastSecondaryHeading.body)
    }
    return buildMainHeader(lastMainHeading.body)
  })
}

#let invisible_heading(level: 1, numbering: none, supplement: auto, 
    outlined: true, content) = {
  // show heading.where(level: level): set text(size: 0em, color: red)
  show heading.where(level: level): it => block[]
  text(size: 0pt)[
    #heading(level: level, numbering: numbering, supplement: supplement, outlined: outlined)[#content]
  ]
}

#let small_title(content, outlined: true) = {
  align(center)[
    // #show heading.where(level: 1): set text(size: 0.85em)
    #show heading.where(level: 1): it => block[
      #set text(size: 0.85em)
      #it.body
    ]
    #heading(
      outlined: outlined,
      numbering: none,
      content
      // text(0.85em,content),
    )
    #v(5mm)
  ]
}

#let GLS_PREFIX = "gls-auto-"

#let print_glossary(glossaries, name, bold: true) = {
  let to_print = ()
  for (key, value) in glossaries.at(name).pairs() {
    // let (abbr, full) = value
    let abbr = value.at(0)
    let full = value.at(1)
    to_print.push([#if bold [*#abbr*] else [#abbr] #label(GLS_PREFIX + key)])
    to_print.push(full)
  }
  grid(
    columns: 2,
    gutter: 3mm,
    ..to_print
  )
}

#let GLOSSARIES = state("glossaries", (:))
#let PRINTED_GLOSSARIES = state("printed_glossaries", ())

#let gls(name) = {
  let contents = locate(loc => {
    let glossaries = GLOSSARIES.at(loc)
    for table in glossaries.values() {
      if name in table.keys() {
        if table.at(name).len() > 2 {
          link(label(GLS_PREFIX + name))[#table.at(name).at(2)]
        } else if name not in PRINTED_GLOSSARIES.at(loc) {
          link(label(GLS_PREFIX + name))[#table.at(name).at(1) (#table.at(name).at(0))]
        } else {
          link(label(GLS_PREFIX + name))[#table.at(name).at(0)]
        }
        break
      }
    }
  }
  )
  contents
  PRINTED_GLOSSARIES.update(curr => {
    if name not in curr {
      curr.push(name)
    }
    curr
  })
  // [#glossaries]
}


#let project(
  title: "",
  doc_type: "thesis", 
  abstract: [],
  author: "",
  email: "",
  affiliation: "",
  address: "",
  city: "Waterloo, Ontario, Canada", 
  degree: "Doctor of Philosophy",
  major: "",
  year: "2023",
  logo: none,
  committee_members: (
    (
     position: "Examiner",
     persons: (
      (
        name: "Ann Elk",
        title: "Professor", 
        department: "Dept. of Zoology",
        affiliation: "University of Waterloo"
      ), 
     )
    ), 
  ), 
  declaration: "none", 
  statement: "",
  acknowledgements: "", 
  dedication: "", 
  glossaries: (abbreviation: (:),),
  body
) = {
  set page(
    paper: "us-letter", 
    margin: (rest: 1.0625in, inside: 1.125in, bottom:1.125in+0.4in, top: 1.125in + 0.4in),
    header-ascent: 0.4in,
    footer-descent: 0.3in
  )

  // Set the document's basic properties.
  set document(author: author, title: title)
  // set text(font: "New Computer Modern", lang: "en")
  set text(
    size: 12pt,
    // font: "Times_New_Roman",
    font: "New Computer Modern",
    stretch: 120%, 
    lang: "en"
  )
  show math.equation: set text(weight: 400)
  // set math.equation(numbering: "(1.1)") // Currently not directly supported by typst
  set math.equation(numbering: "(1)")
  set heading(numbering: "1.1")
  set par(justify: true)

  // show heading.where(level: 1): set text(size: 24pt)
  show heading.where(level: 2): set text(size: 18pt)
  show heading.where(level: 2): set text(size: 18pt)
  show heading.where(level: 3): set text(size: 14pt)

  // Title page.
  v(0.25fr)
  align(center)[
    #text(2em, weight: 700, title)
  ]

  v(1cm)
  align(center)[by]
  v(1cm)

  // Author information.
  align(center)[
    #text(size: 16pt)[#author] \
    #if email != "" [#email \ ] 

    #v(2cm)

    A #doc_type \
    presented to #affiliation \
    in fulfillment of the \
    thesis requirement for the degree of \
    #degree \
    in \
    #major \

    #v(2cm)
    #city, #year

    #v(1cm)
    © #author #year \

  ]

  // Logo
  if logo != none {
    v(0.25fr)
    align(center, image(logo, width: 26%))
    v(0.50fr)
  } else {
    v(0.75fr)
  }
  
  pagebreak()
  set page(numbering: "i", number-align: center)

  // committee
  let commitee_body = ()
  for mitem in committee_members {
    let pos_printed = false
    for person in mitem.persons {
      if pos_printed {
        commitee_body.push("")
      } else {
        commitee_body.push(mitem.position + ": ")
      }
      pos_printed = true
      commitee_body.push([
        #person.name \
        #person.title, #person.department, #person.affiliation
      ])
    }
    commitee_body.push(v(1.5cm))
    commitee_body.push(v(1.5cm))
  }

  small_title(outlined: false)[Examining Committee Membership]
  invisible_heading([Examining Committee])

  [
    The following served on the Examining Committee for this thesis. The decision of the
    Examining Committee is by majority vote.
    #v(1cm)
  ]
  grid(
    columns: 2,
    gutter: 3mm,
    ..commitee_body
  )

  pagebreak()

  if declaration != "none" {
    small_title([Author’s Declaration])
    if declaration == "sole" [
      I hereby declare that I am the sole author of this thesis. This is a true copy of the thesis, including any required final revisions, as accepted by my examiners.

      I understand that my thesis may be made electronically available to the public.
    ] else if declaration == "compiled" [
      This thesis consists of material all of which I authored or co-authored: see Statement of Contributions included in the thesis. This is a true copy of the thesis, including any required final revisions, as accepted by my examiners.

      I understand that my thesis may be made electronically available to the public.
    ] else [
      The author makes no declaration yet. 
    ]
    pagebreak()
  }

  if statement != "" {
    small_title([Statement of Contributions])
    statement
    pagebreak()
  }

  // Abstract page.
  // v(1fr)
  small_title([Abstract])
  abstract
  // v(1.618fr)
  pagebreak()

  small_title([Acknowledgements])
  acknowledgements

  pagebreak()

  if dedication != "" {
    small_title([Dedication])
    dedication
  }
  pagebreak()

  show heading.where(level: 1): it => [
      #set text(size: 24pt)
      #v(1.5in)
      #par(first-line-indent: 0pt)[#it.body]
      #v(1.5cm)
  ]


  // Table of contents.
  outline(
    title: "Table of Contents", 
    depth: 3, indent: true
  )
  pagebreak()

  invisible_heading("List of Figures")
  outline(
    title: "List of Figures", 
    depth: 3, indent: true,
    target: figure.where(kind: image)
  )
  pagebreak()

  invisible_heading("List of Tables")
  outline(
    title: "List of Tables", 
    depth: 3, indent: true,
    target: figure.where(kind: table)
  )
  pagebreak()

  GLOSSARIES.update(glossaries)

  heading(
    outlined: true,
    numbering: none,
    text("List of Abbreviations"),
  )
  print_glossary(glossaries, "abbreviation", bold: false)
  pagebreak()

  heading(
    outlined: true,
    numbering: none,
    text("List of Symbols"),
  )
  print_glossary(glossaries, "symbol")

  // Main body.
  set page(numbering: "1", number-align: center)
  set par(first-line-indent: 20pt)
  set page(header: getHeader())
  counter(page).update(1)
  
  // set gls(glossaries: glossaries)

  show heading.where(level: 1): it => [
      // #pagebreak(weak: true)
      #set text(size: 24pt)
      #v(1.5in)
      #block[
        #if it.numbering != none [
          Chapter #counter(heading).display() 
          #v(0.5cm)
        ]
        #par(first-line-indent: 0pt)[#it.body]
      ]
      #v(1.5cm)
  ]

  body
}

#let appendix(body) = {
  set heading(numbering: "A.1.1.1")
  counter(heading).update(0)
  body
}

