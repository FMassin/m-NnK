#!/usr/bin/perl 
#             -w  affiche warning
use List::Util qw( max );
use File::Copy;
##########################################################################################################################
##########################################################################################################################


my $pathtosac = "/Volumes/FRED_80GO/Data/4NNK/AH/" ;
my $patern = "??????.????.????.sac.lin" ;
my $command = $pathtosac.$patern ;  	
`ls $command > tmp.txt` ;

open (FILES,"<tmp.txt") || print"WARNING: can't open constant definition file: tmp.txt" ;
while(my $file = <FILES>) {        
	chomp($file) ;        
	my @element0 = split('/',$file) ;
	my $dirname = "20".substr($element0[-1],0,6).substr($element0[-1],7,4)."00" ;
	my $filename = substr($element0[-1],12,4).".sac.lin" ; 
#	print "$element0[-1] $dirname => $filename \n" ; 
	my $dirtocreate = $pathtosac.$dirname ;
	unless(-d $dirtocreate){ mkdir $dirtocreate ; }
	my $source = $file ; 
	my $direction = $dirtocreate."/".$filename ; 
	move( $source , $direction )  or die "echec du mv : $source => $direction \n" ; 
}           
