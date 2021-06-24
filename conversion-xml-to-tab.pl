# Transforme les fichiers XML du LIUM (transcriptions) en fichiers de
# tokens pour application de modèles CRF (après ajout de colonnes de
# features) ou autres scripts. Pour faciliter un mapping, on conserve
# exactement le même nombre de lignes après l'extraction.

# <Word id="1" stime="0.15" dur="0.36" conf="0.86"> j' </Word>
# <Word id="2" stime="0.58" dur="0.59" conf="0.86"> aimerais </Word>
# <Word id="3" stime="1.22" dur="0.59" conf="0.85"> savoir </Word>
# <Word id="4" stime="2.04" dur="0.21" conf="0.95"> où </Word>
# <Word id="5" stime="2.28" dur="0.24" conf="1.00"> nous </Word>

# perl conversion-xml-to-tab.pl repertoire/transcriptions/ seuil

my @rep=<$ARGV[0]/*xml>;
my $min=$ARGV[1]; # Confiance minimale pour afficher le token
if (!$min) { $min=0.5; }

foreach my $in (@rep) {
    my $out=$in; $out=~s/xml$/tab/;
    warn "Produit $out à partir de $in\n";
    open(E,'<:utf8',$in);
    open(S,'>:utf8',$out);
    while (my $ligne=<E>) {
    	chomp $ligne;
    	# On imprime le token s'il s'agit d'une ligne de transcription
    	if ($ligne=~/<Word .* conf=\"([0-9\.]+)\"> (.*) <\/Word>/) {
    	    my ($conf,$token)=($1,$2);
    	    # Affichage du token si la confiance est supérieure à un seuil
    	    ($conf>=$min) ? (print S "$token\n") : (print S "\n");
    	}
    	# Sinon une ligne vide
    	else { print S "\n"; }
    }
    close(E);
    close(S);
}
