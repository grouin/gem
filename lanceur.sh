#!/usr/bin/bash

# Extraction des tokens de la reco si la confiance est supérieure à 0.5 : produit des fichiers *tab et *gen
perl conversion-xml-to-tab.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/ 0.5
perl conversion-xml-to-tab.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/ 0.5
perl conversion-xml-to-tab.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ 0.5
less ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/*tab

# Application du lexique emotaix : produit des fichiers *emo
perl fouille-emotions-colonne.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/
perl fouille-emotions-colonne.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/
perl fouille-emotions-colonne.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/
perl ratio-polarite.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/
perl ratio-polarite.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/
perl ratio-polarite.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/
less ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/*emo

# Analyse des fichiers et production de tableaux (pour les labos SHS)
perl produit-tableaux-analyse.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/ corpus2
perl produit-tableaux-analyse.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ GMMP-radio
perl produit-tableaux-analyse.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/ GMMP-tv


# Concaténation des fichiers *gen et *emo en *paste : permet d'avoir
# le genre de chaque locuteur et l'émotion détectée
for fichier in `ls ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/*gen`
do
    paste $fichier `echo $fichier | sed "s/gen/time/"` `echo $fichier | sed "s/gen/emo/"` >`echo $fichier | sed "s/gen/paste/"`
done

for fichier in `ls ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/*gen`
do
    paste $fichier `echo $fichier | sed "s/gen/time/"` `echo $fichier | sed "s/gen/emo/"` >`echo $fichier | sed "s/gen/paste/"`
done

for fichier in `ls ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/*gen`
do
    paste $fichier `echo $fichier | sed "s/gen/time/"` `echo $fichier | sed "s/gen/emo/"` >`echo $fichier | sed "s/gen/paste/"`
done

perl modifiePasteTSV.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/
perl modifiePasteTSV.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/
perl modifiePasteTSV.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/

###
# Préparation de l'archive pour les SHS
cd ~/Bureau/projet-GEM/corpus/ina/
tar -cvjf fichiers-emotions.tar.bz2 corpus_2/lium_asr_xml/*tsv GMMP/tv/lium_asr_xml/*tsv GMMP/radio/lium_asr_xml/*tsv
scp fichiers-emotions.tar.bz2 serveur@web
mkdir tmp
mv fichiers-emotions.tar.bz2 tmp
cd tmp
tree -H . -I index* -Dh -o index.html
scp index.html serveur@web
cd ../
rm -Rf tmp/
cd ~/Bureau/outils/GitHub/gem

less ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/*tsv


###
# Visualisation sous forme de code barres (pour communiquer sur le projet)
#perl visualisation-code-barre_v1.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/
perl visualisation-code-barre_v1.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/
perl visualisation-code-barre_v2.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ 300 32 16

perl visualisation-code-barre_v3.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/ corpus2.html 100
perl visualisation-code-barre_v3.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/ gmmp-tv.html 90
perl visualisation-code-barre_v3.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ gmmp-radio.html 150

perl visualisation-code-barre_v4.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/ corpus2.html 200
perl visualisation-code-barre_v4.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/ gmmp-tv.html 180
perl visualisation-code-barre_v4.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ gmmp-radio.html 300
