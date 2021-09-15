# Transforme les fichiers XML du LIUM (transcriptions) en fichiers de
# tokens pour application de modèles CRF (après ajout de colonnes de
# features) ou autres scripts. Pour faciliter un mapping, on conserve
# exactement le même nombre de lignes après l'extraction. Deux types
# de fichiers sont produits : *tab avec un token par ligne (issu de la
# transcription) et des lignes vides (là où le fichier *xml ne
# contenait aucune transcription), et *gen avec l'identifiant du genre
# pour le tour de parole considéré.

# <Word id="1" stime="0.15" dur="0.36" conf="0.86"> j' </Word>
# <Word id="2" stime="0.58" dur="0.59" conf="0.86"> aimerais </Word>
# <Word id="3" stime="1.22" dur="0.59" conf="0.85"> savoir </Word>
# <Word id="4" stime="2.04" dur="0.21" conf="0.95"> où </Word>
# <Word id="5" stime="2.28" dur="0.24" conf="1.00"> nous </Word>

# perl conversion-xml-to-tab.pl repertoire/transcriptions/ seuil

use strict;

my @rep=<$ARGV[0]/*xml>;
my $min=$ARGV[1]; # Confiance minimale pour afficher le token
if (!$min) { $min=0.5; }

foreach my $in (@rep) {
    my $out=$in; $out=~s/xml$/tab/;
    my $out2=$in; $out2=~s/xml$/gen/;
    my $out3=$in; $out3=~s/xml$/time/;
    warn "Produit à partir de $in :\n- $out\n- $out2\n- $out3\n";
    open(E,'<:utf8',$in);
    open(S,'>:utf8',$out);
    open(G,'>:utf8',$out2);
    open(T,'>:utf8',$out3);
    my %corr=(); my $g="";
    while (my $ligne=<E>) {
    	chomp $ligne;
	# Stockage du genre pour chaque identifiant de locuteur (information au début du fichier)
	if ($ligne=~/Speaker .* gender=\"(\d)\" spkid=\"(S\d+)\"/) { my ($genre,$id)=($1,$2); $corr{$id}=$genre; }
	# Récupération des tours de parole et du genre associé à l'identifiant du locuteur
	if ($ligne=~/SpeechSegment .* spkid=\"(S\d+)\"/) { my $id=$1; $g=$corr{$id}; }
    	# On imprime le token s'il s'agit d'une ligne de transcription
    	if ($ligne=~/<Word .* stime=\"([0-9\.]+)\" .* conf=\"([0-9\.]+)\"> (.*) <\/Word>/) {
    	    my ($t,$conf,$token)=($1,$2,$3);
    	    # Affichage du token si la confiance est supérieure à un seuil
    	    ($conf>=$min) ? (print S "$token\n") : (print S "\n");
    	    ($conf>=$min) ? (print G "$g\n") : (print G "\n");
    	    ($conf>=$min) ? (print T "$t\n") : (print T "\n");
    	}
    	# Sinon une ligne vide
    	else { print S "\n"; print G "\n"; print T "\n"; }
    }
    close(E);
    close(S);
    close(G);
    close(T);
}
