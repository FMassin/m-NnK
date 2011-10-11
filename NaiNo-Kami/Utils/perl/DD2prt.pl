#!/usr/bin/perl 
#             -w  affiche warning
use Math::Trig ; # module de trigo pour valeur de pi
# $ARGV[0] : liste de fichier inp a traiter

#make_prt($hyp2,$name,$time2eq,$NLLinp,$flag) ;
sub make_prt
{
        my ($hyp2,$name,$time2eq,$NLLinp,$flag,@stalist) = @_;
	if (-e $hyp2) {
                #print "DIR $hyp2 exists! \n";
                my $OUT=$hyp2."/".$name ;
                my $IN=$hyp2."/$flag.reloc" ; #$flag=hypoDD ou tomoDD
                `head -6 $time2eq > time2eq.inp`;
                `awk '{print "EQSRCE testYell LATLON " \$2 " " \$3 " " \$4 " 0.0"}' $IN >> time2eq.inp`;
                `awk '\$1 == "EQSTA" {print \$0}' $time2eq >> time2eq.inp`;
		`rm -r ./Time2Eq` ;
                `mkdir -p ./Time2Eq` ;
                `Time2EQ time2eq.inp` ;
                `NLLoc $NLLinp`;
                my $filoc = `ls Time2Eq/WY_.20000101.??????.grid0.loc.h71`;chomp($filoc);
                if (-e $filoc) {
                        open (OUTFILE,">$OUT") || die"!!!! cannot open output $OUT !!!!!!" ;
                        print OUTFILE "  DATE    ORIGIN   LATITUDE LONGITUDE  DEPTH    MAG NO           RMS\n";
                        my $line = `head -2 $filoc | tail -1`;
                        my $loc = `cat $IN`;chomp($loc);

			if ($flag eq "tomoDD") {$to = substr($loc,105,2).substr($loc,108,2).substr($loc,111,2)." ".substr($loc,114,2).substr($loc,117,2)." ".substr($loc,122,2).".".substr($loc,124,2);}
			if ($flag eq "hypoDD") {$to = substr($loc,105,2).substr($loc,108,2).substr($loc,111,2)." ".substr($loc,114,2).substr($loc,117,2)." ".substr($loc,120,5);}

                        $line =~ s/000101 0000 ...../$to/;
                        if (substr($line,18,1) eq "-") {$line =~ s/-/ /;$line =~ s/ -/s/; } else {$line = substr($line,0,21)."n".substr($line,22,51);}
                        if (substr($line,27,1) eq "-") {$line =~ s/-/ /;$line =~ s/ -/w/; }
                        $line = substr($line,0,54)."          ".substr($line,64,4);
                        print OUTFILE "$line\n\n  STN  DIST  AZ TOA PRMK HRMN  PSEC TPOBS              PRES  PWT\n";

                        # to see dist to real
                        my $difflat = ((substr($loc,11,9)-(substr($line,19,2)+(substr($line,22,5)/60)))*110);
                        my $difflon = ((substr($loc,22,10)-(substr($line,28,3)+(substr($line,32,5)/60)))*110);
                        my $diffdep = ((substr($loc,36,6)-substr($line,39,5)));
			if ((abs($difflat) > 1) || (abs($difflon) > 1) || (abs($diffdep) > 1)) {print "WARNING : delta_lat = $difflat  delta_lon = $difflon  delta_dep = $diffdep [km] in $OUT\n";}

                        foreach my $sta (@stalist) {
                                chomp($sta);
                                my $st = substr($sta,0,3);
                                my $w = substr($sta,3,3)."  ";
                                $w = substr($w,0,3);
                                my $line = `awk '\$1 == "$st" {print \$0}' $filoc `;
                                $line =~ s/ P.. / $w /;
                                $line = substr($line,0,66);
                                print OUTFILE "$line\n" ;
                        }
                        print OUTFILE "delta_lat = $difflat  delta_lon = $difflon  delta_dep = $diffdep [km] \n";
                        close(OUTFILE) ;
                        print "written : $OUT\n";
                } else {
                        print "WARNING : no $filoc\n"
                }
        }
        #return($date, $heure,  $year, $mont, $da, $hr, $minut, $seco, $lat, $lon, $dep, $RE, $RN, $RZ, $RMS, $cnt);
}

my @filelist ;
if (@ARGV > 0) {
	@filelist = `ls $ARGV[0]` ;
} else {
	system("ls -dl /data/4Fred/WF/WY/clst/1990/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh > tmp.txt ");
	system("ls -dl /data/4Fred/WF/WY/clst/1991/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/1992/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/1993/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/1994/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/1995/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/1996/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/1997/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/1998/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/1999/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/2000/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/2001/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/2002/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/2003/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/2004/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/2005/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/2006/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");	
        system("ls -dl /data/4Fred/WF/WY/clst/2007/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/2008/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/2009/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/2010/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
        system("ls -dl /data/4Fred/WF/WY/clst/2011/*/*/* | grep drw | awk '{print \$8}' | sed 's/.*/ls &\\\/events\\\/\\\*\\\/\\\*\\\.inp\\\.enriched/' | sh >> tmp.txt ");
	@filelist = `cat tmp.txt` ;
}

my $time2eq = "/home/fred/Documents/WY/4Time2Eq/Time2Eq.inp";
my $NLLinp = "/home/fred/Documents/WY/4Time2Eq/NLL.inp" ; 
my $lat = 0 ; 
my $lon = 0 ; 
my $prof = 0 ; 	
my $year = 0 ; 
my $month = 0 ; 
my $day = 0 ; 
my $hour = 0 ; 
my $min = 0 ; 
my $sec = 0 ; 
my $mag = 0 ; 
my $name = "h71.prt" ;
my $to = "";
my $RMS = 0 ; 
my $NO = 0;
my $picks= "" ;
##################################################
# ON VA  REPRENDRE LA
foreach my $file (@filelist) {  
	chomp($file) ;

	my $hyp1 = $file.".loc.hypo71" ;
	my $hyp2 = $file.".reloc.hypoDD.hypo71" ; 
	my $hyp3 = $file.".reloc.tomoDD.hypo71";
	my $hyp4 = $file.".loc.nlloc";
	my $hyp5 = $file.".reloc.hypoDD.nlloc" ; 
	my $hyp6 = $file.".reloc.tomoDD.nlloc" ; 
	my @stalist = `awk '{print \$1 \$2}' $file`; 

	if (-e $hyp4) {
		my $IN = `ls $hyp4/*.????????.??????*.h71`;
		chomp($IN) ;
		my $OUT = $hyp4."/".$name ;
		if (-e $IN) {
			`echo "  DATE    ORIGIN   LATITUDE LONGITUDE  DEPTH    MAG NO           RMS" > $OUT`;
			my $line = `head -2 $IN | tail -1`;chomp($line);
			if (substr($line,18,1) eq "-") {$line =~ s/-/ /;$line =~ s/ -/s/; } else {$line = substr($line,0,21)."n".substr($line,22,51);}
                        if (substr($line,27,1) eq "-") {$line =~ s/-/ /;$line =~ s/ -/w/; }
                        $line = substr($line,0,54)."          ".substr($line,64,4);
			`echo "$line" >> $OUT`;
			`echo " " >> $OUT`;
			`echo "  STN  DIST  AZ TOA PRMK HRMN  PSEC TPOBS              PRES  PWT" >> $OUT`;
			$NO = `wc -l $IN`; chomp($NO) ;$NO = substr($NO,0,2) - 4 ;
                	`tail -$NO $IN >> $OUT` ;
			print "written : $OUT\n";
		} else {print "WARNING : no $IN \n";}
	}

	my $flag = "hypoDD";
	make_prt($hyp2,$name,$time2eq,$NLLinp,$flag,@stalist) ;
	make_prt($hyp5,$name,$time2eq,$NLLinp,$flag,@stalist) ;
        $flag = "tomoDD";
        make_prt($hyp3,$name,$time2eq,$NLLinp,$flag,@stalist) ;
        make_prt($hyp6,$name,$time2eq,$NLLinp,$flag,@stalist) ;

	if (-e $hyp1) {
 		#print "DIR $hyp1 exists! \n";
		my $OUT=$hyp1."/".$name ;
		my $IN=$hyp1."/zl.h" ;
		open (OUTFILE,">$OUT") || die"!!!! cannot open output $OUT !!!!!!" ;
		my $line = `head -19 $IN | tail -1`; chomp($line) ;
		$to = substr($line,0,6)." ".substr($line,10,2).substr($line,16,2)." ".substr($line,22,5);
		$lat = `awk '\$1 ~ "Latitude" {print \$0}' $IN` ; chomp($lat) ;
		$lat = substr($lat,19,2).lc(substr($lat,28,1)).substr($lat,22,5);
		$lon = `awk '\$1 ~ "Longitude" {print \$0}' $IN` ; chomp($lon) ;
		$lon = substr($lon,18,3).lc(substr($lon,28,1)).substr($lon,22,5);
		$prof = `awk '\$1 ~ "Profondeur" {print \$0}' $IN` ; chomp($prof) ;
		$prof = substr($prof,21,6) ;
		$NO = `wc -l $IN`; chomp($NO) ;$NO = substr($NO,0,2) - 26 ;
 		$RMS = `awk '\$1 ~ "RMS" {print \$3}' $IN` ; chomp($RMS) ;	
		my $no1 = $NO+1 ; 
		$picks = `tail -$no1 $IN | head -$NO` ;
		$picks =~ s/ P/ IP/g ;
		$picks =~ s/ /  / ; $picks =~ s/\n/\n /g ;
		
		print OUTFILE "  DATE    ORIGIN   LATITUDE LONGITUDE  DEPTH    MAG NO           RMS\n";
		print OUTFILE " $to $lat $lon $prof   1.00 $NO          $RMS\n\n  STN  DIST  AZ TOA PRMK HRMN  PSEC TPOBS              PRES  PWT\n$picks";
		close(OUTFILE);
		print "written : $OUT\n";
 	}

}

	
  #					$dista{$element[0]} = substr(sqrt($disthory*$disthory+$deltpro*$deltpro),0,4) ;  # distance station hypocentre
  #					$azimu{$element[0]} = int(rad2deg(acos(abs($deltlat)/abs($disthory)))) ; # azimut station depuis nord 
  #					$incli{$element[0]} = 90-int(rad2deg(acos($disthory/$dista{$element[0]}))) ; # inclinaison a la station 
  #					if($deltlat < 0 && $deltlon < 0) { $azimu{$element[0]} = $azimu{$element[0]} ; } 
  #					if($deltlat < 0 && $deltlon > 0) { $azimu{$element[0]} = 360 -  $azimu{$element[0]} ;}
  #					if($deltlat > 0 && $deltlon < 0) { $azimu{$element[0]} = 180 - $azimu{$element[0]} ; }
  #					if($deltlat > 0 && $deltlon > 0) { $azimu{$element[0]} = 180 +  $azimu{$element[0]} ;}
  #					if($azimu{$element[0]} < 0) { $azimu{$element[0]} = 360 + $azimu{$element[0]} ;	}
  #					if($incli{$element[0]} < 0 ) { $incli{$element[0]} = 180 + $incli{$element[0]} ; }
  #					if(length($dista{$element[0]}) == 3 && $dista{$element[0]} >= 1) { $dista{$element[0]} = " ".$dista{$element[0]} ; }
  #					if($azimu{$element[0]} < 100 && $azimu{$element[0]}  >= 10) { $azimu{$element[0]}  = " ".$azimu{$element[0]} ; }
  #					if($azimu{$element[0]} < 10 ) { $azimu{$element[0]}  = "  ".$azimu{$element[0]}  ; }  				
 # 					if($incli{$element[0]} < 100 && $incli{$element[0]} >= 10) { $incli{$element[0]} = " ".$incli{$element[0]} ; }
#  					if($incli{$element[0]} < 10 ) {	$incli{$element[0]} = "  ".$incli{$element[0]} ; }

