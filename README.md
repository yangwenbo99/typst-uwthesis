# typst-uwthesis

This is a [typst](https://typst.app/) template that should (almost) satisfy the [University of Waterloo's thesis formatting requirements](https://uwaterloo.ca/graduate-studies-postdoctoral-affairs/current-students/thesis/thesis-formatting).  The resulted document is similar to, but not exactly the same as the [LaTeX template](https://uwaterloo.atlassian.net/wiki/spaces/ISTKB/pages/2666037269/LaTeX+Software+for+Thesis+and+Document+Preparation+and+the+Overleaf+Cloud+Service). 
I wrote this template for my thesis proposal. 

At this moment, `project`, `appendix` and `gls` are only documented using the code itself.

## Limitations

1. Equations are not labeled in `section.equ` format.  Currently, only some imperfect workarounds are available.  After carefully reading UW's guidelines, I believe this is not a violation. 
2. Limited reverse link from bibliography (only the first reference can be linked back from bibliography).  This needs to be addressed by typst. 
3. No reverse link from list of abbreviations.  Should not be _very_ hard to implement, but this does not seem to be a high priority thing.

## Licence

Please note that the licence only applied to the code that is available in this commit and afterwards (unless I remove the licence in the future).  THIS LICENCE DOES NOT APPLY TO ALL PREVIOUS CONTENTS IN THIS REPOSITORY THAT ARE REMOVED BEFORE ADDING THE LICENCE. 

