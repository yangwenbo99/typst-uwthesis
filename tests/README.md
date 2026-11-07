# Template integration exercise (built by AI)

`template-exercise.typ` builds a roughly 32-page demonstration with four chapters
and two appendices. Run these commands from the repository root:

```bash
typst compile --root . tests/template-exercise.typ tmp/template-exercise.pdf
python3 tests/check.py
```

The checks require Typst 0.15.1 or later, Poppler's `pdftotext`, and Python with
`pypdf`. They rebuild the demonstration and its variants in `tmp/`.

Coverage includes:

- Title metadata, email, optional logo, committee members and multiple supervisors.
- Both declaration choices, contributions and their unlisted subheadings,
  abstract, acknowledgements, dedication, and omitted optional front matter.
- Table of contents, figure/table lists, three heading levels, running-name
  overrides, Roman front-matter numbering and consecutive Arabic body numbering.
- Figures, tables with header cells, captions, footnotes, lists, external links,
  citations and bibliography.
- Abbreviations, symbols, glossary terms, first/repeated/custom term displays,
  and missing or empty glossary categories.
- Equations in front matter, chapters, subsections and appendices; an
  equation-free chapter; inline and unnumbered mathematics; an unnumbered
  top-level heading; forward/backward references; and equation page references.
- PDF link destinations, PDF/A-3b export and PDF/UA-1 export with alternate text.
- Experimental HTML equation/reference output and internal link targets.

Fixture options are passed as `--input key=value`:

| Key | Values | Purpose |
| --- | --- | --- |
| `glossaries` | `full` (default), `empty`, `partial` | Exercise optional categories. |
| `ua` | `true`, `false` (default) | Enable the template's PDF/UA-compatible outline style. |
| `html` | `true`, `false` (default) | Use HTML glossary tables and omit PDF-only page references. |
| `logo` | `true`, `false` (default) | Exercise the optional title-page logo in ordinary PDF output. |
| `backrefs` | `true`, `false` (default) | Trial page-level bibliography backlinks using `retrofit:0.2.0`. |

HTML is unpaginated, so page-number references are deliberately PDF-only. Typst
also reports unsupported layout features during HTML export; these warnings are
saved to `tmp/template-exercise-html.log`. The HTML check does not assert visual
equivalence with the PDF. PDF-standard builds check Typst's export and the output
metadata, not independent certification by an external validator.

## Bibliography backlink compatibility trial

```bash
typst compile --root . --input backrefs=true tests/template-exercise.typ tmp/template-exercise-backrefs.pdf
```

The trial uses `@preview/retrofit:0.2.0` with a formatting callback that adds
`Cited on pages …` only when there is more than one cited page. Typst downloads
the package on first use. The template implementation itself is not modified.

Tested with Typst 0.15.1 and the default IEEE bibliography style:

| Export | Result with backlinks enabled |
| --- | --- |
| Ordinary PDF | Pass, with the heading workaround below. |
| PDF/A-3b | Pass, with the same workaround. |
| PDF/UA-1 | Fails: appended links/text produce an invalid list (`L`) structure. |
| Experimental HTML | Fails: unresolved link anchors and an empty bibliography-heading query. |

The package mistakes blocks in the template's bibliography heading for entries,
causing an out-of-bounds error. The trial renders `heading("References",
numbering: none)` separately and sets `bibliography(..., title: none)` to avoid
this conflict. The heading retains its template styling and TOC entry.

The PDF has three entries: Goossens is cited five times on four pages (including
a grouped citation and a citation after the bibliography); Knuth is cited once;
Lamport is cited twice on the same page. Only Goossens receives the suffix,
`Cited on pages 1, 7, 9, 15.` The checks verify the displayed page numbers, actual
PDF link destinations, deduplication, suppression, and retained bibliography-number
backlinks. The bibliography is on physical PDF page 26 (printed page 13).

`python3 tests/check.py` runs the working PDF variants and records the known
PDF/UA and HTML failures in `tmp/template-exercise-backrefs-ua.log` and
`tmp/template-exercise-backrefs-html.log`. These are reported as known
incompatibilities, not passing exports. Baseline exports use `backrefs=false`.
