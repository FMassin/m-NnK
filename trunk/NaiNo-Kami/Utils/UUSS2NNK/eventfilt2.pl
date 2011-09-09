#!/usr/bin/perl 
#             -w  affiche warning
##########################################################################################################################
##########################################################################################################################
my $stafile = "stalist.txt" ; 
my $goodfile = $ARGV[0] ;

if($ARGV[1] eq "v") { print "'-> $goodfile choosen ! \n" ;}
my $firstarrival = 9999 ;
my $firststation = "not found yet" ;
my $flag = 0 ;
if(-e $goodfile) {

	open (LINES,"<$goodfile") || print"WARNING: can't open constant definition file: $goodfile" ;
	while(my $line = <LINES>) {
		chomp($line) ; 
		# 0905111301
		#RCJZ
		#ARGU ?   1  54.41 0   0.00  49  2.13  4.30  68  84     0
		#  0   1   2   3
		my @element1 = split(' ',$line) ;
		my $nbelt = @element1 ; 
		if ($nbelt >= 4 & $element1[3] =~ m/\d+.\d+/) {
			if ($element1[3] < $firstarrival) {
				$firstarrival = $element1[3] ;
				$firststation = $element1[0] ;
			}
		}
	}
	open (STATS,"<$stafile") || print"WARNING: can't open constant definition file: $stafile" ;
	while(my $statest = <STATS>) {
		chomp($statest) ; 
		if ($statest eq $firststation) {
			$flag = 1 ; 
		 }
	}
	close(LINES) ;
	close(STATS) ;
}

if( $flag == 1) {
	print "1 it s a event first recorded on $firststation from the $stafile network\n" ;
} else {
	print "0 it s not a event recorded in the $stafile network\n" ;
}
