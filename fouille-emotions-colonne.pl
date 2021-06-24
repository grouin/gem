#!/usr/bin/perl

# Projette le lexique d'émotions "emotaix.tsv" sur un fichier texte.
# Format du fichier tsv :
#
# abaissant	mal-être	frustration	humiliation	figuré
# abaissement	mal-être	frustration	humiliation	figuré
# abaisser	mal-être	frustration	humiliation	figuré
# abandon	mal-être	dépression	tristesse	figuré
# abandonné	mal-être	dépression	tristesse	figuré


# Usage : perl fouille-emotions-colonne.pl répertoire/


# Auteur : Cyril Grouin, octobre 2020.


use utf8;
use strict;

my @rep=<$ARGV[0]/*tab>;
my $lexique="ressources/ose/emotaix.tsv";  # Lexique d'émotions
my (%supra,%meta,%emotions,%sens);
my %polarite=(
    "anxiété"=>"négatif",
    "bien-être"=>"positif",
    "bienveillance"=>"positif",
    "mal-être"=>"négatif",
    "malveillance"=>"négatif",
    "sang-froid"=>"positif"
    );


###
# Récupération des termes et expressions d'émotions

open(E,'<:utf8',$lexique);
while (my $ligne=<E>) {
    # Pour chaque entrée du lexique (clé), récupération des
    # supra-catégories, méta-catégories, émotions associées, ainsi que
    # du sens (propre/figuré)
    chomp $ligne;
    my @cols=split(/\t/,$ligne);
    $supra{$cols[0]}=$cols[1];
    $meta{$cols[0]}=$cols[2];
    $emotions{$cols[0]}=$cols[3];
    $sens{$cols[0]}=$cols[4];
}
close(E);


###
# Traitement du fichier

foreach my $texte (@rep) {
    my $sortie=$texte; $sortie=~s/tab$/emo/;
    my @lignes=();
    warn "Produit $sortie depuis $texte\n";

    open(E,'<:utf8',$texte);
    while (my $ligne=<E>) {
	chomp $ligne;
	$ligne=~s/\' /\'/g;
	push(@lignes,$ligne);
    }
    close(E);

    open(S,'>:utf8',$sortie);
    my $i=0;
    foreach my $token (@lignes) {
	my $tags="";
	my $terme="";

	### 
	# Recherche d'un mot isolé
	if (exists $emotions{$token}) { my $info=&recupereEmotion($token); $tags.="$info ($token)"; }
	# Recherche d'expressions multi-tokens (de deux à cinq tokens)
	else {
	    if ($lignes[$i+1] ne "") { $terme="$lignes[$i] $lignes[$i+1]"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info ($terme)"; }}
	    if ($lignes[$i+2] ne "") { $terme="$lignes[$i] $lignes[$i+1] $lignes[$i+2]"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info ($terme)"; }}
	    if ($lignes[$i+3] ne "") { $terme="$lignes[$i] $lignes[$i+1] $lignes[$i+2] $lignes[$i+3]"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info ($terme)"; }}
	    if ($lignes[$i+4] ne "") { $terme="$lignes[$i] $lignes[$i+1] $lignes[$i+2] $lignes[$i+3] $lignes[$i+4]"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info ($terme)"; }}
	}
	# Cas particuliers : pluriel, infinitif
	if ($token=~/s$/ && $tags eq "") { $terme=$token; $terme=~s/s$//; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info ($terme)"; }}
	if ($token=~/e$/ && $tags eq "") { $terme=$token; $terme.="r"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info ($terme)"; }}

	#$tags=~s/ \(.*\)$//;
	print S "$token\t$tags\n";
	$i++;
    }
    close(S);

}

sub recupereEmotion() {
    my $t=shift; my $s="";
    if ($emotions{$t} eq $meta{$t}) { $s="$emotions{$t}"; }
    else { $s="emo=$emotions{$t}/cat=$meta{$t}/cla=$supra{$t}/pol=$polarite{$supra{$t}}"; }
    return $s;
}
