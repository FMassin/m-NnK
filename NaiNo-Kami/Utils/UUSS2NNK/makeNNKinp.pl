#!/usr/bin/perl 
#             -w  affiche warning
use File::Copy;
##########################################################################################################################
##########################################################################################################################

my $info = 1  ;
my $dtecpath = "/data/4Fred/WF/WY/dtec/" ; 
#my $dtecpath = "/data/4Fred/WF/WY/dtec/2009/12/20/20091220074850WY/???????????p" ; 

`ls -d $dtecpath????/??/??/??????????????WY/???????????p > tmp.txt` ;
open (LINES,"<tmp.txt") || print"WARNING: can't open constant definition file: tmp.txt" ;
while(my $file = <LINES>) {       
 
	chomp($file) ;        
	print "________________________________________________\n";
	print "$file \n" ;
	my @elemt = split('/',$file) ; 
	my $datehhmms = substr($elemt[-2],2,10) ;
	my $outfile = $dtecpath.$elemt[-5]."/".$elemt[-4]."/".$elemt[-3]."/".$elemt[-2]."/".substr($elemt[-2],2,12).".inp" ;
 	print "$outfile \n" ;

	open (SUBLINE,"<$file") || print"WARNING: can't open constant definition file: $file" ; 
	open (OUT,">$outfile") || print"WARNING: can't open constant definition file: $outfile" ;

	while(my $line = <SUBLINE>) {

		chomp($line) ; 
		my $stat = '   ' ;
		my $P = ' ' ;
		my $pol = ' ' ;
		my $weightP = ' ' ;
		my $pickP = '               ' ;
		my $pickS = '      ' ; 
		my $S = ' ' ; 
		my $weightS = ' ' ;
		my $pickC = '      ' ;
                my $C = ' ' ;

		my $flag = 0 ;
		if($line =~ /(\d\d\d\d\d\d\d\d\d\d)/) {$datehhmms = $1 ; }

		if($line =~ /(\w\w\w)[\s\w]\s([\w\?])\s*(\d)\s*(\d{1,2}\.\d{1,2})\s*(\d)\s*(\d{1,2}\.\d{1,2})/) { 
		# reconnait |YGC  ?   1  61.38 0   0.00   6  1.91  2.21  65  70     0
		# reconnait |yhbz d   0  60.43 2  61.50   0  0.00  0.00   0   0     0
		# reconnait |ymrz ?   1  62.47 2  64.81   0  0.00  0.00   0   0     0
		#            stat pol w  p     w  s       duration

			#print "$line\n" ;
			#print "$1 $2 $3 $4 $5 $6\n" ;

			$flag = 1 ; 
			 

			$stat = `./staname4NNK1.pl $1` ;
			$P = 'P';
			if($2 eq 'c') {$pol = 'C';}
			if($2 eq 'd') {$pol = 'D';}
			if($2 eq '?') {$pol = ' ';}
			$weightP = $3 ;
			$pickP = substr($4+100.001,1,5) ;

			if($6 > 0) { 
				$S = 'S' ;
				$weightS = $5 ; 
				$pickS = substr($6+1000.001,1,6) ; 
			}
			if($10 > 0) {
				$C = ' C' ;
				$pickC = substr($6+100.001,1,5) ;
 			}
		}

		if($flag == 1) {
			# FJS PD0 091002210800.69      001.24 S 1                                     0 0.000000
	                # 1   5   9             23      31
			print OUT " $stat $P$pol$weightP $datehhmms$pickP      $pickS $S $weightS $pickC $C                             0 0.000000\n" ; 
		}
 	}
	print OUT "                 10\n" ;
	close(SUBLINE) ;
	close(OUT) ; 
	print "______________________NEXT______________________\n";
}          
close(LINES) ;
`rm -r tmp.txt` ;
