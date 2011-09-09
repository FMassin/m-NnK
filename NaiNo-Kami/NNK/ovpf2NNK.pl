#!/usr/bin/perl 
#             -w  affiche warning
use List::Util qw( max );
##########################################################################################################################
##########################################################################################################################




my $file = $ARGV[0] ;
if(-e $file) {
	open (lefichier,"<$file") || print"WARNING: can't open variable definition file: ".$file ; 

	while(my $line = <lefichier>) {
        	chomp($line) ;
		# FJS PD0 091002210800.69      001.24 S 1                                     0 0.000000
		# 1   5   9             23      31
		my $sta = substr($line,1,3) ; 
		my $p = substr($line,5,2).' '.substr($line,9,15) ;
		my $s = 'S  '.substr($line,9,10).substr($line,31,5) ;
		my $c = 'C  '.substr($line,9,10).substr($line,41,5) ;	
		if($sta eq $ARGV[1]) { 

			if($ARGV[2] eq "P" ){
				if(substr($p,3,15) > 010101000000.00) {
					print "$p\n" ;
				}
			}
			if($ARGV[2] eq "S" ){
				if(substr($s,3,15) > 010101000000.00) {
					print "$s\n" ;
				}
			}
			if($ARGV[2] eq "C" ){
                                if(substr($c,3,15) > 010101000000.00) {
                                        print "$c\n" ;
                                }
                        }

		}
	}
}
