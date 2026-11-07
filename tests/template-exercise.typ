#import "../format.typ": project, appendix, gls, running_name
#import "@preview/retrofit:0.2.0": backrefs

#let ua = sys.inputs.at("ua", default: "false") == "true"
#let html = sys.inputs.at("html", default: "false") == "true"
#let backrefs-enabled = sys.inputs.at("backrefs", default: "false") == "true"
#let glossary-mode = sys.inputs.at("glossaries", default: "full")
#let sample-symbol = math.equation(alt: "The sample x.", $x$)
#let data = (
  abbreviation: (
    snr: ("SNR", "signal-to-noise ratio"),
    cpu: ("CPU", "central processing unit"),
  ),
  symbol: (
    sample: (sample-symbol, "A measured sample.", sample-symbol),
  ),
  glossary: (
    estimator: ("estimator", "A rule for inferring a quantity from observations.", "estimator"),
  ),
)
#let selected = if glossary-mode == "empty" { (:) } else if glossary-mode == "partial" {
  (abbreviation: data.abbreviation,)
} else { data }

#show: project.with(
  title: "Template Integration Exercise",
  author: "Example Author",
  email: "example@example.org",
  affiliation: "the University of Waterloo",
  degree: "Doctor of Philosophy",
  major: "Computer Science",
  year: "2026",
  logo: if sys.inputs.at("logo", default: "false") == "true" { "/tests/test-logo.svg" } else { none },
  committee_members: (
    (position: "External Examiner", persons: (
      (name: "Alex Example", title: "Professor", department: "Computing", affiliation: "Example University"),
    )),
    (position: "Supervisor(s)", persons: (
      (name: "Sam Example", title: "Professor", department: "Computer Science", affiliation: "University of Waterloo"),
      (name: "Robin Example", title: "Professor", department: "Mathematics", affiliation: "University of Waterloo"),
    )),
    (position: "Internal Member", persons: (
      (name: "Pat Example", title: "Professor", department: "Computer Science", affiliation: "University of Waterloo"),
    )),
  ),
  declaration: "compiled",
  statement: [
    The example author designed the demonstrations and verification cases.

    == Contribution details
    This heading must be unnumbered and absent from the table of contents.
    A forward reference to the main body is @eq-method.
  ],
  abstract: [
    This document exercises thesis structure, typography, navigation, and equation numbering.
    It includes a front-matter equation, which has a simple number:
    #math.equation(block: true, alt: "The constant c equals one.", $c = 1$) <eq-front>
    #lorem(100)
  ],
  acknowledgements: [Thanks to everyone who helped review the template.],
  dedication: [For readers who follow every cross-reference.],
  glossaries: selected,
  pdf_ua: ua,
  html: html,
)

// Compatibility trial: suppress the suffix for entries cited on just one page.
#show: doc => if backrefs-enabled {
  backrefs(
    format: links => if links.len() > 1 [Cited on pages #links.join(", ").],
    read: path => read(path),
    doc,
  )
} else { doc }

= Motivation and Scope
<ch-motivation>
#running_name(level: 1)[Motivation]

Forward checks: @eq-method, @eq-a, @eq-b.
Front-matter check: @eq-front.
See @ch-method and @sec-design for the experimental design.

== Terminology and navigation
#running_name[Terminology]

#if glossary-mode != "empty" [
  First use: #gls("snr"). Second use: #gls("snr").
  Custom first use: #gls("cpu", shown_as: "processors").
  Custom later use: #gls("cpu", shown_as: "processing units").
]
#if glossary-mode == "full" [
  A sample #gls("sample") is processed by an #gls("estimator").
]

An external #link("https://typst.app/docs/")[documentation link] and a citation
@goossens.book exercise link colours. A footnote#footnote[This note should remain on its text page.] exercises footnote layout.

#math.equation(block: true, alt: "Energy E equals mass m times the square of c.", $E = m c^2$) <eq-energy>

#lorem(330)

== Scope and assumptions

The subsection continues the chapter's equation sequence.
#math.equation(block: true, alt: "The squared norm of x is the sum of the squared components of x.", $norm(x)^2 = sum_(i=1)^n x_i^2$) <eq-norm>

=== Inline and unnumbered mathematics

Inline #math.equation(alt: "x plus y", $x + y$) must not consume a number.
#math.equation(block: true, numbering: none, alt: "Zero equals zero.", $0 = 0$)
#math.equation(block: true, alt: "The parameter alpha equals one half.", $alpha = 1/2$) <eq-alpha>

- Body text and mathematics use consistent typefaces.
- Numbered equations can be referenced before or after their definitions.
- Unnumbered equations remain outside the sequence.

#lorem(250)

#pagebreak(weak: true)
= Experimental Method and Data Collection
<ch-method>
#running_name(level: 1)[Method]

== Design of the measurement procedure
<sec-design>
#running_name[Design]

#math.equation(block: true, alt: "The sample mean is the sum of n observations divided by n.", $bar(x) = 1/n sum_(i=1)^n x_i$) <eq-method>

Backward check: @eq-energy. Forward appendix check: @eq-a.
#if not html [Equation page: #ref(<eq-energy>, form: "page").]

#figure(
  rect(width: 80%, height: 25mm, fill: rgb("#edf3fa"))[
    #align(center + horizon)[Observation → Estimation → Evaluation]
  ],
  caption: [A three-stage measurement workflow.],
  alt: "A workflow proceeding from observation through estimation to evaluation.",
) <fig-workflow>

The workflow in @fig-workflow produces the observations in @tab-samples.

#figure(
  table(
    columns: 3,
    table.header([Trial], [Input], [Estimate]),
    [1], [10], [9.8],
    [2], [20], [20.1],
    [3], [30], [29.9],
  ),
  caption: [Small deterministic measurement results.],
  alt: "Three trials with inputs 10, 20 and 30 and corresponding estimates 9.8, 20.1 and 29.9.",
) <tab-samples>

#lorem(330)

== Error model

#math.equation(block: true, alt: "Error epsilon is the estimated value minus the observed value.", $epsilon = hat(x) - x$) <eq-error>

+ Record the input and output.
+ Calculate the error using @eq-error.
+ Compare the results with @eq-method.

#lorem(250)

#pagebreak(weak: true)
#heading("Methodological Note", level: 1, numbering: none)

This unnumbered top-level heading must not reset the equation counter.
#math.equation(block: true, alt: "The absolute error is at most delta.", $abs(epsilon) <= delta$) <eq-bound>

Grouped citation check: @goossens.book @knuth.book. Repeat: @goossens.book.
Same-page citation check: @lamport.book. Repeated here: @lamport.book.

#pagebreak(weak: true)
= Results and Interpretation
<ch-results>
#running_name(level: 1)[Results]

== Summary statistics

#math.equation(block: true, alt: "The mean squared error is the average squared error.", $"MSE" = 1/n sum_(i=1)^n epsilon_i^2$) <eq-results>

Reference audit: @eq-energy, @eq-norm, @eq-alpha, @eq-method, @eq-error, @eq-bound, @eq-results, @eq-a, @eq-a-next, @eq-b.

#figure(
  rect(width: 70%, height: 20mm, stroke: rgb("#0074d9"))[
    #align(center + horizon)[Results are compared with the baseline.]
  ],
  caption: [A second illustrative result panel.],
  alt: "A panel stating that results are compared with the baseline.",
) <fig-results>

#lorem(330)

== Interpretation

The first figure is @fig-workflow; the second is @fig-results.
The data table is @tab-samples. The bibliography citation remains @goossens.book.

#lorem(250)

#pagebreak(weak: true)
= Conclusions

== Findings and reproducibility

The conclusions chapter deliberately contains no numbered equations. Appendices must
still begin with (A.1), rather than inheriting the last equation's chapter or counter.

#lorem(220)

#pagebreak(weak: true)
#if backrefs-enabled {
  // Keep the template's heading blocks outside retrofit's entry-counting rules.
  heading("References", numbering: none)
  bibliography("../uw-ethesis.bib", title: none)
} else {
  bibliography("../uw-ethesis.bib", title: [References])
}

#show: appendix
#pagebreak(weak: true)
#heading("APPENDICES", numbering: none)

#pagebreak(weak: true)
= Supplementary Derivations
<app-a>
#running_name(level: 1)[Derivations]

== First identity

#math.equation(block: true, alt: "The sum of the first n integers is n times n plus one divided by two.", $sum_(i=1)^n i = (n(n+1))/2$) <eq-a>

Main-body references from an appendix: @eq-energy and @eq-method.
Forward appendix reference: @eq-b.
Citation after the bibliography: @goossens.book.

#lorem(220)

== Second identity

#math.equation(block: true, alt: "The sum of the first n squared integers is n times n plus one times two n plus one divided by six.", $sum_(i=1)^n i^2 = (n(n+1)(2n+1))/6$) <eq-a-next>

#pagebreak(weak: true)
= Verification Record
<app-b>

== Final consistency checks

#math.equation(block: true, alt: "The validation indicator v equals one.", $v = 1$) <eq-b>

Final reference audit: @eq-front, @eq-energy, @eq-norm, @eq-alpha, @eq-method, @eq-error, @eq-bound, @eq-results, @eq-a, @eq-a-next, @eq-b.

Heading audit: @ch-motivation, @ch-method, @sec-design, @app-a, @app-b.
#if not html [Page audit: #ref(<eq-front>, form: "page"), #ref(<eq-energy>, form: "page"), #ref(<eq-b>, form: "page").]

#if glossary-mode != "empty" [Abbreviation revisit: #gls("snr").]
#if glossary-mode == "full" [Glossary revisit: #gls("estimator").]

#lorem(180)
