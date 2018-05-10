MARKDOWNS=$(wildcard */*.md)
PDFS=$(patsubst %.md,%.pdf,$(MARKDOWNS))
JOINEDPDFS=$(patsubst %,joined-%.pdf,$(wildcard 20*))
IMAGES=$(wildcard images/*)

all: $(PDFS) pdfjoins.mk $(JOINEDPDFS)

%.md: %.j2
	python bin/create_md.py $< > $@

%.pdf: %.md $(IMAGES)
	pandoc --variable=lang:fr -V geometry:margin=1in  -s -S -o $@ $<

pdfjoins.mk: $(PDFS)
	echo -n "" > $@
	find . -mindepth 1 -maxdepth 1 -type d -name "20*" | \
	  while read d; do \
	    files=$$(find $$d -name '*.pdf' | sort | tr '\n' ' '); \
	    echo "joined-$$(basename $$d).pdf: $$files" >> $@; \
	    echo "	gs -q -sPAPERSIZE=a4 -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=\$$@ \$$^" >> $@; \
	  done

include pdfjoins.mk

clean:
	@rm $(PDFS)
	@rm $(JOINEDPDFS)
	@rm pdfjoins.mk
