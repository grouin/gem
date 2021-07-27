#!/usr/bin/bash

# Extraction des tokens de la reco si la confiance est supérieure à 0.5 : fichiers *tab
perl conversion-xml-to-tab.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/ 0.5

# Application du lexique emotaix : fichiers *emo
perl fouille-emotions-colonne.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/
perl ratio-polarite.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/

# Visualisation sous forme de code barres
#perl visualisation-code-barre.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/
perl visualisation-code-barre.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/
perl visualisation-code-barre_v2.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ 100 32 16

# Analyse des fichiers et production de tableaux
perl produit-tableaux-analyse.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/ corpus2
perl produit-tableaux-analyse.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ GMMP-radio
perl produit-tableaux-analyse.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/ GMMP-tv
