#!/usr/bin/bash

# Extraction des tokens de la reco si la confiance est supérieure à 0.5 : fichiers *tab
perl conversion-xml-to-tab.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/ 0.5

# Application du lexique emotaix : fichiers *emo
perl fouille-emotions-colonne.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/
perl ratio-polarite.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/
