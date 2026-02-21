#import "format.typ": project, appendix, gls
#import "glossaries.typ": GLOSSARIES

#show: project.with(
  title: "University of Waterloo E-Thesis Template for typst",
  doc_type: "theis", 
  author: "Pat Neugraad", 
  affiliation: "the University of Waterloo", 
  major: "Philosophy of Zoology",
  address: "Waterloo, Ontario, Canada", 
  year: "2026",
  committee_members: (
    (
     position: "External Examiner",
     persons: (
      (
        name: "Bruce Bruce",
        title: "Professor", 
        department: "Dept. of Philosophy of Zoology",
        affiliation: "University of Wallamaloo"
      ), 
     )
    ), 
    (
     position: "Supervisor(s)",
     persons: (
      (
        name: "Ann Elk",
        title: "Professor", 
        department: "Dept. of Zoology",
        affiliation: "University of Waterloo"
      ), 
      (
        name: "Andrea Anaconda",
        title: "Professor Emeritus", 
        department: "Dept. of Zoology",
        affiliation: "University of Waterloo"
      ), 
     )
    ), 
    (
     position: "Intertnal Member",
     persons: (
      (
        name: "Pamela Python",
        title: "Professor", 
        department: "Dept. of Zoology",
        affiliation: "University of Wallamaloo"
      ), 
     )
    ), 
    (
     position: "Intertnal-External Member",
     persons: (
      (
        name: "Meta Meta",
        title: "Professor", 
        department: "Dept. of Philosophy",
        affiliation: "University of Wallamaloo"
      ), 
     )
    ), 
    (
     position: "Other member(s)",
     persons: (
      (
        name: "Leeping Fang",
        title: "Professor", 
        department: "Dept. of Fine Art",
        affiliation: "University of Wallamaloo"
      ), 
     )
    ), 
  ), 
  abstract: lorem(59),
  // You may hide the declaration, dedication, statement, acknowledgements & dedication
  // by setting their values to empty
  // Note that 
  declaration: "",
  dedication: "This is dedicated to the one I love.  You may remove this section by setting this to none",
  statement: [
    A detailed contribution statement should be put here if your thesis contains writting materials you co-authored with others.

    == Some titles might be needed here
    but they will not be indexed into the table of contents, and they will not be numbered.
  ],
  acknowledgements: [
    Hopefully, I will be able to thank everyone who made my graduation possible.
  ],
  glossaries: GLOSSARIES,
  /*
  * Currently, Typst will refuse to compile to PDF/UA if certain formatting
  * features are used.  Use this option to disable these features and compile 
  * to PDF/UA.
  */
  pdf_ua: false,
  html: false,
)

// #committee
//
= Introduction
#label("introduction")


In the beginning God created the heaven and the earth.



== Nowadays
#label("state-of-the-art")

A #gls("computer") can be used to simulate sampling a random vector #gls("rvec") @goossens.book.
If #gls("rvec") is a Gaussian random vector, then Its marginal distribution can be calculated as 
$
p(v_i) = 1 / sqrt(2 pi sigma_i^2) exp(- (v_i - mu_i)^2 / (2 sigma_i^2)).
$<equ-gaussian>


== Some Meaningless Stuff
#label("some-meaningless-stuff")

Thanks to #gls("aaaaz"), we are able to use #gls("computer", shown_as: "computers") to simulate sampling #gls("rvec", shown_as: "random vectors") @goossens.book.

#lorem(300)

#pagebreak(weak: true)
= Observations
#label("observations")

#figure(
  box(
    width: 3in,
    height: 2in,
    stroke: black,
  )[Let's say this is a figure.],
  caption: [
    This is a figure caption.  You can put any content here, including math formulae, lists, and so on.  The figure will be automatically numbered and indexed into the list of figures.
  ],
  alt: "It's a good practice to provide an alternative text description for your figures"
)<fig-1>


You can put figures here.  Use the `@` symbol to refer to them, for example: @fig-1.


- JPEG with reasonable resolution and compresison is suggested for photos.
- Your drawings should ideally be output in SVG (or PDF).  
  EPS is also a good format, as it supports scalable vector graphics.  You may convert it to PDF if you want to include it in a Typst file. Only use PNG when your drawing software does not support SVG or PDF.
  See UW's LaTeX thesis template for information about using MATLAB to generate plots as PDFs. 
- Sometimes, the #link("https://cetz-package.github.io/")[CeTZ package]
  in Typst is a good candidate for making simple figures.

For more information on LaTeX  see 
#link("uwaterloo.atlassian.net/wiki/spaces/ISTSERV/pages/42589978807/LaTeX+for+E-Thesis+and+large+documents")[these
notes]. #super[2]

#pagebreak(weak: true)
#bibliography("uw-ethesis.bib", title: [References])

// #set heading(numbering: "A.1.1.1")
// #counter(heading).update(0)
#show: appendix

#pagebreak(weak: true)
#heading("APPENDICES", numbering: none)
#label("appendices")


#pagebreak(weak: true)

= Specific Notes for Accessibility Concerns

+ The PDF format of the thesis must conform to the PDF/A _or_ PDF/UA standards whenever technically feasible, per #link("https://uwaterloo.ca/lib/uwspace/thesis-submission-guide/formatting-your-thesis")[University requirements].  This template can be used to compile PDA/A:
  ```bash
  typst compile --pdf-standard a-4 uw-ethesis.typ
  typst compile --pdf-standard a-3b uw-ethesis.typ
  ```
  There are multiple levels of PDF/A, level A for PDF/A-1 through PDF/A-3 is the most strict one, and it is (probably) the best for disabled users.  However,  their compilation is not straightforward.  See @sec-pdf-ua for discussion.
+ The PDF format is a sh\*tpile format for _printing_ (not for reading on screen) from 1993.  In my personal opinion, for an accessibility standpoint, the most reasonable solution is to compile to HTML.  First, toggle on the `html` feature in the project block.
  ```bash
  typst compile --features=html --format=html uw-ethesis.typ
  ```
+ Additionally, consider reading #link("https://typst.app/docs/guides/accessibility/")[Typst's accessibility guide] for tips on making your thesis more accessible to readers with disabilities, readers using non-orthodox devices, and artificial intelligence.


== Compiling to PDF/UA
<sec-pdf-ua>

  The compilation to PDF/A-Aa or PDF/UA is not straightforward.  First, you need to use the `pdf_ua` option in the project block to disable certain formatting features that interfere with Typst's compilation to PDF/UA.
  ```bash
  typst compile --pdf-standard ua-1 uw-ethesis.typ
  ```

  However, you need to add alternate text descriptions to all your figures and equations.  By the time I am making this template, Typst has just #link("https://github.com/quarto-dev/quarto-cli/issues/13870")[merged the new syntax for alternate text for equations].  You should be able use it in the next release. 


== The HTML format

Cimpilintg Typst to HTML is still experimental.  Currently, the largest issue is also formulae.  You can use #link("https://github.com/a-for-short/html-typst-equation-renderer")[HTML Typst Equation Renderer] to render equations as embeded SVG images in the HTML output.  This is a good solution for mobile phone users and (probably) for people with limited vision, but it is certainly not for screen readers.  We will also need to wait for Typst to support the new syntax for alternate text for equations to make the HTML output more accessible.
