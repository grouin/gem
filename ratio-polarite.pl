# Calcule la proportion de concepts positif et négatif dans les fichiers *emo

# perl ratio-polarite.pl répertoire/

use utf8;
use strict;

my @rep=<$ARGV[0]/*emo>;

foreach my $fichier (@rep) {
    my ($pos,$neg,$mal,$tot,$warn)=(0,0,0,0,"");
    open(E,'<:utf8',$fichier);
    while (my $ligne=<E>) {
	chomp $ligne;
	my @cols=split(/\t/,$ligne);
	$pos++ if ($cols[4]=~/positif/);
	$neg++ if ($cols[4]=~/négatif/);
	$mal++ if ($cols[3]=~/malveillance/);
	$tot++ if ($cols[2] ne "");
    }
    close(E);

    my $prcP=0; $prcP=sprintf("%.3f",$pos/$tot) if ($tot>0);
    my $prcN=0; $prcN=sprintf("%.3f",$neg/$tot) if ($tot>0);
    my $prcM=0; $prcM=sprintf("%.3f",$mal/$tot) if ($tot>0);
    if ($prcN>0.57) { $warn="\tNEGATIF"; }
    if ($prcP>0.57) { $warn="\tPOSITIF"; }
    if ($prcM>0.1) { $warn.="\tMALVEILLANCE"; }
    print "$fichier\tpos=$prcP ($pos)\tneg=$prcN ($neg)\tmal=$prcM ($mal)$warn\n";
}
