IMAGES=$(wildcard images/*)

PYTHON?=python
PANDOC_OPTS?=-S

all: requetes_ta

%.pdf: %.md $(IMAGES)
	pandoc --variable=lang:fr -V geometry:margin=0.8in -V geometry:a4paper -s $(PANDOC_OPTS) -o $@ $<

deputes.mk: bin/create_deputes_mk.sh sources/export_irfm.csv
	bin/create_deputes_mk.sh sources/export_irfm.csv > $@

include deputes.mk

clean:
	@rm -R requetes-ta
	@rm deputes.mk
