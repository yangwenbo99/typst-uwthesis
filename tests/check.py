"""Compile the integration thesis and verify its output. Run from any directory."""

from html.parser import HTMLParser
from pathlib import Path
import itertools
import subprocess

from pypdf import PdfReader


ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / "tmp"
FIXTURE = "tests/template-exercise.typ"


def run(*args, source=None):
    result = subprocess.run(
        args, cwd=ROOT, input=source, text=True, capture_output=True
    )
    if result.returncode:
        raise AssertionError(f"{' '.join(args)}\n{result.stderr}")
    return result


def compile_pdf(name, *options, source=None):
    path = OUTPUT / f"{name}.pdf"
    result = run(
        "typst", "compile", "--root", ".", *options,
        "-" if source is not None else FIXTURE, str(path), source=source,
    )
    assert not result.stderr, result.stderr
    text = run("pdftotext", "-layout", str(path), "-").stdout
    return PdfReader(path), text


def check_thesis(reader, text, mode="full"):
    flat = " ".join(text.split())
    expected = [
        "Forward checks: (2.1), (A.1), (B.1).",
        "Front-matter check: (1).",
        "Backward check: (1.1). Forward appendix check: (A.1).",
        "Reference audit: (1.1), (1.2), (1.3), (2.1), (2.2), (2.3), (3.1), (A.1), (A.2), (B.1).",
        "Final reference audit: (1), (1.1), (1.2), (1.3), (2.1), (2.2), (2.3), (3.1), (A.1), (A.2), (B.1).",
        "Heading audit: Chapter 1, Chapter 2, Section 2.1, Appendix A, Appendix B.",
        "Equation page: page 1.",
        "Figure 1: A three-stage measurement workflow.",
        "Figure 2: A second illustrative result panel.",
        "Table 1: Small deterministic measurement results.",
        "This note should remain on its text page.",
        "The LaTeX Companion",
    ]
    for phrase in expected:
        assert phrase in flat, phrase
    assert "Chapter A" not in flat and "Chapter B" not in flat

    pages = [p for p in text.split("\f") if p.strip()]
    assert len(pages) == len(reader.pages), "Unexpected blank page"
    main = next(i for i, p in enumerate(pages) if "Chapter 1" in p)
    labels = reader.page_labels
    assert labels[:3] == ["", "ii", "iii"]
    assert labels[main:] == [str(n) for n in range(1, len(pages) - main + 1)]
    appendix_b = next(i for i, p in enumerate(pages) if "Appendix B\n" in p)
    assert f"Page audit: page v, page 1, page {labels[appendix_b]}." in flat
    for label, page in zip(labels[1:], pages[1:]):
        assert page.strip().splitlines()[-1].strip() == label

    toc_start = next(i for i, p in enumerate(pages) if "Table of Contents" in p)
    list_start = next(i for i, p in enumerate(pages) if p.strip().startswith("List of Figures"))
    toc = " ".join(" ".join(pages[toc_start:list_start]).split())
    assert "Examining Committee Membership" in toc
    assert "Statement of Contributions" in toc
    assert "Contribution details" not in toc
    assert "Methodological Note" in toc
    assert "Inline and unnumbered mathematics" in toc
    assert "A Supplementary Derivations" in toc
    assert "B Verification Record" in toc
    assert "A three-stage measurement workflow." in pages[list_start]
    tables = next(p for p in pages if p.strip().startswith("List of Tables"))
    assert "Small deterministic measurement results." in tables
    assert "Motivation" in pages[main].splitlines()[0]
    assert "Terminology" in pages[main].splitlines()[0]

    assert ("List of Abbreviations" in flat) == (mode != "empty")
    assert ("List of Symbols" in flat) == (mode == "full")
    assert ("Glossary" in toc) == (mode == "full")
    if mode != "empty":
        assert "First use: signal-to-noise ratio (SNR). Second use: SNR." in flat
        assert "Custom first use: processors (CPU). Custom later use: processing units." in flat
    assert reader.metadata.title == "Template Integration Exercise"
    assert reader.metadata.author == "Example Author"
    assert reader.trailer["/Root"]["/MarkInfo"]["/Marked"]

    # Check that forward equation references have actual destinations on the
    # corresponding chapter/appendix pages, not just the right displayed text.
    destinations = set()
    for annotation in reader.pages[main].get("/Annots", []):
        target = annotation.get_object().get("/Dest")
        if target is not None:
            target = target.get_object()
        if target and isinstance(target, list):
            destinations.add(target[0].idnum)
    for title in ["Chapter 2\n", "Appendix A\n", "Appendix B\n"]:
        page = next(i for i, p in enumerate(pages) if title in p)
        assert reader.pages[page].indirect_reference.idnum in destinations, title


def check_backrefs(reader, text):
    pages = text.split("\f")
    bib_page = next(i for i, p in enumerate(pages) if "Cited on pages" in p)
    bib_text = " ".join(pages[bib_page].split())
    assert text.count("Cited on pages") == 1, "Single-page entries must have no suffix"
    assert "Grouped citation check: [1], [2]. Repeat: [1]." in " ".join(text.split())

    def links(page):
        return [a.get_object() for a in page.get("/Annots", [])]

    def destination(annotation):
        return annotation["/Dest"].get_object()

    # Derive expected cited pages from the PDF's forward citation links, not
    # retrofit's metadata. This also checks that grouping/repetition is retained.
    citations = {"[1]": [], "[2]": [], "[3]": []}
    for i, page in enumerate(reader.pages):
        if i == bib_page:
            continue
        for annotation in links(page):
            marker = annotation.get("/Contents")
            if marker in citations:
                assert destination(annotation)[0].idnum == reader.pages[bib_page].indirect_reference.idnum
                citations[marker].append((i, annotation))
    assert len(citations["[1]"]) == 5
    assert len(citations["[2]"]) == 1
    assert len(citations["[3]"]) == 2
    assert len({i for i, _ in citations["[3]"]}) == 1
    expected_pages = list(dict.fromkeys(i for i, _ in citations["[1]"]))
    assert len(expected_pages) == 4
    assert expected_pages[-1] > bib_page, "Include citations after the bibliography"
    labels = [reader.page_labels[i] for i in expected_pages]
    assert f"Cited on pages {', '.join(labels)}." in bib_text
    assert bib_text.index("Cited on pages") < bib_text.index("[2]")

    backlinks = [a for a in links(reader.pages[bib_page]) if a.get("/Contents", "").startswith("page ")]
    assert len(backlinks) == len(expected_pages)
    for annotation, i, label in zip(backlinks, expected_pages, labels):
        target = destination(annotation)
        assert annotation["/Contents"] == f"page {label}"
        assert target[0].idnum == reader.pages[i].indirect_reference.idnum
        first_citation = next(a for page, a in citations["[1]"] if page == i)
        assert first_citation["/Rect"][1] <= target[3] <= first_citation["/Rect"][3]
        assert abs(float(target[2]) - float(first_citation["/Rect"][0])) < 1

    # Original bibliography-number backlinks remain available even when the
    # suffix is hidden. Check their page and vertical position too.
    for annotation in links(reader.pages[bib_page]):
        marker = annotation.get("/Contents")
        if marker in citations:
            i, first_citation = citations[marker][0]
            target = destination(annotation)
            assert target[0].idnum == reader.pages[i].indirect_reference.idnum
            assert first_citation["/Rect"][1] <= target[3] <= first_citation["/Rect"][3]


class HTMLText(HTMLParser):
    def __init__(self):
        super().__init__()
        self.parts = []
        self.ids = set()
        self.targets = set()

    def handle_data(self, data):
        self.parts.append(data)

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if "id" in attrs:
            self.ids.add(attrs["id"])
        if tag == "a" and attrs.get("href", "").startswith("#"):
            self.targets.add(attrs["href"][1:])


def main():
    OUTPUT.mkdir(exist_ok=True)
    variants = [
        ("template-exercise", (), "full"),
        ("template-exercise-a3b", ("--pdf-standard", "a-3b"), "full"),
        ("template-exercise-ua", ("--input", "ua=true", "--pdf-standard", "ua-1"), "full"),
        ("template-exercise-empty", ("--input", "glossaries=empty"), "empty"),
        ("template-exercise-partial", ("--input", "glossaries=partial"), "partial"),
        ("template-exercise-logo", ("--input", "logo=true"), "full"),
        ("template-exercise-backrefs", ("--input", "backrefs=true"), "full"),
        ("template-exercise-backrefs-a3b", ("--input", "backrefs=true", "--pdf-standard", "a-3b"), "full"),
    ]
    for name, options, mode in variants:
        reader, text = compile_pdf(name, *options)
        check_thesis(reader, text, mode)
        if "backrefs" in name:
            check_backrefs(reader, text)
        if name.endswith("-a3b"):
            assert reader.xmp_metadata.pdfaid_part == "3"
            assert reader.xmp_metadata.pdfaid_conformance == "B"
        if name.endswith("-ua"):
            assert b"pdfuaid:part" in reader.trailer["/Root"]["/Metadata"].get_object().get_data()
        print(f"PASS {name}: {len(reader.pages)} pages")

    # Defaults and all combinations of missing glossary categories, with the
    # optional front matter disabled and the sole-author declaration enabled.
    names = ("abbreviation", "symbol", "glossary")
    for flags in [None, *itertools.product((False, True), repeat=3)]:
        option = "" if flags is None else ", glossaries: (" + "".join(
            f'{name}: ({name}: ("Entry", "Definition"),),'
            for name, present in zip(names, flags) if present
        ) + ")"
        if option == ", glossaries: ()":
            option = ", glossaries: (:)"
        source = f'''#import "format.typ": project
#show: project.with(title: "Minimal configuration", committee_members: none,
  declaration: "sole", acknowledgements: none, dedication: none{option})
= Introduction
Text.
'''
        _, text = compile_pdf("template-minimal", source=source)
        assert "I am the sole author" in text
        assert "Examining Committee" not in text
        assert "Acknowledgements" not in text and "Dedication" not in text
        flat = " ".join(text.split())
        for heading, present in zip(
            ("List of Abbreviations", "List of Symbols", "Glossary"),
            flags or (False, False, False),
        ):
            assert (heading in flat) == present
    print("PASS minimal configuration and all missing-category combinations")

    result = run(
        "typst", "compile", "--root", ".", "--features", "html", "--format", "html",
        "--input", "html=true", FIXTURE, str(OUTPUT / "template-exercise.html"),
    )
    (OUTPUT / "template-exercise-html.log").write_text(result.stderr)
    document = HTMLText()
    document.feed((OUTPUT / "template-exercise.html").read_text())
    text = " ".join("".join(document.parts).split())
    assert "Forward checks: (2.1), (A.1), (B.1)." in text
    assert "Final reference audit: (1), (1.1), (1.2), (1.3), (2.1), (2.2), (2.3), (3.1), (A.1), (A.2), (B.1)." in text
    assert document.targets <= document.ids, document.targets - document.ids
    print("PASS HTML numbering and internal targets (layout warnings saved in tmp)")

    # Record known retrofit 0.2.0 incompatibilities without silently disabling
    # backlinks in the requested export. A future fix should revisit these cases.
    for name, options, extension, error in [
        ("ua", ("--input", "ua=true", "--pdf-standard", "ua-1"), "pdf", "invalid list (L) structure"),
        ("html", ("--input", "html=true", "--features", "html", "--format", "html"), "html", "failed to determine link anchor"),
    ]:
        result = subprocess.run(
            ["typst", "compile", "--root", ".", "--input", "backrefs=true", *options,
             FIXTURE, str(OUTPUT / f"template-exercise-backrefs-{name}.{extension}")],
            cwd=ROOT, text=True, capture_output=True,
        )
        (OUTPUT / f"template-exercise-backrefs-{name}.log").write_text(result.stderr)
        assert result.returncode != 0 and error in result.stderr, result.stderr
        print(f"KNOWN INCOMPATIBILITY retrofit {name}: {error} (log saved in tmp)")


if __name__ == "__main__":
    main()
