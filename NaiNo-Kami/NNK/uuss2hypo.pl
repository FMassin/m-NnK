#!/usr/bin/perl 
#             -w  affiche warning
use Time::Local
##########################################################################################################################
##########################################################################################################################

`ls $ARGV[0] > test`;
open (liste,"<test") || print"WARNING: can't open variable definition file: test";
my $stauuss = '\w\w\w'; my $staNNK ; my $sta = '   ' ;

while(my $file = <liste>) {
	chomp($file);
	my $fileout = substr($file,0,length($file)-1)."UUSS.inp"; 
	open (OUT,">$fileout") || print"WARNING: can't open variable definition file: ".$fileout."\n" ;
	print "opening $fileout\n";

	if(-e $file) {
		open (lefichier,"<$file") || print"WARNING: can't open variable definition file: ".$file."\n" ; 
		my $datehhmms = 0 ; my $year ; my $mon ; my $mday ; my $hour ; my $min ; my $sec = 0 ; 
		while(my $line = <lefichier>) {
	        	chomp($line) ;
	        	if($line =~ /(\d\d\d\d\d\d\d\d\d\d)/) {
				$datehhmms = $1 ; 
				$year = substr($datehhmms,0,2) ; if($year <= 70) {$year=$year+100;}
				$mon = substr($datehhmms,2,2)-1; 
				$mday = substr($datehhmms,4,2) ;
				$hour = substr($datehhmms,6,2) ; 
				$min = substr($datehhmms,8,2) ;
			}
	        	if($line =~ /($stauuss[\s\w])\s*([\w\?])\s*(\d)\s*(\d{1,3}\.\d{1,2})\s*(\d)\s*(\d{1,3}\.\d{1,2})\s*(\d{1,3})\s*(\d\.\d{1,2})\s*(\d\.\d{1,2})\s*(\d{1,2})\s*(\d{1,2})/) {
#				reconnait |yhbz d   0  60.43 2  61.50   0  0.00  0.00   0   0     
#            				   MCID ?   1  89.59 0   0.00  21  1.85  3.15  96 110     0
#            				   stat pol w  p     w  s       duration
		               	if($4 gt 0)  {
					$sta = $1 ;
					if(substr($sta,length($sta)-1,1) eq ' ') {$sta = substr($sta,0,length($sta)-1);}
					my $staNNK=$sta;
					if(-e "staname4NNK1.pl") {	
						if(substr($sta,length($sta)-1,1) eq 'z') {$sta = substr($sta,0,length($sta)-1);}
						if(substr($sta,length($sta)-1,1) eq 'Z') {$sta = substr($sta,0,length($sta)-1);}
						$staNNK = `./staname4NNK1.pl $sta 1` ;	
						print "changing original name $sta to $staNNK with ./staname4NNK1.pl $sta 1\n";
					}
					$sta2print = substr(' '.$staNNK,-4,4) ; 
#print "$sec $min $hour $mday $mon $year\n";
					my $time = timelocal($sec,$min,$hour,$mday,$mon,$year) ;
					my ($secP,$minP,$hourP,$mdayP,$monP,$yearP) = localtime($time+$4);
					my ($secS,$minS,$hourS,$mdayS,$monS,$yearS) = localtime($time+$6);
					my ($secC,$minC,$hourC,$mdayC,$monC,$yearC) = localtime($time+$4+$10);
					my ($secE,$minE,$hourE,$mdayE,$monE,$yearE) = localtime($time+$4+$7);

					if($minS ne $minP) {$secS = $secS+(60*int(1+(($time+$6)-($time+$4))/60)) ; };
					if($minC ne $minP) {$secC = $secC+(60*int(1+(($time+$10)-($time+$4))/60)) ; };
					if($minE ne $minP) {$secE = $secE+(60*int(1+(($time+$4+$7)-($time+$4))/60)) ; };

my $P = sprintf("%02d",substr(1000+$yearP,2,2)).sprintf("%02d",$monP+1).sprintf("%02d",$mdayP).sprintf("%02d",$hourP).sprintf("%02d",$minP).substr(100.001+$secP,1,2).'.'.substr(100.001+$4,4,2) ;
					my $S = substr('   '.$secS.'.'.substr(1000.001+$6,5,2),-6,6) ;
					my $C = substr('   '.$secC.'.'.substr(1000.001+$10,5,2),-6,6) ;
					my $E = substr('   '.$secE.'.'.substr(1000.001+$4+$7,5,2),-6,6) ;
					my $pol = $2 ; 	
					if($2 eq 'c') {$pol = 'C';}
					if($2 eq 'd') {$pol = 'D';}
					if($2 eq '?') {$pol = ' ';}
					my $WS=$5 ; my $WC='0' ;my $WE='0' ; 
					my $flagS=' ' ;if($6 > 0)  {$flagS='S';} else {$WS=' ' ; $S ='      ';};
					my $flagC=' ' ;if(($10 > 99990) & ($10 ne 10.00)) {$flagC='C';} else {$WC=' ' ; $C ='      ';};
					my $flagE=' ' ;if($7 > 99990)  {$flagE='E';} else {$WE=' ' ; $E ='      ';};

#lohz P 0 10 817 05845.52       47.27   2      0                           0
#0123456789 123456789 123456789 123456789 123456789 123456789 123456789 1234
#          10        20        30        40        50        60        70
		my $lineout=$sta2print.' P'.$pol.$3.' '.$P.'      '.$S.' '.$flagS.' '.$WS.'      '.$C.' '.$flagC.' '.$WC.'      '.$E.' '.$flagE.' '.$WE;
					print OUT "$lineout\n";
					#print "                                                                           in $fileout \n";
					#print "                                                                            $datehhmms---|$1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11-----|$sta\n";
				}
	        	}
	     	}
		close(lefichier);
	}
	print OUT "                 10\n";
	close(OUT) ;
}
close(liste);
