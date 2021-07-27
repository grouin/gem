# Pour chaque fichier *emo, produit une ligne au format HTML avec une
# barre verticale représentant un token de couleur verte, rouge ou
# grise si émotions positive, négative ou sans émotion identifiée.

# perl visualisation-code-barre.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/
# perl visualisation-code-barre.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/

@rep=<$ARGV[0]/*emo>;
my $couleur="white";
my %codebarre=();

foreach my $fichier (@rep) {
    open(E,$fichier);
    while (my $ligne=<E>) {
	# Code couleur en fonction de l'émotion identifiée
	if ($ligne=~/pol=négatif/) { $couleur="red"; }
	elsif ($ligne=~/pol=positif/) { $couleur="darkgreen"; }
	elsif ($ligne=~/^\w+/) { $couleur="lightgrey"; }
	else { $couleur="white"; }
	$codebarre{$fichier}.="<font color=\"$couleur\">|</font>";
    }
    close(E);
}

open(S,'>:utf8',"visu-emo.html");
print S "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
foreach my $fichier (sort keys %codebarre) {
    my $nom=$fichier; $nom=~s/^.*\///; $nom=~s/.emo$//;
    my $ligne=$codebarre{$fichier};
    
    # Normalisation
    # - (i) suppression des barres blanches, ou (ii) réduction des barres blanches consécutives à une seule
    $ligne=~s/<font color=\"white\">\|<\/font>//g;
    #for (my $i=40;$i>=1;$i--) {	my $pattern="";	for (my $j=0;$j<=$i;$j++) { $pattern.="<font color=\"white\">\|<\/font>"; } $ligne=~s/\Q$pattern\E/<font color=\"white\">\|<\/font>/g; }

    # - (i) suppression des barres grises, ou (ii) réduction des barres grises consécutives à une seule, ou (iii) remplacement par l'espace
    $ligne=~s/<font color=\"lightgrey\">\|<\/font>//g;
    for (my $i=40;$i>=1;$i--) {	my $pattern="";	for (my $j=0;$j<=$i;$j++) { $pattern.="<font color=\"lightgrey\">\|<\/font>"; } $ligne=~s/\Q$pattern\E/<font color=\"lightgrey\">\|<\/font>/g; }
    #for (my $i=40;$i>=1;$i--) {	my $pattern="";	for (my $j=0;$j<=$i;$j++) { $pattern.="<font color=\"lightgrey\">\|<\/font>"; } $ligne=~s/\Q$pattern\E/ /g; }

    # - zones positivesnégatives consécutives
    $ligne=~s/<font color=\"red\">\|<\/font><font color=\"darkgreen\">\|<\/font>/<font style=\"background:orange;color:orange\" size=\"6\">.<\/font>/g;
    $ligne=~s/<font color=\"darkgreen\">\|<\/font><font color=\"red\">\|<\/font>/<font style=\"background:orange;color:orange\" size=\"6\">.<\/font>/g;

    # - optimisation des barres rouges et vertes
    for (my $i=40;$i>=0;$i--) {	my $pattern="";	for (my $j=0;$j<=$i;$j++) { $pattern.="<font color=\"red\">\|<\/font>"; } my $size=($j+3)*2; $ligne=~s/\Q$pattern\E/<font style=\"background:red;color:red\" size=\"$size\">.<\/font>/g; }
    for (my $i=40;$i>=0;$i--) {	my $pattern="";	for (my $j=0;$j<=$i;$j++) { $pattern.="<font color=\"darkgreen\">\|<\/font>"; } my $size=($j+3)*2; $ligne=~s/\Q$pattern\E/<font style=\"background:darkgreen;color:darkgreen\" size=\"$size\">.<\/font>/g; }

    
    print S "<tr><td>$nom<td><td>$ligne</td></tr>\n";
    my $taille=length($ligne);
    warn "$nom\t$taille\n";
}
print S "</table>";
close(S);
