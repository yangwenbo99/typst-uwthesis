# typst-uwthesis

This is a [typst](https://typst.app/) template that should (almost) satisfy the [University of Waterloo's thesis formatting requirements](https://uwaterloo.ca/graduate-studies-postdoctoral-affairs/current-students/thesis/thesis-formatting).  The resulted document is similar to, but not exactly the same as the [LaTeX template](https://uwaterloo.atlassian.net/wiki/spaces/ISTKB/pages/2666037269/LaTeX+Software+for+Thesis+and+Document+Preparation+and+the+Overleaf+Cloud+Service). 
I wrote this template for my thesis proposal. 

At this moment, `project`, `appendix` and `gls` are only documented using the code itself.

## Limitations

1. Equations are not labeled in `section.equ` format.  We would either need to "hack" using `set equ` or wait for typst to implement this. 
2. Some duplicated headings appear in PDF's outline (not in TOC).  This [issue](https://github.com/typst/typst/pull/1566) has been addressed by typst's developer.  If you compile from GitHub's `main` branch, instead of using the pre-compiled package, the problem will disappear.  We expect the problem will also disappear in the next release of typst. 
3. Limited reverse link from bibliography.  This needs to be addressed by typst. 
3. No reverse link from list of abbreviations.  I might find  a way to hack this later. 

## License

Placeholders in the example file might contain copyrighted example texts obtained from UW's IST.  By the time you complete you thesis, all copyrighted texts will have been removed. 

Currently, there should be no legal problem for a UW student to use this template.  We have plan to release the template under an Apache license similar to [simple-typst-thesis's](https://github.com/zagoli/simple-typst-thesis) after getting rid of the potentially copyrighted texts.  If you need this template soon, feel free to replace the text by non-copyrighted material and submit a pull request. 

