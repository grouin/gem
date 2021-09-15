# Pour chaque fichier *emo, produit une ligne au format HTML avec une
# barre verticale représentant une séquence de tokens de couleur
# verte, rouge ou grise si émotions positive, négative ou sans émotion
# identifiée dans la séquence.

# Les trois valeurs numériques en argument correspondent à :
# - la taille de la séquence en tokens analysée (une barre verticale
#   en sortie représente une séquence)
# - la valeur ajoutée ou retranchée dès qu'une opinion positive ou
#   négative est trouvée dans la séquence (une valeur de 128 est assez
#   binaire, des valeurs moindres permettent de travailler avec des
#   variations si jamais la séquence contient plusieurs émotions de
#   valence différente)
# - un dividende qui permet de s'assurer que les couleurs restent
#   vives si la valeur de modification du code couleur n'est pas de
#   128. S'assurer que les valeurs maximales affichées à l'écran
#   montent bien jusqu'à 255. Si ce n'est pas le cas, réduire la
#   valeur du dividende

# Auteur : Cyril Grouin, juillet 2021


# perl visualisation-code-barre.pl ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/ 10 32 2
# less ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/*emo
# cat -n ~/Bureau/projet-GEM/corpus/ina/GMMP/radio/lium_asr_xml/lapremiereguadeloupe_6h-9h.emo | egrep "pol="

use strict;

my ($chemin,$tailleSequence,$modif,$dividende)=@ARGV;

my @rep=<$chemin/*emo>;
$tailleSequence=10 if (!$tailleSequence); # Taille en tokens des séquences à analyser : 1    10  20  30  100  150  200  500
$modif=32 if (!$modif);                   # Valeur modifiant le code couleur décimal  : 128  32  16  64  32   32   32   32
$dividende=2 if (!$dividende);            # Dividende de normalisation                : 1    2   2   12  16   32   48   48

my ($maxR,$maxV,$maxB)=(0,0,0);
my %codebarre=();
my %textecode=();

foreach my $fichier (@rep) {
    open(E,'<:utf8',$fichier);
    my $i=0;
    my $tokens="";
    my $note=0;
    while (my $ligne=<E>) {
	chomp $ligne;
        my @cols=split(/\t/,$ligne);
	my $expression=""; if ($cols[5] ne "") { $expression=$cols[5]; }  #if ($ligne=~/\((.+)\)/) { $expression=$1; }
	# Note en fonction de l'émotion identifiée par séquence de n tokens
	#if ($ligne=~/pol=n.gatif/) { $note-=0.1; $tokens.="$expression\, "; }
	#elsif ($ligne=~/pol=positif/) { $note+=0.1; $tokens.="$expression\, "; }
	if ($cols[4]=~/n.gatif/) { $note-=0.1; $tokens.="$expression\, "; }
	elsif ($cols[4]=~/positif/) { $note+=0.1; $tokens.="$expression\, "; }
	$i++;
	if ($i==$tailleSequence) { $codebarre{$fichier}.="$note\;"; $textecode{$fichier}.="$tokens\;"; $i=0; $note=0; $tokens=""; }
    }
    close(E);
}

open(S,'>:utf8',"visu-emo.html");
print S "<html>\n <head>\n  <style type=\"text/css\">\n  <!--\n  .infobulle { position: absolute\; visibility: hidden\; border: 1px solid #333333\; padding: 3px\; font-family: Verdana, Arial\; font-size: 12px\; background-color: #EEEEEE\; }\n  \/\/-->\n  </style>\n  <script type=\"text/javascript\" src=\"infobulle.js\"></script>\n </head>\n";
print S " <body>\n  <div id=\"curseur\" class=\"infobulle\"><\/div>\n";
print S " <p>Chaque barre verticale correspond &agrave\; une s&eacute\;quence de $tailleSequence tokens</p>\n";
print S " <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n";
foreach my $fichier (sort keys %codebarre) {
    my $nom=$fichier; $nom=~s/^.*\///; $nom=~s/.emo$//;
    print S "<tr><td>$nom<td><td>";
    my @notes=split(/\;/,$codebarre{$fichier});
    my @textes=split(/\;/,$textecode{$fichier});
    my $k=0;
    foreach my $note (@notes) {
	# Couleur de base : #808080
	my $couleur=""; my $r=128; my $v=128; my $b=128;
	if ($note==0) { $couleur="lightgrey"; $r=128; $v=128; $b=128; }
	elsif ($note>0) { $couleur="darkgreen"; $r-=(($modif/($dividende/$tailleSequence))/2); $v+=($modif/($dividende/$tailleSequence)); }
	elsif ($note<0) { $couleur="red"; $r+=($modif/($dividende/$tailleSequence)); $v-=(($modif/($dividende/$tailleSequence))/2); }

	# Affichage ancienne version
	#print S "<font style=\"background:$couleur;color:$couleur\" size=\"6\">.<\/font>";

	# Normalisation pour ne pas dépasser les limites inférieures et supérieures
	$r=255 if ($r>255); $v=255 if ($v>255); $b=255 if ($b>255);
	$r=0 if ($r<0); $v=0 if ($v<0); $b=0 if ($b<0);
	$maxR=$r if ($r>$maxR); $maxV=$v if ($v>$maxV); $maxB=$b if ($b>$maxB);
	# - normalisation des bleus : 80 si r/v=80, 0 sinon ; permet du gris là où pas d'émotion, et des vert et rouge plus intenses
	if ($r!=128 || $v!=128) { $b=0; }
	# Conversion hexadécimale des codes couleur et normalisation
	$r=sprintf("%x",$r); $v=sprintf("%x",$v); $b=sprintf("%x",$b);
	$r="00" if ($r eq "0"); $v="00" if ($v eq "0"); $b="00" if ($b eq "0");
	if ($r==80 && $v==80 && $b==80) { $r="ee"; $v="ee"; $b="ee"; }
	if ($r eq "ee" && $v eq "ee" && $b eq "ee" && length($textes[$k])>1) { $r="ff"; $v="d7"; $b="00"; }
	# Affichage
	my $liste=$textes[$k]; $liste=~s/\, $//;
	print S "<a onMouseOver=\"montre('$liste')\;\" onmouseout=\"cache()\;\">" if (length($textes[$k])>1);
	print S "<font style=\"background:\#$r$v$b;color:\#$r$v$b\" size=\"6\">.<\/font>";
	print S "</a>" if (length($textes[$k])>1);
	$k++;
    }
    warn "$maxR\t$maxV\t$maxB\n"; $maxR=0; $maxV=0; $maxB=0;
    print S "</td></tr>\n";
}
print S "</table></body></html>\n";
close(S);

