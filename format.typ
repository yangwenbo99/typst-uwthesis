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

#let running_name(level: 2, body) = {
  /* If your chapter/section name is too long, define a shorter 
  * version for the header using this function.
  */
  context({
    let info = (
       level: level,
       body: body,
       page: here().page(),
       y: here().position().at("y"),
    )
    if (level == 1) [
      #metadata(info)<uw-ethesis-header-chapter>
    ] else if (level == 2) [
      #metadata(info)<uw-ethesis-header-section>
    ] else [
      #panic("Only level 1 and level 2 headings can have running names.")
    ]
  })
}


#let findHeadingsAt(
  level: 1, after_page: -1, after_y: none, by_page: -1, by_y: none) = {
  /* Find the headings satisfying the following conditions:
  * - at level `level`
  * - after the position specified by `after_page` and `after_y` (inclusive)
  * - by the page specified by `by_page` and by_y (by_y is exclusive)
  */
  let isPassed(heading) = {
    let headPos = heading.location().position()
    if (after_page != -1) {
      if (headPos.at("page") < after_page) {
        return false
      }
      if (headPos.at("page") == after_page and after_y != none and headPos.at("y") < after_y) {
        return false
      }
    }
    if (by_page != -1) {
      if (headPos.at("page") > by_page) {
        return false
      }
      if (headPos.at("page") == by_page and by_y != none and headPos.at("y") >= by_y) {
        return false
      }
    }
    return true
  }
  query(heading).filter(headIt => {
    headIt.level == level and isPassed(headIt)
  })
}

#let isLocation1BeforeLocation2(p1, y1, p2, y2) = {
  // if a none is given for y, it is assumed to be containing the whole page
  if (p1 < p2) {
    return true
  }
  if (p1 == p2 and y1 != none and y1 < y2 ) {
    return true
  }
  return false
}

#let getHeader() = {
  /* The header is of thew following format:
  * Chapter Name, Section Name
  *
  * If a new sections starts in this page, the chapter name and section name
  * will correspond to the new section.  
  * If a new chapter starts in this page without a new section, only the chapter name will be shown.
  * Otherwise, the chapter name and section name will correspond to the last chapter and section that appear in the previous pages.
  */
  context({
    let EPS = 0.5cm
    let currentPage = here().page()
    let mainHeadings = findHeadingsAt(
      level: 1, 
      by_page: currentPage
    )
    let mainHeading = {
      if mainHeadings.len() > 0 and mainHeadings.last().location().page() == currentPage {
        // if a chapter starts in the new page, we need to select the first one that appears in the page
        mainHeadings.filter(headIt => headIt.location().page() == currentPage).first()
      } else if mainHeadings.len() > 0 {
        mainHeadings.last()
      }
    }
    let nextMainHeading = if mainHeading != none {
      findHeadingsAt(
        level: 1, 
        after_page: currentPage,
        after_y: mainHeading.location().position().at("y") + EPS
      ).first(default: none)
    }
    // The start of searching for the secondary heading
    let secondaryAfterLocation = {
      if mainHeading != none {
        (after_page: mainHeading.location().page(), after_y: mainHeading.location().position().at("y"))
      } else {
        (after_page: currentPage)
      }
    }

    let secondaryByLocation = {
      if nextMainHeading != none {
        let p1 = currentPage
        let p2 = nextMainHeading.location().page()
        let y2 = nextMainHeading.location().position().at("y")
        if (isLocation1BeforeLocation2(p1, none, p2, y2)) {
          (by_page: currentPage)
        } else {
          (by_page: nextMainHeading.location().page(), by_y: nextMainHeading.location().position().at("y"))
        }
      } else {
        (by_page: currentPage)
      }
    }
    let secondaryHeadings = findHeadingsAt(
      level: 2, 
      ..secondaryAfterLocation,
      ..secondaryByLocation
    )
    let secondaryHeading = {
      if secondaryHeadings.len() > 0 and secondaryHeadings.last().location().page() == currentPage {
        // if a section starts in the new page, we need to select the first one that appears in the page
        secondaryHeadings.filter(headIt => headIt.location().page() == currentPage).first()
      } else if secondaryHeadings.len() > 0 {
        secondaryHeadings.last()
      }
    }
    let nextSecondaryHeading = {
      if secondaryHeading != none {
        findHeadingsAt(
          level: 2, 
          after_page: secondaryHeading.location().page(),
          after_y: secondaryHeading.location().position().at("y") + EPS
        ).first(default: none)
      } else {
        none
      }
    }
    let nextHeadingLocation = {
      if nextSecondaryHeading != none and nextMainHeading != none {
        if isLocation1BeforeLocation2(nextSecondaryHeading.location().page(), nextSecondaryHeading.location().position().at("y"), nextMainHeading.location().page(), nextMainHeading.location().position().at("y")) {
          nextSecondaryHeading.location()
        } else {
          nextMainHeading.location()
        }
      } else if nextSecondaryHeading != none {
        nextSecondaryHeading.location()
      } else if nextMainHeading != none {
        nextMainHeading.location()
      } else {
        none
      }
    }


    // Try find running names for the main heading and secondary heading
    let mainRunningHeading = {
      if mainHeading != none {
        query(<uw-ethesis-header-chapter>).find(it => (
          isLocation1BeforeLocation2(mainHeading.location().page(), mainHeading.location().position().at("y"), it.value.page, it.value.at("y")) and
          (
            nextMainHeading == none or
            isLocation1BeforeLocation2(it.value.page, it.value.at("y"), nextMainHeading.location().page(), nextMainHeading.location().position().at("y"))
          )
        ))
      } else {
        none
      }
    }

    let secondaryRunningHeading = {
      if secondaryHeadings.len() > 0 {
        query(<uw-ethesis-header-section>).find(it => (
          // it.page() == secondaryHeadings.first().location().page() and it.position().at("y") == secondaryHeadings.first().location().position().at("y")
          isLocation1BeforeLocation2(secondaryHeading.location().page(), secondaryHeading.location().position().at("y"), it.value.page, it.value.at("y")) and
          (
            nextHeadingLocation == none or
            isLocation1BeforeLocation2(it.value.page, it.value.at("y"), nextHeadingLocation.page(), nextHeadingLocation.position().at("y")
          )
        )
        ))
      } else {
        none
      }
    }

    
    let mainName = {
      if mainRunningHeading != none {
        mainRunningHeading.value.body
      } else if mainHeading != none {
        mainHeading.body
      } else {
        ""
      }
    }
    let secondaryName = {
      if secondaryRunningHeading != none {
        secondaryRunningHeading.value.body
      } else if secondaryHeading != none {
        secondaryHeading.body
      } else {
        ""
      }
    }

    return buildSecondaryHeader(mainName, secondaryName)

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

#let print_glossary(glossaries, name, bold: true, html: false) = {
  let to_print = ()
  for (key, value) in glossaries.at(name).pairs() {
    // let (abbr, full) = value
    let abbr = value.at(0)
    let full = value.at(1)
    to_print.push([#if bold [*#abbr*] else [#abbr] #label(GLS_PREFIX + key)])
    to_print.push(full)
  }
  if not html {
    grid(
      columns: 2,
      gutter: 3mm,
      ..to_print
    )
  } else {
    table(
      columns: 2,
      gutter: 3mm,
      ..to_print
    )
  }
}

#let GLOSSARIES = state("glossaries", (:))
#let PRINTED_GLOSSARIES = state("printed_glossaries", ())

#let gls(name, shown_as: none) = {
  let contents = context( {
    // let glossaries = GLOSSARIES.at(loc)
    let glossaries = GLOSSARIES.get()
    let shown = shown_as
    for table in glossaries.values() {
      if table.len() == 0 {
        continue
      }
      if name in table.keys() {
        if table.at(name).len() > 2 {
          if shown_as == none {
            shown = table.at(name).at(2)
          }
          // link(label(GLS_PREFIX + name))[#table.at(name).at(2)]
        // } else if name not in PRINTED_GLOSSARIES.at(loc) {
        } else if name not in PRINTED_GLOSSARIES.get() {
          if shown_as == none {
            shown = [#table.at(name).at(1) (#table.at(name).at(0))]
          } else {
            shown = [#shown_as (#table.at(name).at(0))]
          }
          // link(label(GLS_PREFIX + name))[#table.at(name).at(1) (#table.at(name).at(0))]
        } else {
          if shown_as == none {
            shown = table.at(name).at(0)
          }
          // link(label(GLS_PREFIX + name))[#table.at(name).at(0)]
        }
        link(label(GLS_PREFIX + name))[#shown]
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
  declaration: "", 
  statement: none,
  acknowledgements: "", 
  dedication: none, 
  glossaries: (abbreviation: (:),),
  indent: 1cm,
  pdf_ua: false,
  html: false,
  body
) = {
  set page(
    paper: "us-letter", 
    margin: (outside: 1.0in, inside: 1.125in, bottom:1.125in+0.4in, top: 1.125in + 0.4in),
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
  // After careful inspection of the specification, I found no violation of 
  // UW's policy for simply using equations in (1) format.
  set math.equation(numbering: "(1)")
  set heading(numbering: "1.1")
  set par(justify: true)

  // show heading.where(level: 1): set text(size: 24pt)
  show heading.where(level: 2): set text(size: 18pt)
  show heading.where(level: 3): set text(size: 14pt)

  show outline.entry.where(level: 1): it => {
    v(16pt, weak: true)
    // strong(it)
    if pdf_ua {
      it
    } else {
      strong(it)
    }
  }
  show outline.entry.where(level: 2): it => {
    it
  }
  show link: set text(fill: blue)
  show ref: it => {
    let eq = math.equation
    let hd = heading
    let el = it.element
    if el != none and el.func() == eq {
      // Override equation references.
      link(el.label)[#numbering(
        el.numbering,
        ..counter(eq).at(el.location())
      )]
    } else if el != none and el.func() == hd {
      // Override equation references.
      text(fill: blue.darken(60%))[#it]
    } else {
      // Other references as usual.
      it
    }
  }
  show cite: set text(fill: green)


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
  if committee_members != none {
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
    if not html {
      grid(
        columns: 2,
        gutter: 3mm,
        ..commitee_body
      )
    } else {
      grid(
        columns: 2,
        gutter: 3mm,
        ..commitee_body
      )
    }

    pagebreak()
  }

  if declaration != none {
    small_title([Author’s Declaration])
    if declaration == "sole" [
      I hereby declare that I am the sole author of this thesis. This is a true copy of the thesis, including any required final revisions, as accepted by my examiners.

      I understand that my thesis may be made electronically available to the public.
    ] else if declaration == "compiled" [
      This thesis consists of material all of which I authored or co-authored: see Statement of Contributions included in the thesis. This is a true copy of the thesis, including any required final revisions, as accepted by my examiners.

      I understand that my thesis may be made electronically available to the public.
    ] else [
      The author makes no declaration yet. 

      If you are using the template for your thesis, you _must_ either use the word `"sole"` or `"compiled"` for the `declaration` parameter to satisfy #link("https://uwaterloo.ca/current-graduate-students/academics/thesis-and-defence/thesis-formatting#declaration")[UW's requirements].  
      If you are using this template for other documents (e.g., your research proposal), you can set its value to `none` to avoid showing this message.
    ]
    pagebreak()
  }

  if statement != none {
    set heading(numbering: none, outlined: false)
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

  if acknowledgements != none {
    small_title([Acknowledgements])
    if acknowledgements != "" {
      acknowledgements
    } else {
      [
        You must provide an acknowledgement for your thesis.
        If this document is not your final thesis, you can set the value of `acknowledgements` to `none` to avoid showing this message.
      ]
    }
    pagebreak()
  }

  if dedication != none {
    small_title([Dedication])
    dedication
    pagebreak()
  }

  show heading.where(level: 1): it => [
      #set text(size: 24pt)
      #v(1.5in)
      #par(first-line-indent: 0pt)[#it.body]
      #v(1.5cm)
  ]


  // Table of contents.
  heading("Table of Contents", numbering: none, outlined: false)
  outline(
    title: none,
    depth: 3, indent: indent,
  )
  pagebreak()

  heading("List of Figures", numbering: none)
  outline(
    title: none, 
    depth: 3, indent: indent,
    target: figure.where(kind: image),
  )
  pagebreak()

  heading("List of Tables", numbering: none)
  outline(
    title: none,
    depth: 3, indent: indent,
    target: figure.where(kind: table)
  )
  pagebreak()

  GLOSSARIES.update(glossaries)

  heading(
    outlined: true,
    numbering: none,
    text("List of Abbreviations"),
  )
  print_glossary(glossaries, "abbreviation", bold: true, html: html)
  pagebreak()

  if glossaries.at("symbol").len() > 0 {
    heading(
      outlined: true,
      numbering: none,
      text("List of Symbols"),
    )
    print_glossary(glossaries, "symbol", bold: false, html: html)
  }

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
      #v(1.5cm, weak: true)
  ]
  show heading.where(level: 2): it => [
      #set text(size: 18pt)
      #v(1cm, weak: true)
      #block[
        #if it.numbering != none [
          #counter(heading).display() 
        ]
        #it.body
      ]
      #v(1cm, weak: true)
  ]
  show heading.where(level: 2): set text(size: 18pt)
  show heading.where(level: 3): set text(size: 14pt)

  body

  pagebreak(weak: true)
  heading(
    outlined: true,
    numbering: none,
    text("Glossary"),
  )
  print_glossary(glossaries, "glossary", html: html)
}

#let appendix(body) = {
  set heading(numbering: "A.1.1.1")
  counter(heading).update(0)
  body
}

