#!/usr/bin/perl 
#             -w  affiche warning
use List::Util qw( max );
use File::Copy;
##########################################################################################################################
##########################################################################################################################

my $info = 1  ;

my $pathtosac = "/Volumes/FRED_80GO/Data/4NNK/Sac/" ;
my $patern = "*" ;
my $command = $pathtosac.$patern ;  	
`ls -d $command > tmp.txt` ;

open (FILES,"<tmp.txt") || print"WARNING: can't open constant definition file: tmp.txt" ;
while(my $file = <FILES>) {        
	chomp($file) ;        
	my @element0 = split('/',$file) ;
	my $dirname = substr($element0[-2],0,8).substr($element0[-2],9,6) ;
	my $filename = $element0[-1] ; 
	print "$element0[-2] $element0[-1] $dirname => $filename \n" ; 

#	my $dirtocreate = $pathtosac.$dirname ;
#	unless(-d $dirtocreate){ mkdir $dirtocreate ; }
#	my $source = $file ; 
#	my $direction = $dirtocreate."/".$filename ; 
	move( $source , $direction )  or die "echec du mv : $source => $direction \n" ; 
}           
