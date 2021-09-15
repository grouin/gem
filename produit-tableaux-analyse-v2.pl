#!/usr/bin/perl

# Produit des tableaux d'analyse du contenu des fichiers en OSE

# perl produit-tableaux-analyse.pl ~/Bureau/projet-GEM/corpus/ina/corpus_2/lium_asr_xml/ corpus2

my @rep=<$ARGV[0]/*paste>;
my $racine=$ARGV[1];
my %tabEmo=();
my $lisEmo=();
my %tabCat=();
my $lisCat=();
my %tabCla=();
my $lisCla=();
my %tabPol=();
my $lisPol=();

foreach my $fichier (@rep) {
    my $nom;
    if ($fichier=~/\/([^\/]*)$/) { $nom=$1; } $nom=~s/paste$/xml/;
    open(E,'<:utf8',$fichier);
    while (my $ligne=<E>){
	chomp $ligne;
	#if ($ligne=~/emo=([^\/]*)\/cat=([^\/]*)\/cla=([^\/]*)\/pol=([^\s]*) /) {
	if ($ligne=~/[^\t]$/) {
	    #my ($emo,$cat,$cla,$pol)=($1,$2,$3,$4);
	    my ($genre,$time,$mot,$emo,$cat,$cla,$pol,$expression)=split(/\t/,$ligne);
	    $tabEmo{$nom}{$emo}++;
	    $lisEmo{$emo}++;
	    $tabCat{$nom}{$cat}++;
	    $lisCat{$cat}++;
	    $tabCla{$nom}{$cla}++;
	    $lisCla{$cla}++;
	    $tabPol{$nom}{$pol}++;
	    $lisPol{$pol}++;
	    warn "<$ligne>\n" if ($pol eq "");
	}
    }
    close(E);
}


###
# Analyse des émotions

my $sortie=$racine."-emotions.tsv";
open(S,'>:utf8',$sortie);
print S "Fichier\t"; foreach my $emo (sort keys %lisEmo) { print S "$emo\t"; } print S "\n";
foreach my $nom (sort keys %tabEmo) {
    print S "$nom\t";
    # foreach my $emo (sort keys %{$tabEmo{$nom}}) {
    # 	print S "$emo\t";
    # }
    foreach my $emo (sort keys %lisEmo) {
	if (exists $tabEmo{$nom}{$emo}) { print S "$tabEmo{$nom}{$emo}\t"; }
	else { print S "0\t"; }
    }
    print S "\n";
}
close(S);

###
# Analyse des classes

my $sortie=$racine."-classes.tsv";
open(S,'>:utf8',$sortie);
print S "Fichier\t"; foreach my $cla (sort keys %lisCla) { print S "$cla\t"; } print S "\n";
foreach my $nom (sort keys %tabCla) {
    print S "$nom\t";
    foreach my $cla (sort keys %lisCla) {
	if (exists $tabCla{$nom}{$cla}) { print S "$tabCla{$nom}{$cla}\t"; }
	else { print S "0\t"; }
    }
    print S "\n";
}
close(S);

###
# Analyse des catégories

my $sortie=$racine."-categories.tsv";
open(S,'>:utf8',$sortie);
print S "Fichier\t"; foreach my $cat (sort keys %lisCat) { print S "$cat\t"; } print S "\n";
foreach my $nom (sort keys %tabCat) {
    print S "$nom\t";
    foreach my $cat (sort keys %lisCat) {
	if (exists $tabCat{$nom}{$cat}) { print S "$tabCat{$nom}{$cat}\t"; }
	else { print S "0\t"; }
    }
    print S "\n";
}
close(S);

###
# Analyse des polarités

my $sortie=$racine."-polarites.tsv";
open(S,'>:utf8',$sortie);
print S "Fichier\t"; foreach my $pol (sort keys %lisPol) { print S "$pol\t"; } print S "\n";
foreach my $nom (sort keys %tabPol) {
    print S "$nom\t";
    foreach my $pol (sort keys %lisPol) {
	if (exists $tabPol{$nom}{$pol}) { print S "$tabPol{$nom}{$pol}\t"; }
	else { print S "0\t"; }
    }
    print S "\n";
}
close(S);
