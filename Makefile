# ─────────────────────────────────────────────────────────────────────────────
#  CV build
#    make           → both cv-html.pdf and cv-tex.pdf
#    make html      → cv-html.pdf  (headless Chrome from cv.html)
#    make tex       → cv-tex.pdf   (pdflatex from cv.tex)
#    make open      → open cv.html in the browser
#    make clean     → remove build artefacts
# ─────────────────────────────────────────────────────────────────────────────

HTML_SRC := cv.html
HTML_PDF := cv-html.pdf

LATEX    := pdflatex -interaction=nonstopmode
TEX_SRC  := cv.tex
TEX_PDF  := cv-tex.pdf

# Headless Chrome / Chromium. Override with: make CHROME="/path/to/chrome"
CHROME ?= $(shell \
  for c in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser" \
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
    "$$(command -v google-chrome 2>/dev/null)" \
    "$$(command -v chromium 2>/dev/null)" \
    "$$(command -v chromium-browser 2>/dev/null)" ; do \
    [ -x "$$c" ] && echo "$$c" && break ; \
  done)

.PHONY: all html tex open clean

all: html tex

## html: render cv.html → cv-html.pdf via headless Chrome
html: $(HTML_PDF)

$(HTML_PDF): $(HTML_SRC)
	@if [ -z "$(CHROME)" ]; then \
	  echo "No Chrome/Chromium found. Run: make CHROME=\"/path/to/chrome\""; exit 1; fi
	"$(CHROME)" --headless=new --disable-gpu \
	  --no-pdf-header-footer --print-to-pdf="$(HTML_PDF)" \
	  --run-all-compositor-stages-before-draw \
	  --virtual-time-budget=4000 \
	  "file://$(CURDIR)/$(HTML_SRC)"
	@echo "Wrote $(HTML_PDF)"

## tex: pdflatex build cv.tex → cv-tex.pdf
tex: $(TEX_PDF)

$(TEX_PDF): $(TEX_SRC) $(wildcard sections/*.tex)
	$(LATEX) -jobname=cv-tex $(TEX_SRC)
	$(LATEX) -jobname=cv-tex $(TEX_SRC)

## open: open the HTML in your default browser
open: $(HTML_SRC)
	open "$(HTML_SRC)"

clean:
	rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk missfont.log
