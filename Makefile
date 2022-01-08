all: docs/assignments.html docs/index.html docs/eeid_bib.html

%.html: %.docx
	/usr/bin/pandoc +RTS -K512m -RTS $< --to html4 --output $@ --lua-filter /usr/local/lib/R/library/rmarkdown/rmarkdown/lua/pagebreak.lua --lua-filter /usr/local/lib/R/library/rmarkdown/rmarkdown/lua/latex-div.lua --self-contained --variable bs3=TRUE --standalone --section-divs --template /usr/local/lib/R/library/rmarkdown/rmd/h/default.html --no-highlight --variable highlightjs=1 --variable theme=bootstrap --mathjax --variable 'mathjax-url:https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML'

%.html: %.rmd
	Rscript  -e "rmarkdown::render('$<')"

%.html: %.md
	Rscript  -e "rmarkdown::render('$<')"

index.html: index.rmd sched.csv
	Rscript  -e "rmarkdown::render('$<')"

docs/%.html: %.html
	mv $< docs

