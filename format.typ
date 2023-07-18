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
#let small_title(content) = {
  align(center)[
    #heading(
      outlined: false,
      numbering: none,
      text(0.85em,content),
    )
    #v(5mm)
  ]
}


#let project(
  title: "",
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
  declearation: "none", 
  body
) = {
  set page(
    paper: "us-letter", 
    margin: 1.0625in
  )
  set text(
    size: 12pt,
    font: "Times New Roman",
    stretch: 120%
  )

  // Set the document's basic properties.
  set document(author: author, title: title)
  set text(font: "New Computer Modern", lang: "en")
  show math.equation: set text(weight: 400)
  set heading(numbering: "1.1")
  set par(justify: true)

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

    A thesis \
    presented to #affiliation \
    in fulfillment of the \
    thesis requirement for the degree of \
    #degree \
    in \
    #major \

    #v(2cm)
    #city

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

  small_title([Examining Committee Membership])
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
  small_title([Author’s Declaration])

  pagebreak()

  // Abstract page.
  set page(numbering: "i", number-align: center)
  v(1fr)
  small_title([Abstract])
  abstract
  v(1.618fr)
  counter(page).update(1)
  pagebreak()

  // Table of contents.
  outline(depth: 3, indent: true)
  pagebreak()


  // Main body.
  set page(numbering: "1", number-align: center)
  set par(first-line-indent: 20pt)
  set page(header: getHeader())
  counter(page).update(1)
  body
}

#let committee(
) = {
  grid(
    width: 100%, 
    ..members.map(mitem => [
    ])
  )
}
