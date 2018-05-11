#!/bin/bash

OLDIFS=$IFS
IFS=";"

echo ".PHONY: requetes_ta"

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
  
  echo "$dir/00-requete.md: sources/requete-ta.j2 sources/export_irfm.csv bin/create_md.py"
	echo -e "\t\$(PYTHON) bin/create_md.py \$< sources/export_irfm.csv $num > \$@"

  files="$dir/00-requete.pdf fichiers_irfm/$demande"
  #if [ "$bordereau" ]; then
  #  files="$files fichiers_irfm/$bordereau"
  #fi
  if [ "$avis_cada" ]; then
    files="$files fichiers_irfm/$avis_cada"
  fi

  echo "requetes_ta: $dir.pdf"
  echo "$dir.pdf: $files"
  echo "	gs -q -sPAPERSIZE=a4 -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=\$@ \$^"
  echo ""
done

IFS=$OLDIFS
