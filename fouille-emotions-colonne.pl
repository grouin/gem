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

my $ext="tok";  # *tab (v1), *tok (v2)
my @rep=<$ARGV[0]/*$ext>;
my $lexique="ressources/ose/emotaix.tsv";  # Lexique d'émotions
my (%supra,%meta,%emotions,%sens);
my %polarite=(
    "anxiété"=>"négatif",
    "bien-être"=>"positif",
    "bienveillance"=>"positif",
    "impassibilité"=>"inconnu",
    "mal-être"=>"négatif",
    "malveillance"=>"négatif",
    "sang-froid"=>"positif",
    "surprise"=>"inconnu",
    "non-specifié"=>"inconnu"
    );
# Dictionnaire d'exclusion : contexte => termes
my %exclusions=(
    "aucun"=>"souci",
    "dans un"=>"souci"
    );


###
# Récupération des termes et expressions d'émotions (emotaix)
#
# souci	anxiété	tension	inquiétude	propre
# soucier	anxiété	tension	inquiétude	propre
# soucieusement	anxiété	tension	inquiétude	propre
# soucieux	anxiété	tension	inquiétude	propre

open(E,'<:utf8',$lexique);
while (my $ligne=<E>) {
    # Pour chaque entrée du lexique (clé), récupération des
    # supra-catégories, méta-catégories, émotions associées, ainsi que
    # du sens (propre/figuré)
    chomp $ligne;
    my @cols=split(/\t/,$ligne);
    # Exclusion de qq entrées ambigües (interjections de surprise ou verbes dans des expressions)
    if ($cols[0]!~/^(ciel|diable|scier|sécher|souffler|souffle|soufflé)$/) {
	$supra{$cols[0]}=$cols[1];
	$meta{$cols[0]}=$cols[2];
	$emotions{$cols[0]}=$cols[3];
	$sens{$cols[0]}=$cols[4];
    }
}
close(E);


###
# Traitement du fichier

foreach my $texte (@rep) {
    my $sortie=$texte; $sortie=~s/$ext$/emo/;
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
    foreach my $ligne (@lignes) {
	my ($forme,$pos,$lemme)=split(/\t/,$ligne);
	my $token=$lemme; # travail sur les lemmes plutôt que les formes
	my $tags="";
	my $terme="";

	### 
	# Recherche d'un mot isolé
	if (exists $emotions{$token}) {
	    my $contexte="$lignes[$i-2] $lignes[$i-1]";
	    # On ne récupère pas les informations si le contexte gauche utilisé est associé au terme cherché
	    if (!exists $exclusions{$contexte} && $exclusions{$contexte}!~/$token/) { my $info=&recupereEmotion($token); $tags.="$info\t$token"; }
	}
	# Recherche d'expressions multi-tokens (de deux à cinq tokens)
	else {
	    if ($lignes[$i+4] ne "") { $terme="$lignes[$i] $lignes[$i+1] $lignes[$i+2] $lignes[$i+3] $lignes[$i+4]"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info\t$terme"; }}
	    if ($lignes[$i+3] ne "") { $terme="$lignes[$i] $lignes[$i+1] $lignes[$i+2] $lignes[$i+3]"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info\t$terme"; }}
	    if ($lignes[$i+2] ne "") { $terme="$lignes[$i] $lignes[$i+1] $lignes[$i+2]"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info\t$terme"; }}
	    if ($lignes[$i+1] ne "") { $terme="$lignes[$i] $lignes[$i+1]"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info\t$terme"; }}
	}
	# Cas particuliers : pluriel, infinitif
	if ($token=~/s$/ && $tags eq "") { $terme=$token; $terme=~s/s$//; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info\t$terme"; }}
	if ($token=~/e$/ && $tags eq "") { $terme=$token; $terme.="r"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info\t$terme"; }}

	print S "$forme\t$tags\n";
	$i++;
    }
    close(S);

}

sub recupereEmotion() {
    my $t=shift; my $s="";
    $s="$emotions{$t}\t$meta{$t}\t$supra{$t}\t$polarite{$supra{$t}}";
    return $s;
}
