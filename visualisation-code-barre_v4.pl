# Pour chaque fichier *paste (issu de la concaténation de *gen avec
# *emo), produit une ligne au format HTML avec une barre verticale
# représentant une séquence de tokens de couleur bleu (femmes), jaune
# (hommes) ou blanche (absence d'émotion ou trop d'erreur de
# l'ASR). La teinte varie en fonction de la polarité : clair
# (positif), sombre (négatif), moyen (équilibre positif/négatif).

# Un argument (valeur numérique) correspondant à la taille maximale de
# la séquence en tokens analysée (une barre verticale en sortie
# représente une séquence) si une différence de genre n'a pas déjà
# segmenté la séquence. Remarques : on passe à la séquence suivante si
# le genre identifié diffère du précédent ; il est normal que la
# dernière barre d'une séquence corresponde au nombre maximum de
# tokens (cela signifie que la suite de la portion ne contenait aucune
# émotion et apparait en blanc)

# Auteur : Cyril Grouin, juillet 2021


# perl visualisation-code-barre.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ 100
# less ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/*emo
# cat -n ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/lapremiereguadeloupe_6h-9h.emo | egrep "pol="

use strict;

my ($chemin,$sortie,$tailleSequence)=@ARGV;

my @rep=<$chemin/*paste>;
$tailleSequence=100 if (!$tailleSequence); # Taille en tokens des séquences à analyser
$sortie="visu-emo.html" if (!$sortie);

my %codebarre=();
my %textecode=();
my %genres=();
my %nb=();

foreach my $fichier (@rep) {
    open(E,'<:utf8',$fichier);
    my $i=0;
    my $tokens="";
    my $note=0;
    my $genre=0;
    my $prec=0;
    while (my $ligne=<E>) {
	chomp $ligne;
	my @cols=split(/\t/,$ligne);
	my $expression=""; if ($cols[7] ne "") { $expression=$cols[7]; }  #if ($ligne=~/\((.+)\)/) { $expression=$1; }
	if ($ligne=~/^(\d)/) { $genre=$1; }
	# Note en fonction de l'émotion identifiée par séquence de n tokens
	#if ($ligne=~/cla=malveillance/) { $note=-10; $tokens.="$expression\, "; }
	#elsif ($ligne=~/pol=n.gatif/) { $note-=0.1; $tokens.="$expression\, "; }
	#elsif ($ligne=~/pol=positif/) { $note+=0.1; $tokens.="$expression\, "; }
	if ($cols[5]=~/malveillance/) { $note=-10; $tokens.="$expression\, "; }
	elsif ($cols[6]=~/n.gatif/) { $note-=0.1; $tokens.="$expression\, "; }
	elsif ($cols[6]=~/positif/) { $note+=0.1; $tokens.="$expression\, "; }
	$i++;
	if ($genre!=$prec || $i==$tailleSequence) { $codebarre{$fichier}.="$note\;"; $textecode{$fichier}.="$tokens\;"; $genres{$fichier}.="$genre\;"; $nb{$fichier}.="$i\;"; $i=0; $note=0; $tokens=""; }
	$prec=$genre;
    }
    close(E);
}

open(S,'>:utf8',$sortie);
print S "<html>\n <head>\n  <style type=\"text/css\">\n  <!--\n  .infobulle { position: absolute\; visibility: hidden\; border: 1px solid #333333\; padding: 3px\; font-family: Verdana, Arial\; font-size: 12px\; background-color: #EEEEEE\; }\n  \/\/-->\n  </style>\n  <script type=\"text/javascript\" src=\"infobulle.js\"></script>\n </head>\n";
print S " <body>\n  <div id=\"curseur\" class=\"infobulle\"><\/div>\n";
print S " <p>Chaque barre verticale correspond &agrave\; une s&eacute;quence exclusivement f&eacute\;minine (bleu) ou masculine (jaune) et au maximum compos&eacute\;e de $tailleSequence tokens. La teinte renvoie &agrave\; une polarit&eacute\; majoritairement positive (clair), n&eacute\;gative (sombre), parfaitement &eacute\;quilibr&eacute\;e entre positif et n&eacute\;gatif (moyen), ou malveillance (bleu roi ou orange)</p>\n";
print S " <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
foreach my $fichier (sort keys %codebarre) {
    my $nom=$fichier; $nom=~s/^.*\///; $nom=~s/.paste$//;
    print S "<tr><td>$nom<td><td>";
    my @notes=split(/\;/,$codebarre{$fichier});
    my @textes=split(/\;/,$textecode{$fichier});
    my @idGenre=split(/\;/,$genres{$fichier});
    my @nbTok=split(/\;/,$nb{$fichier});
    my $k=0;
    foreach my $note (@notes) {
	# Couleur de base : #FFFFFF
	my $r=255; my $v=255; my $b=255;
	# Femmes : bleu clair (positif), moyen (neutre), sombre (négatif)
	if ($idGenre[$k]==2) {
	    if ($note>0)    { $r=153; $v=255; $b=255; }
	    elsif ($note<-9) { $r=76; $v=76; $b=255; } # malveillance : bleu roi
	    elsif ($note<0) { $r=0; $v=153; $b=153; }
	    else            { $r=76; $v=204; $b=204; }
	}
	# Hommes : jaune clair (positif), moyen (neutre), sombre (négatif)
	elsif ($idGenre[$k]==1) {
	    if ($note>0)    { $r=255; $v=255; $b=153; }
	    elsif ($note<-9) { $r=221; $v=153; $b=0; } # malveillance : orange
	    elsif ($note<0) { $r=153; $v=153; $b=0; }
	    else            { $r=204; $v=204; $b=76; }
	}
	else { $r=255; $v=255; $b=255; }
	# Absence d'émotion, on passe au blanc
	if (length($textes[$k])<1) { $r=255; $v=255; $b=255; }

	# Conversion hexadécimale des codes couleur et normalisation
	$r=sprintf("%x",$r); $v=sprintf("%x",$v); $b=sprintf("%x",$b);
	$r="00" if ($r eq "0"); $v="00" if ($v eq "0"); $b="00" if ($b eq "0");
	# Affichage
	my $liste=$textes[$k]; $liste=~s/\, $//;
	print S "<a onMouseOver=\"montre('$liste (s\&eacute\;quence de $nbTok[$k] tokens)')\;\" onmouseout=\"cache()\;\">" if (length($textes[$k])>1);
	print S "<font style=\"background:\#$r$v$b;color:\#$r$v$b\" size=\"6\">.<\/font>";
	print S "</a>" if (length($textes[$k])>1);
	$k++;
    }
    print S "</td></tr>\n";
}
print S "</table></body></html>\n";
close(S);

