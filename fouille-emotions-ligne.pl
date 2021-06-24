#!/usr/bin/perl

# Projette le lexique d'émotions "emotaix.tsv" sur un fichier texte.
# Format du fichier tsv :
#
# abaissant	mal-être	frustration	humiliation	figuré
# abaissement	mal-être	frustration	humiliation	figuré
# abaisser	mal-être	frustration	humiliation	figuré
# abandon	mal-être	dépression	tristesse	figuré
# abandonné	mal-être	dépression	tristesse	figuré


# Usage : perl fouille-emotions.pl <fichier_entrée> <fichier_sortie>
# - perl fouille-emotions.pl tf1-fr2-m6/tf1_20200404_jt.txt sortie-tf1.txt
# - cat sortie-tf1.txt | awk -F'\t' '{print $1}' | sed "s/ \(.*\)//g;" | sort | uniq -c | sort -n
# - cat sortie-tf1.txt | awk -F'\t' '{print $1}' | sed "s/ \(.*\)//g;" | awk -F'/' '{print $3}' | sort | uniq -c | sort -n


# Auteur : Cyril Grouin, octobre 2020.


use utf8;
use strict;

my $lexique="ressources/ose/emotaix.tsv";  # Lexique d'émotions
my $texte=$ARGV[0];         # Fichier à traiter
my $sortie=$ARGV[1];        # Fichier de sortie
my (%supra,%meta,%emotions,%sens);
my %polarite=(
    "anxiété"=>"négatif",
    "bien-être"=>"positif",
    "bienveillance"=>"positif",
    "mal-être"=>"négatif",
    "malveillance"=>"négatif",
    "sang-froid"=>"positif"
    );

die "perl fouille-emotions.pl fichier sortie\n" if ($#ARGV!=1);


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

open(E,'<:utf8',$texte);
open(S,'>:utf8',$sortie);
while (my $ligne=<E>) {
    chomp $ligne;
    $ligne=~s/\' /\'/g;
    my $tags="";

    ### 
    my @cols=split(/ /,$ligne);
    my $i=0;
    foreach my $token (@cols) {
	# Recherche d'un mot isolé
	if (exists $emotions{$token}) { my $info=&recupereEmotion($token); $tags.="$info ($token)"; }
	# Recherche d'expressions multi-tokens (de deux à cinq tokens)
	else {
	    if ($cols[$i+1] ne "") { my $terme="$cols[$i] $cols[$i+1]"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info ($terme)"; }}
	    if ($cols[$i+2] ne "") { my $terme="$cols[$i] $cols[$i+1] $cols[$i+2]"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info ($terme)"; }}	    
	    if ($cols[$i+3] ne "") { my $terme="$cols[$i] $cols[$i+1] $cols[$i+2] $cols[$i+3]"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info ($terme)"; }}	    
	    if ($cols[$i+4] ne "") { my $terme="$cols[$i] $cols[$i+1] $cols[$i+2] $cols[$i+3] $cols[$i+4]"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info ($terme)"; }}	    
	}
	# Cas particuliers : pluriel, infinitif
	if ($token=~/[rs]$/ && $tags eq "") { $token=~s/[rs]$//; if (exists $emotions{$token}) { my $info=&recupereEmotion($token); $tags.="$info ($token)"; }}
	if ($token=~/e$/ && $tags eq "") { $terme=$token; $terme.="r"; if (exists $emotions{$terme}) { my $info=&recupereEmotion($terme); $tags.="$info ($terme)"; }}
	$i++;
    }

    #chop $tags;
    print S "$tags\t$ligne\n";
}
close(E);
close(S);


sub recupereEmotion() {
    my $t=shift; my $s="";
    if ($emotions{$t} eq $meta{$t}) { $s="$emotions{$t}"; }
    else { $s="$emotions{$t}/$meta{$t}/$supra{$t}/$polarite{$supra{$t}}"; }
    return $s;
}
