# bash rapide.sh

#racine=~/Bureau/projet-GEM/corpus/ina/
#corpus=GMMP/radio/lium_asr_xml/
#corpus=corpus_2/lium_asr_xml/

racine=./tv-realite/
#corpus=corpus-tvr2/
corpus=corpus-tvr-all/
#corpus=tmp/

case $1 in

    visu) perl visualisation-code-barre_v5.pl $racine/$corpus visu-emo.html $2;;

    conv) perl conversion-xml-to-tab.pl $racine/$corpus/ 0.5;;

    tag)
	for fichier in `ls $racine/$corpus/*tab`
	do
	    cat $fichier | sed "s/^$/§/g" >`echo $fichier | sed "s/tab/tok/"`
	done
	for fichier in `ls $racine/$corpus/*tok`
	do
	    ../../treetagger/bin/tree-tagger -token -lemma -no-unknown ../../treetagger/lib/french.par $fichier >`echo $fichier | sed "s/tok/tag/"`
	done
	for fichier in `ls $racine/$corpus/*tag`
	do
	    cat $fichier | sed "s/§\t.*\t§//g" >`echo $fichier | sed "s/tag/tok/"`
	done
	;;

    emo) perl fouille-emotions-colonne.pl $racine/$corpus
	 for fichier in `ls $racine/$corpus/*gen`
	 do
	     paste $fichier `echo $fichier | sed "s/gen/time/"` `echo $fichier | sed "s/gen/emo/"` >`echo $fichier | sed "s/gen/paste/"`
	 done
	 ;;

    all)
	perl conversion-xml-to-tab.pl $racine/$corpus/ 0

	for fichier in `ls $racine/$corpus/*tab`
	do
	    cat $fichier | sed "s/^$/§/g" >`echo $fichier | sed "s/tab/tok/"`
	done
	for fichier in `ls $racine/$corpus/*tok`
	do
	    ../../treetagger/bin/tree-tagger -token -lemma -no-unknown ../../treetagger/lib/french.par $fichier >`echo $fichier | sed "s/tok/tag/"`
	done
	for fichier in `ls $racine/$corpus/*tag`
	do
	    cat $fichier | sed "s/§\t.*\t§//g" >`echo $fichier | sed "s/tag/tok/"`
	done

	perl fouille-emotions-colonne.pl $racine/$corpus

	for fichier in `ls $racine/$corpus/*gen`
	do
	    paste $fichier `echo $fichier | sed "s/gen/time/"` `echo $fichier | sed "s/gen/emo/"` >`echo $fichier | sed "s/gen/paste/"`
	done

	perl modifiePasteTSV.pl $racine/$corpus

	perl visualisation-code-barre_v5.pl $racine/$corpus visu-emo.html

	## Spécifique à corpus-tvr/
	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-loft.csv $racine/$corpus/DL_T_VIS_20010503_M6__003_001.tsv >$racine/$corpus/DL_T_VIS_20010503_M6__003_001_confessionnal.tsv
	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-marseillais.csv $racine/$corpus/20210223W9_19002000.tsv >$racine/$corpus/20210223W9_19002000_confessionnal.tsv

	## Spécifique à corpus-tvr2/
	## - les fichiers timecode-xxx.csv ont été préparés manuellement par Laetitia, avec trois colonnes :   16:44.500    16:57.200   Jean-Edouard
	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-loft1a.csv $racine/$corpus/DL_T_VIS_20010503_M6__003_001.tsv >$racine/$corpus/DL_T_VIS_20010503_M6__003_001_confessionnal.tsv
	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-loft1b.csv $racine/$corpus/DL_T_VIS_20010503_M6__003_002.tsv >$racine/$corpus/DL_T_VIS_20010503_M6__003_002_confessionnal.tsv
	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-loft2a.csv $racine/$corpus/DL_T_VIS_20010524_M6__004_001.tsv >$racine/$corpus/DL_T_VIS_20010524_M6__004_001_confessionnal.tsv
	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-loft2b.csv $racine/$corpus/DL_T_VIS_20010524_M6__004_002.tsv >$racine/$corpus/DL_T_VIS_20010524_M6__004_002_confessionnal.tsv
	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-loft3a.csv $racine/$corpus/DL_T_VIS_20010531_M6__003_001.tsv >$racine/$corpus/DL_T_VIS_20010531_M6__003_001_confessionnal.tsv
	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-loft3b.csv $racine/$corpus/DL_T_VIS_20010531_M6__003_002.tsv >$racine/$corpus/DL_T_VIS_20010531_M6__003_002_confessionnal.tsv

	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-20210223W9.csv $racine/$corpus/20210223W9_19002000.tsv >$racine/$corpus/20210223W9_19002000_confessionnal.tsv
	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-20210226W9.csv $racine/$corpus/20210226W9_19002000.tsv >$racine/$corpus/20210226W9_19002000_confessionnal.tsv
	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-20210305W9.csv $racine/$corpus/20210305W9_20002100.tsv >$racine/$corpus/20210305W9_20002100_confessionnal.tsv
	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-20210402W9.csv $racine/$corpus/20210402W9_20002100.tsv >$racine/$corpus/20210402W9_20002100_confessionnal.tsv
	# perl $racine/mapping-timecode.pl $racine/$corpus/timecode-20210512W9.csv $racine/$corpus/20210512W9_19002000.tsv >$racine/$corpus/20210512W9_19002000_confessionnal.tsv

	## Boucle pour traiter corpus-tvr-all/ (correspondance directe entre fichier CSV de timecode et XML de transcription)
	## - les fichiers nom.csv ont été préparés par David et comprennent notamment les colonnes :    16:44.720   1004.72   16:57.480   1017.48   (nom du personnage absent)
	for fichier in `ls $racine/$corpus/*csv`
	do
	    tsv=`echo $fichier | sed "s/csv/tsv/"`
	    confes=`echo $tsv | sed "s/.tsv/\_confessionnal.tsv/"`
	    perl $racine/mapping-timecode-fichiers-david.pl $fichier $tsv >$confes
	done

	#rm $racine/$corpus/*{emo,gen,paste,tab,tag,time,tok}
	echo "Terminé"
	;;
esac
