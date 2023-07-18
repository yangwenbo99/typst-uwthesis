#import "format.typ": project, appendix, gls
#import "glossaries.typ": GLOSSARIES

#show: project.with(
  title: "University of Waterloo E-Thesis Template for typst",
  doc_type: "theis", 
  author: "Pat Neugraad", 
  affiliation: "the University of Waterloo", 
  major: "Philosophy of Zoology",
  address: "Waterloo, Ontario, Canada", 
  year: "2023",
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
  declaration: "", 
  acknowledgements: "Hopefully, I will be able to thank everyone who made this possible.", 
  dedication: "This is dedicated to the one I love.  You may remove this section by setting this to empty", 
  glossaries: GLOSSARIES

)

// #committee
//
= Introduction
#label("introduction")

In the beginning, there was $pi$:

$ e^(pi i) plus 1 eq 0 $ <eqn_pi> A computer could compute $pi$ all day long. In
fact, subsets of digits of $pi$’s decimal approximation would make a
good source for psuedo-random vectors, #gls("rvec").

== State of the Art
#label("state-of-the-art")
See equation @eqn_pi on page.#footnote[A famous equation.]

== Some Meaningless Stuff
#label("some-meaningless-stuff")

The credo of the #gls("aaaaz") was, for several years, several paragraphs of
gibberish, until the dingledorf responsible for the #gls("aaaaz") Web site
realized his mistake:

\"Velit dolor illum facilisis zzril ipsum, augue odio, accumsan ea augue
molestie lobortis zzril laoreet ex ad, adipiscing nulla. Veniam dolore,
vel te in dolor te, feugait dolore ex vel erat duis nostrud diam commodo
ad eu in consequat esse in ut wisi. Consectetuer dolore feugiat wisi eum
dignissim tincidunt vel, nostrud, at vulputate eum euismod, diam minim
eros consequat lorem aliquam et ad. Feugait illum sit suscipit ut,
tation in dolore euismod et iusto nulla amet wisi odio quis nisl feugiat
adipiscing luptatum minim nisl, quis, erat, dolore. Elit quis sit dolor
veniam blandit ullamcorper ex, vero nonummy, duis exerci delenit
ullamcorper at feugiat ullamcorper, ullamcorper elit vulputate iusto
esse luptatum duis autem. Nulla nulla qui, te praesent et at nisl ut in
consequat blandit vel augue ut.

Illum suscipit delenit commodo augue exerci magna veniam hendrerit
dignissim duis ut feugait amet dolor dolor suscipit iriure veniam. Vel
quis enim vulputate nulla facilisis volutpat vel in, suscipit facilisis
dolore ut veniam, duis facilisi wisi nulla aliquip vero praesent nibh
molestie consectetuer nulla. Wisi nibh exerci hendrerit consequat,
nostrud lobortis ut praesent dignissim tincidunt enim eum accumsan.
Lorem, nonummy duis iriure autem feugait praesent, duis, accumsan tation
enim facilisi qui te dolore magna velit, iusto esse eu, zzril. Feugiat
enim zzril, te vel illum, lobortis ut tation, elit luptatum ipsum,
aliquam dolor sed. Ex consectetuer aliquip in, tation delenit dignissim
accumsan consequat, vero, et ad eu velit ut duis ea ea odio.

Vero qui, te praesent et at nisl ut in consequat blandit vel augue ut
dolor illum facilisis zzril ipsum. Exerci odio, accumsan ea augue
molestie lobortis zzril laoreet ex ad, adipiscing nulla, et dolore, vel
te in dolor te, feugait dolore ex vel erat duis. Ut diam commodo ad eu
in consequat esse in ut wisi aliquip dolore feugiat wisi eum dignissim
tincidunt vel, nostrud. Ut vulputate eum euismod, diam minim eros
consequat lorem aliquam et ad luptatum illum sit suscipit ut, tation in
dolore euismod et iusto nulla. Iusto wisi odio quis nisl feugiat
adipiscing luptatum minim. Illum, quis, erat, dolore qui quis sit dolor
veniam blandit ullamcorper ex, vero nonummy, duis exerci delenit
ullamcorper at feugiat. Et, ullamcorper elit vulputate iusto esse
luptatum duis autem esse nulla qui.

Praesent dolore et, delenit, laoreet dolore sed eros hendrerit consequat
lobortis. Dolor nulla suscipit delenit commodo augue exerci magna veniam
hendrerit dignissim duis ut feugait amet. Ad dolor suscipit iriure
veniam blandit quis enim vulputate nulla facilisis volutpat vel in. Erat
facilisis dolore ut veniam, duis facilisi wisi nulla aliquip vero
praesent nibh molestie consectetuer nulla, iriure nibh exerci hendrerit.
Vel, nostrud lobortis ut praesent dignissim tincidunt enim eum accumsan
ea, nonummy duis. Ad autem feugait praesent, duis, accumsan tation enim
facilisi qui te dolore magna velit, iusto esse eu, zzril vel enim zzril,
te. Nisl illum, lobortis ut tation, elit luptatum ipsum, aliquam dolor
sed minim consectetuer aliquip.

Tation exerci delenit ullamcorper at feugiat ullamcorper, ullamcorper
elit vulputate iusto esse luptatum duis autem esse nulla qui. Volutpat
praesent et at nisl ut in consequat blandit vel augue ut dolor illum
facilisis zzril ipsum, augue odio, accumsan ea augue molestie lobortis
zzril laoreet. Ex duis, te velit illum odio, nisl qui consequat aliquip
qui blandit hendrerit. Ea dolor nonummy ullamcorper nulla lorem tation
laoreet in ea, ullamcorper vel consequat zzril delenit quis dignissim,
vulputate tincidunt ut.\"

#pagebreak(weak: true)
= Observations
#label("observations")
This would be a good place for some figures and tables.

Some notes on figures and photographs…

-  A well-prepared PDF should be

  +  Of reasonable size, #emph[i.e.] photos cropped and compressed.

  +  Scalable, to allow enlargment of text and drawings.

-  Photos must be bit maps, and so are not scaleable by definition. TIFF
  and BMP are uncompressed formats, while JPEG is compressed. Most
  photos can be compressed without losing their illustrative value.

-  Drawings that you make should be scalable vector graphics, #emph[not]
  bit maps. Some scalable vector file formats are: EPS, SVG, PNG, WMF.
  These can all be converted into PNG or PDF, that pdflatex recognizes.
  Your drawing package can probably export to one of these formats
  directly. Otherwise, a common procedure is to print-to-file through a
  Postscript printer driver to create a PS file, then convert that to
  EPS (encapsulated PS, which has a bounding box to describe its exact
  size rather than a whole page). Programs such as GSView (a Ghostscript
  GUI) can create both EPS and PDF from PS files.
  Appendix #link("#AppendixA")[3] shows how to generate properly sized
  Matlab plots and save them as PDF.

-  It’s important to crop your photos and draw your figures to the size
  that you want to appear in your thesis. Scaling photos with the
  includegraphics command will cause loss of resolution. And scaling
  down drawings may cause any text annotations to become too small.

For more information on LaTeX  see these
#link("https://uwaterloo.ca/information-systems-technology/services/electronic-thesis-preparation-and-submission-support/ethesis-guide/creating-pdf-version-your-thesis/creating-pdf-files-using-latex/latex-ethesis-and-large-documentscourse")
notes. #super[2]

The classic book by Leslie Lamport #cite("lamport.book"), author of
LaTeX, is worth a look too, and the many available add-on packages are
described by Goossens #emph[et al] #cite("goossens.book").

#pagebreak(weak: true)
#bibliography("uw-ethesis.bib")

// #set heading(numbering: "A.1.1.1")
// #counter(heading).update(0)
#show: appendix

#pagebreak(weak: true)
#heading("APPENDICES", numbering: none)
#label("appendices")


#pagebreak(weak: true)
= Matlab Code for Making a PDF Plot
#label("AppendixA")

== Using the Graphical User Interface
#label("using-the-graphical-user-interface")
Properties of Matab plots can be adjusted from the plot window via a
graphical interface. Under the Desktop menu in the Figure window, select
the Property Editor. You may also want to check the Plot Browser and
Figure Palette for more tools. To adjust properties of the axes, look
under the Edit menu and select Axes Properties #cite("goossens.book").

To set the figure size and to save as PDF or other file formats, click
the Export Setup button in the figure Property Editor.

== From the Command Line
#label("from-the-command-line")
All figure properties can also be manipulated from the command line.
Here’s an example:

```
x=[0:0.1:pi];
hold on % Plot multiple traces on one figure
plot(x,sin(x))
plot(x,cos(x),'--r')
plot(x,tan(x),'.-g')
title('Some Trig Functions Over 0 to \pi') % Note LaTeX markup!
legend('{\it sin}(x)','{\it cos}(x)','{\it tan}(x)')
hold off
set(gca,'Ylim',[-3 3]) % Adjust Y limits of "current axes"
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Position',[0,0,6,4]) % Set figure width (6 in.) and height (4 in.)
cd n:\thesis\plots % Select where to save
print -dpdf plot.pdf % Save as PDF
```

