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

# Visualisation sous forme de code barres (pour communiquer sur le projet)
#perl visualisation-code-barre_v1.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/
perl visualisation-code-barre_v1.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/
perl visualisation-code-barre_v2.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ 300 32 16

# Concaténation des fichiers *gen et *emo en *paste
for fichier in `ls ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/*gen`
do
    paste $fichier `echo $fichier | sed "s/gen/emo/"` >`echo $fichier | sed "s/gen/paste/"`
done

for fichier in `ls ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/*gen`
do
    paste $fichier `echo $fichier | sed "s/gen/emo/"` >`echo $fichier | sed "s/gen/paste/"`
done

for fichier in `ls ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/*gen`
do
    paste $fichier `echo $fichier | sed "s/gen/emo/"` >`echo $fichier | sed "s/gen/paste/"`
done

perl visualisation-code-barre_v3.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/ corpus2.html 100
perl visualisation-code-barre_v3.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/ gmmp-tv.html 90
perl visualisation-code-barre_v3.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ gmmp-radio.html 150

perl visualisation-code-barre_v4.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/ corpus2.html 200
perl visualisation-code-barre_v4.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/ gmmp-tv.html 180
perl visualisation-code-barre_v4.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ gmmp-radio.html 300
