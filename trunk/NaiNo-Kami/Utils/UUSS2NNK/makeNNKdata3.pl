#!/usr/bin/perl 
#             -w  affiche warning
use File::Copy;
##########################################################################################################################
##########################################################################################################################

my $info = 1  ;
my $dtecpath = "/home/massin/dtec/" ; 
#             10011919573
my $patern = "???????????" ;
my $statlist = "stalist.txt" ; 
my $local = `pwd` ; 

#my $command = "/eq/arc1/Arc/".$patern ;  	
#`ls -d $command > tmp.txt` ;
#my $command = "/eq/archive/eq/arc1/Arc/".$patern ; 
#`ls -d $command >> tmp.txt` ;
my $command = "/home/massin/data/".$patern ; 
`ls -d $command > tmp.txt` ;

unless(-d $dtecpath){ `mkdir $dtecpath` ; }

open (FILES,"<tmp.txt") || print"WARNING: can't open constant definition file: tmp.txt" ;
while(my $file = <FILES>) {       
 
	chomp($file) ;        
	my @uw2sacom = split('/',$file) ;
	my $uw2sacom = $uw2sacom[-1] ; 
	
	`ls $file/???????????p > subtmp.txt` ; 
	open (subFILES,"<subtmp.txt") || print"WARNING: can't open constant definition file: subtmp.txt" ; 
	while(my $subfile = <subFILES>) {

		chomp($subfile) ; 
		my @element0 = split('/',$subfile) ;
		my $year = substr($element0[-1],0,2) ; 
		my $siecle = 1900 ;
		if($year < 70) {$siecle = 2000 ;}
		$year = $year+$siecle ; 
		my $dirtocreate1 = $dtecpath.$year ; 
		my $month = substr($element0[-1],2,2) ;
		my $dirtocreate2 = $dtecpath.$year."/".$month ;
		my $day = substr($element0[-1],4,2) ;
		my $dirtocreate3 = $dtecpath.$year."/".$month."/".$day ; 

			
		print "./eventfilt2.pl $subfile\n" ;
		my $yellowstone = `./eventfilt1.pl $subfile`;
		################################################
	
		if(substr($yellowstone,0,1) eq "1") {

			$element0[-1] = substr($element0[-1],0,11) ;
			my $filename = ($element0[-1]+($siecle*1000000000))."0" ; 
			my $dirtocreate = $dtecpath.$year."/".$month."/".$day."/".$filename ; 

			print "$subfile => $dirtocreate\n" ;
			unless(-d $dirtocreate1){ `mkdir $dirtocreate1` ; }
			unless(-d $dirtocreate2){ `mkdir $dirtocreate2` ; }
			unless(-d $dirtocreate3){ `mkdir $dirtocreate3` ; }
			################################################################

			my $command = "uw2sac -v -g ".$statlist." -d ".$filename." ".$file."/".$uw2sacom ;
			print "$command\n" ;
			`$command` ;
			`mv $filename $dirtocreate` ;
			`./staname4NNK.pl $dirtocreate` ;
			`cp $subfile $dirtocreate/` ; 
			print "$dirtocreate edited and cp $subfile $dirtocreate done \n" ; 
		}

		print "______________________NEXT______________________\n";
	} 
	close(subFILES) ;
}          

close(FILES) ;
`rm -r tmp.txt subtmp.txt` ;
