# bash rapide.sh

racine=~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/

perl conversion-xml-to-tab.pl $racine/ 0.5

for fichier in `ls $racine/*tab`
do
    cat $fichier | sed "s/^$/§/g" >`echo $fichier | sed "s/tab/tok/"`
done
for fichier in `ls $racine/*tok`
do
    ../../treetagger/bin/tree-tagger -token -lemma -no-unknown ../../treetagger/lib/french.par $fichier >`echo $fichier | sed "s/tok/tag/"`
done
for fichier in `ls $racine/*tag`
do
    cat $fichier | sed "s/§\t.*\t§//g" >`echo $fichier | sed "s/tag/tok/"`
done


perl fouille-emotions-colonne.pl $racine

for fichier in `ls $racine/*gen`
do
    paste $fichier `echo $fichier | sed "s/gen/time/"` `echo $fichier | sed "s/gen/emo/"` >`echo $fichier | sed "s/gen/paste/"`
done

perl modifiePasteTSV.pl $racine

perl visualisation-code-barre_v5.pl $racine visu-emo.html

echo "Terminé"
