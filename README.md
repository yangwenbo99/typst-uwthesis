# typst-uwthesis

This is a [Typst](https://typst.app/) template that should (almost) satisfy the [University of Waterloo's thesis formatting requirements](https://uwaterloo.ca/graduate-studies-postdoctoral-affairs/current-students/thesis/thesis-formatting).  The resulting document is similar to, but not exactly the same as the [LaTeX template](https://uwaterloo.atlassian.net/wiki/spaces/ISTKB/pages/2666037269/LaTeX+Software+for+Thesis+and+Document+Preparation+and+the+Overleaf+Cloud+Service).
I wrote this template for my thesis proposal. 

At this moment, `project`, `appendix` and `gls` are only documented using the code itself.

## Equation numbering

Use Typst 0.15.1 or later. Main-body equations are numbered by chapter, such as `(1.1)` and `(2.1)`. The equation counter resets at each numbered chapter, but not at subsections or unnumbered headings. Appendices use `(A.1)`, `(B.1)`, and so on; front-matter equations retain simple numbering.

Label equations normally and reference them with `@eq-energy`; references display the same parenthesised number and link to the equation, including across chapters and appendices. Use `#ref(<eq-energy>, form: "page")` for its page number.

```typst
$ E = m c^2 $ <eq-energy>
See @eq-energy.
```

## Limitations

1. Limited reverse link from bibliography (only the first reference can be linked back from bibliography).  This needs to be addressed by Typst.
2. No reverse link from list of abbreviations.  Should not be _very_ hard to implement, but this does not seem to be a high priority thing.

## Integration example

See [tests/README.md](tests/README.md) for a multi-chapter demonstration and automated checks covering equations, references, front matter, glossaries, and export formats. Generated PDFs are placed in `tmp/` for visual inspection.

## Licence

Please note that the licence only applied to the code that is available in this commit and afterwards (unless I remove the licence in the future).  THIS LICENCE DOES NOT APPLY TO ALL PREVIOUS CONTENTS IN THIS REPOSITORY THAT ARE REMOVED BEFORE ADDING THE LICENCE. 
