#!/usr/bin/perl 
#             -w  affiche warning
##########################################################################################################################
##########################################################################################################################
my $Pdirect = "/home/Pfiles/localeq/" ;   
my $stafile = "stalist.txt" ; 


my @element0 = split('/',$ARGV[0]) ; 
my $file = substr($element0[-1]."0000000000000000000",0,12);
my $patern = substr(substr($element0[-1],0,8)."?????????????",0,11)."p" ;
my $year = substr($file,0,2) ; 
my $siecle = 1900 ; 
if($year < 70) {$siecle = 2000 ;}
$year = $year+$siecle ;

`ls $Pdirect$year/$patern > tmp0.txt` ;
if($ARGV[1] eq "v") { print "ls $Pdirect$year/$patern > tmp0.txt\n" ;}

my $testmem = 999999999999 ; 
my $goodfile = "not found yet" ; 

open (FILES,"<tmp0.txt") || print"WARNING: can't open constant definition file: tmp0.txt" ;
while(my $filetotest = <FILES>) {
	chomp($filetotest) ; 
	
	if($ARGV[1] eq "v") { print "$filetotest \n" ;} 
	
	my @element1 = split('/',$filetotest) ;
	my $test1 = substr($element1[-1],0,11)."0" ; #09 06 06 11 13 3p
	my $test = `./diffdate.pl $file $test1`; #abs($file-$test1) ;
	
	if($ARGV[1] eq "v") { print "$file - $test1 = $test  \n" ;} 
	$test = abs($test) ; 
	if($test <= 200 & $test < $testmem) {
		$goodfile = $filetotest ; 
		$testmem = $test ;
		if($ARGV[1] eq "v") { print "'-> $goodfile choosen ! \n" ;}
	}
}
close(FILES) ;

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
		if ($nbelt >= 4) {
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
`rm tmp0.txt` ;
