#!/usr/bin/perl 
#             -w  affiche warning
use File::Copy;
##########################################################################################################################
##########################################################################################################################

my $info = 1  ;

my $path2data = "/home/massin/compdata/" ; 
my $dtecpath = "/home/massin/dtec/" ; 
my $patern = "10013?" ;
my $ext1 = "tar" ;    
my $ext2 = "gz" ; ; 
my $statlist = "/home/massin/stalist.txt" ; 
my $command = "/eq/archive/eq/new2/".$patern.'.'.$ext1.'.'.$ext2 ;  	
my $local = `pwd` ; 
`ls -d $command > tmp.txt` ;
`mkdir $path2data` ;
`mkdir $dtecpath` ;

open (FILES,"<tmp.txt") || print"WARNING: can't open constant definition file: tmp.txt" ;
while(my $file = <FILES>) {        
	chomp($file) ;        
	`cp $file $path2data` ;
	 
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

	my $name = substr($element0[-1],0,6) ;
	 	
	$file = $path2data.$name.".".$ext1.".".$ext2 ; 
	print "gunzip -d $file ... waiting $path2data$name.$ext1\n" ;
	`gunzip -d $file ` ;
	
	$file = $path2data.$name.".".$ext1 ; 
	if(-e $file) {

		print "tar -xvf $file ... waiting $name \n" ;
		`tar -xvf $file` ;

		$file = $name ; 
		if(-d $file) {
			print "moving  $file to $path2data$file \n" ;
			`mv $file $path2data$file` ;
			`ls $path2data$file/ > subtmp.txt` ; 
			open (SUBFILES,"<subtmp.txt") || print"WARNING: can't open constant definition file: subtmp.txt" ;
			while(my $subfile = <SUBFILES>) {
				chomp($subfile) ;
				print "$subfile ...\n" ;
				my @subelement0 = split('/',$subfile) ;
				my $oldfilename = $path2data.$name."/".$subelement0[-1]."/".$subelement0[-1] ; 
				my $filename  = substr($subelement0[-1],0,11) ; 
				my $yellowstone = `./eventfilt.pl $filename`;

				if(substr($yellowstone,0,1) eq "1") {
					my $filename = $subelement0[-1]+($siecle*1000000000) ; 
					my $dirtocreate = $dtecpath.$year."/".$month."/".$day."/".$filename ; 
					print "$subfile => $dirtocreate\n" ;
					
					unless(-d $dirtocreate1){ `mkdir $dirtocreate1` ; }
					unless(-d $dirtocreate2){ `mkdir $dirtocreate2` ; }
					unless(-d $dirtocreate3){ `mkdir $dirtocreate3` ; }
					
					my $command = "uw2sac -v -g ".$statlist." -d ".$filename." ".$oldfilename ;
					print "$command\n" ;
					`$command` ;
					`mv $filename $dirtocreate` ;
					`./staname4NNK.pl $dirtocreate` ; 
				}
			}

			close(SUBFILES) ; 
			`rm -r $path2data$file` ; 

		} else { print "tar -xvf gave nothing !\n" ;} 

		`rm $path2data$name.$ext1` ; 

	} else { print "gunzip gave nothing !\n" ;}
	
}          

close(FILES) ;
`rm -r tmp.txt subtmp.txt` ;
