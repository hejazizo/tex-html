LATEX := pdflatex -interaction=nonstopmode
SRC   := cv.tex
OUT   := cv.pdf

.PHONY: all clean

all: $(OUT)

$(OUT): $(SRC) $(wildcard sections/*.tex)
	$(LATEX) $(SRC)
	$(LATEX) $(SRC)

clean:
	rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk missfont.log
