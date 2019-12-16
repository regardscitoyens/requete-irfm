all: tmp IRFM_CEDH_99_annexes.pdf

clean:
	rm -rf IRFM_CEDH_99_annexes.pdf tmp

tmp:
	mkdir -p tmp

IRFM_CEDH_99_annexes.pdf: tmp tmp/99_annexes.pdf tmp/numbers.pdf
	pdftk tmp/99_annexes.pdf multistamp tmp/numbers.pdf output IRFM_CEDH_99_annexes.pdf

tmp/99_annexes.pdf: Makefile tmp/deputes.docs tmp/demande-irfm-patrick-bloche.pdf tmp/demande-irfm-philippe-goujon.pdf tmp/20190628_IRFM_ConseildEtat.pdf tmp/20191202_PV-CEDH.pdf tmp/20100626_JO_CreationRegardsCitoyens.pdf tmp/RegardsCitoyens-Statuts-v2.pdf tmp/20180417_PrefectureMuret_RecepisseMD.pdf tmp/20180417_RegardsCitoyens_PVAssembleePermanente.pdf
	pdftk tmp/demande-irfm-patrick-bloche.pdf tmp/demande-irfm-philippe-goujon.pdf tmp/1746 tmp/2468 tmp/2458 tmp/2805 tmp/3007 tmp/3343 tmp/3340 tmp/3341 tmp/3342 tmp/3918 tmp/3919 tmp/20190628_IRFM_ConseildEtat.pdf tmp/20191202_PV-CEDH.pdf tmp/20100626_JO_CreationRegardsCitoyens.pdf tmp/RegardsCitoyens-Statuts-v2.pdf tmp/20180417_PrefectureMuret_RecepisseMD.pdf tmp/20180417_RegardsCitoyens_PVAssembleePermanente.pdf cat output tmp/99_annexes.pdf 

tmp/demande-irfm-patrick-bloche.pdf:
	curl -s https://irfm.regardscitoyens.org/files/demande-irfm-patrick-bloche.pdf > tmp/demande-irfm-patrick-bloche.pdf

tmp/demande-irfm-philippe-goujon.pdf:
	wget -q -O tmp/demande-irfm-philippe-goujon.pdf https://irfm.regardscitoyens.org/files/demande-irfm-philippe-goujon.pdf 

tmp/20190628_IRFM_ConseildEtat.pdf:
	wget -q -O tmp/20190628_IRFM_ConseildEtat.pdf https://www.regardscitoyens.org/temp/20190628_IRFM_ConseildEtat.pdf

tmp/20191202_PV-CEDH.pdf:
	wget -q -O tmp/20191202_PV-CEDH.pdf https://www.regardscitoyens.org/documents/association/20191202_PV-CEDH.pdf

tmp/20100626_JO_CreationRegardsCitoyens.pdf:
	wget -q -O tmp/20100626_JO_CreationRegardsCitoyens.pdf https://www.regardscitoyens.org/documents/association/20100626_JO_CreationRegardsCitoyens.pdf

tmp/RegardsCitoyens-Statuts-v2.pdf:
	wget -q -O tmp/RegardsCitoyens-Statuts-v2.pdf https://www.regardscitoyens.org/documents/RegardsCitoyens-Statuts-v2.pdf

tmp/20180417_RegardsCitoyens_PVAssembleePermanente.pdf:
	wget -q -O tmp/20180417_RegardsCitoyens_PVAssembleePermanente.pdf https://www.regardscitoyens.org/documents/association/20180417_RegardsCitoyens_PVAssembleePermanente.pdf

tmp/20180417_PrefectureMuret_RecepisseMD.pdf:
	wget -q -O tmp/20180417_PrefectureMuret_RecepisseMD.pdf https://www.regardscitoyens.org/documents/association/20180417_PrefectureMuret_RecepisseMD.pdf

tmp/deputes.docs: tmp/bloche.links tmp/goujon.links
	cd tmp ; wget -q -i bloche.links ; cd -
	cd tmp ; wget -q -i goujon.links ; cd -
	touch tmp/deputes.docs

tmp/bloche.links:
	curl -s https://irfm.regardscitoyens.org/parlementaires/332 | grep attachment | sed 's|.*href=.|https://irfm.regardscitoyens.org|' | sed 's|".*||' > tmp/bloche.links

tmp/goujon.links:
	curl -s https://irfm.regardscitoyens.org/parlementaires/189 | grep attachment | sed 's|.*href=.|https://irfm.regardscitoyens.org|' | sed 's|".*||' > tmp/goujon.links

tmp/numbers.pdf: numbers.tex
	pdflatex -output-directory=tmp numbers.tex
