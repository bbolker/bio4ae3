all: docs/assignments/README.html docs/assignments/eeid2009-midterm.pdf docs/index.html docs/eeid_bib.html docs/extras.html

## allnotes docs/assignments/midterm-topics.html

## see also: mk_all
allnotes:
	./mkallnotes

## these must come FIRST so we don't trash .md files by moving
## them to docs!
## FIXME: rebuilds html files in docs unnecessarily
docs/%: %
	mv $< docs

docs/notes/%: notes/%
	mv $< docs/$<

docs/assignments/%: assignments/%
	mv $< docs/$<

%.html: %.rmd
	Rscript  -e "rmarkdown::render('$<')"

## https://stackoverflow.com/questions/5178828/how-to-replace-all-lines-between-two-points-and-subtitute-it-with-some-text-in-s
## FIXME, sed -r doesn't work on MacOS
%.docx: %.rmd
	sed -r '/::::: \{#special .spoiler/,/:::::/c\**SPOILER**\n' < $< > $(@D)/tmp.rmd
	cp $< $(@D)/tmp.rmd
	Rscript -e "rmarkdown::render('$(@D)/tmp.rmd', output_format = 'word_document')"
	mv $(@D)/tmp.docx $*.docx

%.html: %.md
	Rscript  -e "rmarkdown::render('$<', output_options = list(self_contained=TRUE))"

%.pdf: %.rmd
	Rscript -e "rmarkdown::render('$<', output_format = tufte::tufte_handout())" ## , params = list('latex-engine'='xelatex'))"

%.pdf: %.tex
	pdflatex $<

%.pdf: %.md
	Rscript -e "rmarkdown::render('$<', output_format = tufte::tufte_handout())"

index.html: index.rmd sched.csv
	Rscript  -e "rmarkdown::render('$<')"

eeid_bib.html: eeid_bib.md eeid.bib
	Rscript  -e "rmarkdown::render('$<')"


