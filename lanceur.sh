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

paste ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/bfmbusiness_6h-9h.gen ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/bfmbusiness_6h-9h.emo >~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/bfmbusiness_6h-9h.paste

# Visualisation sous forme de code barres (pour communiquer sur le projet)
#perl visualisation-code-barre_v1.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/
perl visualisation-code-barre_v1.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/
perl visualisation-code-barre_v2.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ 100 32 16

# Analyse des fichiers et production de tableaux (pour les labos SHS)
perl produit-tableaux-analyse.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/ corpus2
perl produit-tableaux-analyse.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ GMMP-radio
perl produit-tableaux-analyse.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/tv/lium_asr_xml/ GMMP-tv
