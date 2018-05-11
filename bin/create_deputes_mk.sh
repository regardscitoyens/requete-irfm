#!/bin/bash

OLDIFS=$IFS
IFS=";"

echo ".PHONY: requetes_ta"
echo "requetes_ta: requetes_ta.pdf"
echo "requetes_ta.pdf:"
echo "	gs -q -sPAPERSIZE=a4 -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=\$@ \$^"
echo ""

cat $1 | while read line; do
  TOKENS=($line)
  num=${TOKENS[0]}
  if [ "$num" = "num" ]; then continue; fi

  nom=${TOKENS[1]}
  slug=${TOKENS[2]}
  sexe=${TOKENS[3]}
  adresse=${TOKENS[4]}
  refus=${TOKENS[5]}
  demande=${TOKENS[6]}
  bordereau=${TOKENS[7]}
  cada_no=${TOKENS[8]}
  avis_cada=${TOKENS[9]}
  date_cada=${TOKENS[10]}
  lar_envoi=${TOKENS[11]}
  lar_reception=${TOKENS[12]}
  
  dir=requetes-ta/requete-ta-$num-$slug

  if [ -z "$avis_cada" ]; then
    echo "*** WARNING *** pas d'avis cada pour $nom" >&2
    continue
  fi

  mkdir -p $dir
  
  echo "# $nom"
  echo ""
  echo "$dir/00-requete.md: sources/requete-ta.j2 sources/export_irfm.csv bin/create_md.py"
	echo "	\$(PYTHON) bin/create_md.py \$< sources/export_irfm.csv $num > \$@"
  
  echo "$dir/01-liste-pieces.md: sources/requete-ta-pieces.j2 sources/export_irfm.csv bin/create_md.py"
  echo "	\$(PYTHON) bin/create_md.py \$< sources/export_irfm.csv $num > \$@"
  
  pieces="fichiers_irfm/$demande"
  if [ "$avis_cada" ]; then
    pieces="$pieces fichiers_irfm/$avis_cada"
  fi

  echo "$dir-00-requete.pdf: $dir/00-requete.pdf"
  echo "	cp \$< \$@"
  echo "$dir-01-liste-pieces.pdf: $dir/01-liste-pieces.pdf"
  echo "	cp \$< \$@"
  echo "$dir-02-pieces.pdf: $pieces"
  echo "	gs -q -sPAPERSIZE=a4 -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=\$@ \$^"
  echo "$dir-joined.pdf: $dir-00-requete.pdf $dir-01-liste-pieces.pdf $dir-02-pieces.pdf"
  echo "	gs -q -sPAPERSIZE=a4 -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=\$@ \$^"
  echo "requetes_ta: $dir-joined.pdf $dir-00-requete.pdf $dir-01-liste-pieces.pdf $dir-02-pieces.pdf"
  echo "requetes_ta.pdf: $dir-joined.pdf"
  echo ""
done

IFS=$OLDIFS
