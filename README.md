# CV — LaTeX Source

ATS-friendly CV built with [moderncv](https://ctan.org/pkg/moderncv) (`classic` / teal style).  
Each section lives in its own file — edit only what you need, then compile.

---

## Project Structure

```
cv/
├── cv.tex                  # Entry point: preamble, personal info, \input calls
├── sections/
│   ├── summary.tex         # Profile / summary paragraph
│   ├── experience.tex      # Work history
│   ├── education.tex       # Degrees
│   ├── skills.tex          # Technical skills
│   ├── projects.tex        # Open-source / side projects
│   └── languages.tex       # Spoken languages
├── Makefile                # Build & clean targets
└── README.md
```

**Rule of thumb:** edit files in `sections/` for content changes; edit `cv.tex` only for personal info or global style tweaks.

### Updating content (Cursor)

Use the **`/update-cv`** command and describe your change in plain language. It updates **both** `sections/*.tex` + `cv.tex` and `cv.html`, then you can run `make html` / `make tex` to refresh PDFs. See `.cursor/commands/update-cv.md` for the full content map.

---

## Prerequisites

### macOS

```bash
# Install BasicTeX (lightweight TeX Live)
brew install --cask basictex

# Reload PATH so pdflatex is available
eval "$(/usr/libexec/path_helper)"

# Point tlmgr to the 2024 historic mirror
sudo tlmgr option repository https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2024/tlnet-final

# Update tlmgr, then install moderncv and its dependencies
sudo tlmgr update --self
sudo tlmgr install moderncv
```

### Linux (Debian/Ubuntu)

```bash
sudo apt update && sudo apt install texlive-latex-extra texlive-fonts-recommended
```

---

## Generate the PDF

```bash
make          # builds cv.pdf (runs pdflatex twice for correct refs)
make clean    # removes build artefacts (keeps .tex and .pdf)
```

Or manually:

```bash
pdflatex cv.tex
```

---

## Customisation

| What | File | Key |
|---|---|---|
| Name, email, phone, links | `cv.tex` | `\name`, `\email`, `\phone`, `\social` |
| Accent color | `cv.tex` | `\definecolor{cvteal}{RGB}{...}` |
| Style variant | `cv.tex` | `\moderncvstyle{classic}` |
| Font size / margins | `cv.tex` | `\documentclass[11pt,...]`, `geometry` |
| Work history | `sections/experience.tex` | `\cventry{...}` |
| Skills | `sections/skills.tex` | `\cvitem{...}` |
| Add a new section | Create `sections/foo.tex` | Add `\input{sections/foo}` to `cv.tex` |

---

## ATS Tips

- Single-column layout — multi-column confuses most parsers.
- Standard section names: Experience, Education, Skills.
- `pdflatex` produces text-selectable PDFs by default — no images of text.
- Avoid tables or text boxes for critical information.

---

## Auto-build with GitHub Actions

`.github/workflows/cv.yml`:

```yaml
name: Build CV

on:
  push:
    paths:
      - cv.tex
      - sections/**

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: xu-cheng/latex-action@v3
        with:
          root_file: cv.tex
      - uses: actions/upload-artifact@v4
        with:
          name: cv
          path: cv.pdf
```
