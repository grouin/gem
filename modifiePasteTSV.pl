# Modifie les fichiers *paste en *tsv avec ligne d'entête et réduction
# des lignes vides

my @rep=<$ARGV[0]/*paste>;

foreach my $fichier (@rep) {
    my $sortie=$fichier; $sortie=~s/paste$/tsv/;
    warn "Produit $sortie à partir de $fichier\n";
    my $saut=0;
    
    open(E,$fichier);
    open(S,">$sortie");
    # Entête de fichier TSV
    print S "Genre\tTime-code\tMot\tEmotion\tCategorie\tClasse\tPolarite\tExpression\n";
    while (my $ligne=<E>) {
	chomp $ligne;
	# Ligne composée de tabulations sans contenu
	if ($ligne=~/^\t+$/) {
	    # La première ligne vide est imprimée, pas les suivantes
	    if ($saut==0) { print S "$ligne\n"; }
	    $saut++;
	}
	# Ligne avec contenu (genre, timestamp, mot, analyse émotionnelle)
	else { print S "$ligne\n"; $saut=0; }
    }
    close(E);
    close(S);
}
