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
  date_refus=${TOKENS[5]}
  doc_refus=${TOKENS[6]}
  nb_pages_refus=${TOKENS[7]}
  demande=${TOKENS[8]}
  bordereau=${TOKENS[9]}
  cada_no=${TOKENS[10]}
  avis_cada=${TOKENS[11]}
  date_cada=${TOKENS[12]}
  lar_envoi=${TOKENS[13]}
  lar_reception=${TOKENS[14]}

  dir=requetes-ta/requete-ta-$num-$slug

  if [ -z "$avis_cada" ]; then
    echo "*** WARNING *** pas d'avis cada pour $nom" >&2
    continue
  fi

  mkdir -p $dir

  echo "# $nom"
  echo ""
  echo "$dir/00-requete.md: sources/requete-ta.j2 sources/export_irfm.csv bin/create_md.py"
	echo "	\$(PYTHON) bin/create_md.py \$< sources/export_irfm.csv $num \$@"

  echo "$dir/01-liste-pieces.md: sources/requete-ta-pieces.j2 sources/export_irfm.csv bin/create_md.py"
  	echo "	\$(PYTHON) bin/create_md.py \$< sources/export_irfm.csv $num \$@"

  echo "$dir/01-liste-pieces.bookmarks: sources/requete-ta-pieces-bookmark.j2 sources/export_irfm.csv bin/create_md.py"
  	echo "	\$(PYTHON) bin/create_md.py \$< sources/export_irfm.csv $num \$@"

  pieces="fichiers_irfm/demande-mail-$sexe.pdf fichiers_irfm/$demande"
  if [ "$doc_refus" ]; then
    pieces="$pieces fichiers_irfm/$doc_refus"
  fi
  if [ "$avis_cada" ]; then
    pieces="$pieces fichiers_irfm/$avis_cada"
  fi
  pieces="$pieces sources/pv-ta.pdf"

  echo "$dir-00-requete.pdf: $dir/00-requete-bn-signature.pdf"
  echo "	cp \$< \$@"
  echo "$dir/00-requete-bn-signature.pdf: $dir/00-requete-bn-11pages.pdf fichiers_irfm/scans/dernierepage_"$num".pdf"
  echo "	pdftk \$^ cat output \$@"
  echo "$dir/00-requete-bn-11pages.pdf: $dir/00-requete-bn.pdf"
  echo "	pdftk \$< cat 1-11 output \$@"
  echo "$dir/00-requete-bn.pdf: $dir/00-requete.pdf bin/create_deputes_mk.sh"
  echo "	gs  -sOutputFile=\$@  -sDEVICE=pdfwrite  -sColorConversionStrategy=Gray  -dProcessColorModel=/DeviceGray  -dCompatibilityLevel=1.4  -dNOPAUSE  -dBATCH \$< > /dev/null"
  echo "$dir-01-liste-pieces.pdf: $dir/01-liste-pieces.pdf"
  echo "	cp \$< \$@"
  echo "$dir-02-pieces.pdf: $pieces $dir/01-liste-pieces.bookmarks"
  echo "	gs -q -sPAPERSIZE=a4 -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=\$@ $pieces"
  echo "$dir-02-pieces.bookmarked.pdf: $dir-02-pieces.pdf $dir/01-liste-pieces.bookmarks"
  echo "	pdftk $dir-02-pieces.pdf update_info $dir/01-liste-pieces.bookmarks output \$@"
  echo "$dir-joined.pdf: $dir-00-requete.pdf $dir-01-liste-pieces.pdf $dir-02-pieces.bookmarked.pdf"
  echo "	gs -q -sPAPERSIZE=a4 -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=\$@ $pieces"
  echo "requetes_ta: $dir-joined.pdf $dir-00-requete.pdf $dir-01-liste-pieces.pdf $dir-02-pieces.pdf"
  echo "requetes_ta.pdf: $dir-joined.pdf"
  echo ""
done

IFS=$OLDIFS
