#import "format.typ": project, appendix, gls
#import "glossaries.typ": GLOSSARIES

#show: project.with(
  title: "University of Waterloo E-Thesis Template for Typst",
  doc_type: "thesis",
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
     position: "Internal Member",
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
     position: "Internal-External Member",
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
  // You may hide the declaration, statement, acknowledgements & dedication
  // by setting their values to none.
  declaration: "",
  dedication: "This is dedicated to the one I love.  You may remove this section by setting dedication to none.",
  statement: [
    A detailed contribution statement should be put here if your thesis contains written material you co-authored with others.

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
If #gls("rvec") is a Gaussian random vector, then its marginal distribution can be calculated as
$
p(v_i) = 1 / sqrt(2 pi sigma_i^2) exp(- (v_i - mu_i)^2 / (2 sigma_i^2)).
$<equ-gaussian>

Equation @equ-gaussian illustrates the numbering and reference format.

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


- JPEG with reasonable resolution and compression is suggested for photos.
- Your drawings should ideally be output in SVG (or PDF).  
  EPS is also a good format, as it supports scalable vector graphics.  You may convert it to PDF if you want to include it in a Typst file. Only use PNG when your drawing software does not support SVG or PDF.
  See UW's LaTeX thesis template for information about using MATLAB to generate plots as PDFs. 
- Sometimes, the #link("https://cetz-package.github.io/")[CeTZ package]
  in Typst is a good candidate for making simple figures.

For more information on LaTeX, see
#link("https://uwaterloo.atlassian.net/wiki/spaces/ISTSERV/pages/42589978807/LaTeX+for+E-Thesis+and+large+documents")[these
notes]. #super[2]

#pagebreak(weak: true)
= Formatting Differences
#label("formatting-differences")

This template follows the same overall thesis structure as #link("https://www.overleaf.com/latex/templates/university-of-waterloo-thesis-template-v03-dot-2026/qxqqzmbrcmpp")[UW's official LaTeX template (March 2026)], but does not reproduce its formatting exactly.

- *Equation numbering:* Like the LaTeX template, this template numbers equations by chapter, such as (1.1), (2.1), and (A.1), resetting the equation counter in each numbered chapter or appendix.  References such as @equ-gaussian use the equation's own chapter number, even when cited from another chapter.
- *Fonts and sizes:* Body text and mathematics use New Computer Modern rather than LaTeX's traditional Computer Modern fonts.  Both use nominally 12-point body text, but heading sizes and font metrics differ.  Code uses DejaVu Sans Mono rather than Computer Modern Typewriter.
- *Spacing:* Ordinary body lines in the inspected Typst 0.15.1 output are approximately 16.00 PDF points apart, compared with 14.45 in the official PDF: about 11% more spacing.  Paragraph separation is also larger; mathematics and other tall content can alter these distances.
- *Chapter breaks:* Unlike LaTeX's chapter command, this template currently requires explicit page breaks before new chapters, as demonstrated here.  Appendices use lettered numbering and the prefix "Appendix," as in the LaTeX template.

The #link("https://uwaterloo.ca/current-graduate-students/academics/thesis-and-defence/thesis-formatting")[current UW guidelines] require readable, consistent typography but do not prescribe these fonts, spacing values, or equation-numbering schemes.  Both templates use coloured links and centre page numbers within the text area.  See the accessibility appendix (@sec-accessibility) for PDF/A and PDF/UA compilation instructions.

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
<sec-accessibility>

+ #link("https://quarto.org/docs/blog/posts/2026-03-05-pdf-accessibility-and-standards/index.html")[Typst offers far better support for PDF accessibility standards than LaTeX], but it is still a work in progress.  All generated PDFs have all accessibility features enabled by default. 
+ The PDF format of the thesis must conform to the PDF/A _or_ PDF/UA standards whenever technically feasible, per #link("https://uwaterloo.ca/lib/uwspace/thesis-submission-guide/formatting-your-thesis")[University requirements].  This template can be used to compile PDF/A:
  ```bash
  typst compile --pdf-standard a-4 uw-ethesis.typ
  typst compile --pdf-standard a-3b uw-ethesis.typ
  ```
  There are multiple levels of PDF/A; level A for PDF/A-1 through PDF/A-3 is the strictest one, and it is (probably) the best for disabled users.  However, compilation to these levels is not straightforward.  See @sec-pdf-ua for discussion.
+ The PDF format is a sh\*tpile format for _printing_ (not for reading on screen) from 1993.  In my personal opinion, from an accessibility standpoint, the most reasonable solution is to compile to HTML.  First, toggle on the `html` feature in the project block.
  ```bash
  typst compile --features=html --format=html uw-ethesis.typ
  ```
+ Additionally, consider reading #link("https://typst.app/docs/guides/accessibility/")[Typst's accessibility guide] for tips on making your thesis more accessible to readers with disabilities, readers using non-orthodox devices, and artificial intelligence.


== Compiling to PDF/UA
<sec-pdf-ua>

Compilation to PDF/A conformance level A or PDF/UA is not straightforward.  First, you need to use the `pdf_ua` option in the project block to disable certain formatting features that interfere with Typst's compilation to PDF/UA.
```bash
typst compile --pdf-standard ua-1 uw-ethesis.typ
```

However, you need to add alternate text descriptions to all your figures and equations.  
Typst will "automatically make math accessible in HTML and PDF 2.0 by leveraging MathML technology" in the future, but currently, you need to use the `alt` option manually.


== The HTML format

Compiling Typst to HTML is still experimental.  Currently, the largest issue is also formulae.  You can use #link("https://github.com/a-for-short/html-typst-equation-renderer")[HTML Typst Equation Renderer] to render equations as embedded SVG images in the HTML output.  This is a good solution for mobile phone users and (probably) for people with limited vision, but it is certainly not for screen readers.  We will also need to wait for Typst to support the new syntax for alternate text for equations to make the HTML output more accessible.
