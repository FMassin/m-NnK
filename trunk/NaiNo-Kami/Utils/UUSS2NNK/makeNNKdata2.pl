#!/usr/bin/perl 
#             -w  affiche warning
use File::Copy;
##########################################################################################################################
##########################################################################################################################

my $info = 1  ;

my $path2data = "/home/massin/compdata/" ;  # /eq/archive/eq/arc1/Arc/ /eq/arc1/Arc/
my $ext1 = "tar" ;    
my $dtecpath = "/home/massin/dtec/" ; 
#             10011919573
my $patern = "???????????" ;
my $statlist = "stalist.txt" ; 
my $command = "/eq/archive/eq/arc1/Arc/".$patern ; # /home/fred/Bureau/test/ /eq/archive/eq/arc1/Arc/ /eq/arc1/Arc/ 	
my $local = `pwd` ; 
`ls -d $command > tmp.txt` ;
`mkdir $path2data` ;
`mkdir $dtecpath` ;

open (FILES,"<tmp.txt") || print"WARNING: can't open constant definition file: tmp.txt" ;
while(my $file = <FILES>) {        
	chomp($file) ;        
	 
	my @element0 = split('/',$file) ;
	my $year = substr($element0[-1],0,2) ; 
	my $siecle = 1900 ;
	if($year < 70) {$siecle = 2000 ;}
	$year = $year+$siecle ; 
	my $dirtocreate1 = $dtecpath.$year ; 
	my $month = substr($element0[-1],2,2) ;
	my $dirtocreate2 = $dtecpath.$year."/".$month ;
	my $day = substr($element0[-1],4,2) ;
        my $dirtocreate3 = $dtecpath.$year."/".$month."/".$day ; 

	 	
	print "$file  $element0[-1] ...\n" ;
	my $yellowstone = `./eventfilt.pl $element0[-1]`;
	#my $yellowstone = "1" ;
	if(substr($yellowstone,0,1) eq "1") {
		print "$yellowstone\n" ;
        	`cp -r $file $path2data` ;
        	$file = $path2data.$element0[-1] ;

		my $filename = $element0[-1]+($siecle*1000000000) ; 
		my $dirtocreate = $dtecpath.$year."/".$month."/".$day."/".$filename ; 
		print "$subfile => $dirtocreate\n" ;
		
		unless(-d $dirtocreate1){ `mkdir $dirtocreate1` ; }
		unless(-d $dirtocreate2){ `mkdir $dirtocreate2` ; }
		unless(-d $dirtocreate3){ `mkdir $dirtocreate3` ; }

		my $command = "uw2sac -v -g ".$statlist." -d ".$filename." ".$file."/".$element0[-1] ;
		print "$command\n" ;
		`$command` ;
		`mv $filename $dirtocreate` ;
		`./staname4NNK.pl $dirtocreate` ;
		print "$dirtocreate edited\n" ; 
		`rm -r $file` ;
		print "$file cleaned \n" ;
	}

	print "______________________NEXT______________________\n"; 
}          

close(FILES) ;
`rm -r tmp.txt ` ;
