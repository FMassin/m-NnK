#!/usr/bin/perl 
#             -w  affiche warning 
##########################################################################################################################
##########################################################################################################################
sub read_hypodd
{
	my $date='00000000';my $heure='000000';my $lat='Nan';my $lon='Nan';my $year='Nan';my $mont='Nan'; my $da='Nan';my $dep='Nan';my $hr='Nan';my $minut='Nan';my $seco='Nan';my $flagE="";my $flagN="";my $RE=0;my $RN=0;my $RZ=0;my $RMS=0;my $cnt=0;my $RMSCT=0;my $cntCT=0;
	my ($reloc1D,$poub) = @_; 
	if (-e $reloc1D) {
	print "reading : $reloc1D \n" ; open(FILE,"<$reloc1D");
	my $line = <FILE>;
	chomp($line) ;
	$line =~ s/ \*\*\*\*\*\*\*\* / NaN /g;
	$line =~ s/ \*\*\*\*\*\* / NaN /g;
	my @test=split(" ",$line);
#..../tomoDD.reloc
#     210987654321
#     -10
	if (substr($reloc1D,-12,6) eq  "tomoDD") {$test[15] = $test[15]/100;}
#       71 -21.230163   55.719069     0.155      390.5      396.5      670.0    104.3    108.5    117.6 2007  2 11  4 18  1.110 1.0   148    30   461    55  0.009  0.002   1
#        0         1            2       3         4          5           6       7        8        9    10   11 12 13 14   15    16    17    18    19    20  21     22     23
	$date = $test[10]*10000+$test[11]*100+$test[12];
	$heure = $test[13]*10000+$test[14]*100+$test[15];
	$year = substr($date,0,4) ; $mont=substr($date,4,2); $da=substr($date,6,2);
	$hr = substr($heure,0,2) ; $minut=substr($heure,2,2); $seco=substr($heure,4,6);	
	$lat = $test[1]; $lon = $test[2]; $dep = $test[3]; 
	$RE = $test[7] ; $RN = $test[8] ; $RZ = $test[9];
	$RMS = $test[21]  ;  $cnt = $test[17]+$test[18] ; 
	$RMSCT = $test[22] ;  $cntCT = $test[19]+$test[20];
	close(FILE);
	}
	return($date, $heure,  $year, $mont, $da, $hr, $minut, $seco, $lat, $lon, $dep, $RE, $RN, $RZ, $RMS, $cnt, $RMSCT,$cntCT);
}
sub read_prt
{
	my ($loc1D,$poub) = @_; 
        my $date;my $heure;my $lat;my $lon;my $year;my $mont; my $da;my $dep;my $hr;my $minut;my $seco;my $flagE="";my $flagN="";my $RE=0;my $RN;my $RZ=0;my $RMS=0;my $cnt=0;
	if (-e $loc1D) {
	print "reading : $loc1D \n" ; open(FILE,"<$loc1D");
	my @elt = split('/',$loc1D);my $siecle = substr($elt[-2],0,3);$siecle =$siecle*100000; 
        while(my $line = <FILE>) {
                chomp($line) ;
                my @test=split(":",$line);@test = (split(" ",$test[0]) , split(" ",$test[1]));
                if($test[0] eq "RMS") {$RMS = $test[1] ; }
                if(($test[0] eq "Altitude") || ($test[0] eq "Profondeur"))   { $dep = -1*$test[3] ; $RZ = $test[-2];}
                if($test[0]  eq "Latitude") {$lat = $test[1]+($test[2]/60) ;    $RN = $test[10] ;
                if($test[3] eq "S") { $flagN = "-"; }}
                if($test[0] eq "Longitude") {$lon = $test[1]+($test[2]/60) ;    $RE = $test[10] ;
                if($test[3] eq "W") { $flagE = "-"; }}
                if($line =~ /([\d\s]\d\d\d\d\d)\s*(\d{1,2})\s*(\d{1,2})\s*(\d{1,2}\.\d{1,2})/) {
			$year = $1 ;
                    	if($year < 700000) {$year=20000000+$year;}
                    	elsif($year > 700000) {$year=19000000+$year;}
                        $date=$year;$da=1*substr($year,6,2);$mont=1*substr($year,4,2);$year=1*substr($year,0,4);
                	$hr=$2;$minut=$3;$seco=$4;$heure= substr(1000000.001+($hr*10000)+($minut*100)+$seco,1,9);
        	}
		my $test2 = substr($line,0,10) ; if($test2 =~ /\s(\d*)\s*(\d{1,3}\.\d{1,2})/) {	$cnt=$cnt+1;	}
        }
        close(FILE) ;
        $lon = $flagE.substr((substr($lon,0,9)+1000.00001),1,8) ;$lat = $flagN.substr((substr($lat,0,9)+1000.00001),2,7) ;
	}
	return($date, $heure,  $year, $mont, $da, $hr, $minut, $seco, $lat, $lon, $dep, $RE, $RN, $RZ, $RMS, $cnt);
}

sub read_hyp
{
        my ($loc3D,$poub) = @_;
        my $date;my $heure;my $lat;my $lon;my $year;my $mont; my $da;my $dep;my $hr;my $minut;my $seco;my $flagE="";my $flagN="";my $RE=0;my $RN;my $RZ=0;my $RMS=0;my $cnt=0;
	if (-e $loc3D) { 
	print "reading : $loc3D \n" ; open(FILE,"<$loc3D");
	while(my $line = <FILE>) {
		chomp($line) ;
                my @test=split(" ",$line);
#GEOGRAPHIC  OT 2009 04 08  16 15 38.238048  Lat 44.992525 Long -110.490702 Depth 5.775000
#         0  1     2  3  4   5  6  7          8   9          10    11       12     13
		if($test[0] eq "GEOGRAPHIC") {
			$year = $test[2] ; $mont = $test[3] ; $da = $test[4] ; $hr = $test[5] ; $minut = $test[6] ; $seco = $test[7] ;
			$lat = $test[9] ; $lon = $test[11] ; $dep = $test[13] ;
		}
#STATISTICS  ExpectX 4 Y -1 Z 7 CovXX 1 XY -5 XZ  2 YY  2 YZ -5 ZZ  4 EllAz1 314.7 Dip1 89.8 Len1 1 Az2  87.7 Dip2  0.1 Len2  6 Len3  9
#        0       1   2 3  4 5 6     7 8  9 10 11 12 13 14 15 16 17 18    19    20  21   22    23 24  25  26   27    28   29  30  31  32
		if($test[0] eq "STATISTICS") {
			$RE = $test[24] ; $RN = $test[30] ; $RZ = $test[32] ;
			$AE = $test[20] ; $AN = $test[26] ; 
			$DE = $test[22] ; $DN = $test[28] ;
			$AZ = 0 ; $DZ = 90 ;
		}
#QUALITY  Pmax 1 MFmin -nan MFmax -10.00 RMS 0.99 Nphs 16 Gap 299 Dist 36.271776 Mamp -9.90 0 Mdur -9.90 0
#      0    1  2    3   4   5        6    7   8    9   10  11  12   13  14        15   16  17  18   19  20
		if($test[0] eq "QUALITY") {
			$RMS = $test[8] ; $cnt = $test[10];
		}
	}
	$date = substr($year*10000+ $mont*100+ $da,0,8);
	$heure = substr(1000000.0000001+($hr*10000)+($minut*100)+$seco,1,13); 
	}
	return($date, $heure,  $year, $mont, $da, $hr, $minut, $seco, $lat, $lon, $dep, $RE, $RN, $RZ, $AE, $AN, $AZ, $DE, $DN, $DZ, $RMS, $cnt);
}
#my ($date, $heure,  $year, $mont, $da, $hr, $minut, $seco, $lat, $lon, $dep, $RE, $RN, $RZ, $AE, $AN, $AZ, $DE, $DN, $DZ, $RMS, $cnt) = read_hyp($loc3D);

my $fileM = "/Users/fredmassin/PostDoc_Utah/Datas/Magnitude/yell_nlloc_zmap_full_9311.cat" ;


my $sources = $ARGV[0] ; 
my $path = $ARGV[1] ;
my $numbcluster = 0;
my $numbevents = 0;
my $idcluster=0;
my $numinfo = 10;
my $now_string = localtime;
my $username = getlogin() ; 
my $loc=`pwd`;chomp($loc);
print "Writing in $path/clusters.m \nSee $path/clusters.old.m for overwriten file.\n";
if (@ARGV >= 2) { print "the new file will start at cluster $ARGV[2]\n";}

my @list = `ls -dl $sources/1980/??/??/???????????????? | grep drwxr` ;
 @list = ( @list, `ls -dl $sources/1981/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1982/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1983/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1984/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1985/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1986/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1987/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1988/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1989/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1990/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1991/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1992/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1993/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1994/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1995/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1996/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1997/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1998/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/1999/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/2000/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/2001/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/2002/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/2003/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/2004/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/2005/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/2006/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/2007/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/2008/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/2009/??/??/???????????????? | grep drwxr` );
 @list = ( @list, `ls -dl $sources/2010/??/??/???????????????? | grep drwxr` );

`mv $path/clusters.m $path/clusters.old.m`;
open (OUT,">".$path."clusters.m");

$numbcluster =  $#list + 1;
print OUT "function [clust]=clusters\n\n\n% function generated by $username on $now_string from $loc\n% and calling : NNK_dendro_1.pl $ARGV[0] $ARGV[1]\n%\n% usage : [clust]=clusters ;\n" ;
print OUT "% Cell 'clust' : clust{i} clusters id i\n";
print OUT "%                 clust{i}(k,:) event k all informations\n";
print OUT "%                   clust{i}{k,1} path of event k (char)\n";
print OUT "%                   clust{i}{k,2} name of event k (char, 'yyyymmddHHMMSSXX')\n";  
print OUT "%                   clust{i}{k,3} date of event k (num, matlab day)\n";
print OUT "%                   clust{i}{k,4} path of cluster of event k (char)\n";
print OUT "%\n";
print OUT "%                   HYPOCENTRE 1  1D loc RAW picks\n";
print OUT "%                   clust{i}{k,5} path of pick file of event k (char)\n";
print OUT "%                   clust{i}{k,6} [ X Y Z erX erY erZ azX azY azZ dipX dipY dipZ RMS numsta year month day hour min sec 0 0] (num)\n";
print OUT "%                   HYPOCENTRE 2  1D loc XCORR picks\n";
print OUT "%                   clust{i}{k,7} path of pick file of event k (char)\n";
print OUT "%                   clust{i}{k,8} [ X Y Z erX erY erZ azX azY azZ dipX dipY dipZ RMS numsta year month day hour min sec 0 0] (num)\n";
print OUT "%                   HYPOCENTRE 3  1D loc ENRICHED picks\n";
print OUT "%                   clust{i}{k,9} path of pick file of event k (char)\n";
print OUT "%                   clust{i}{k,10} [ X Y Z erX erY erZ azX azY azZ dipX dipY dipZ RMS numsta year month day hour min sec 0 0] (num)\n";
print OUT "%\n";
print OUT "%                   HYPOCENTRE 4  3D loc raw picks\n";
print OUT "%                   clust{i}{k,11} path of enrichied pick file of event k (char)\n";
print OUT "%                   clust{i}{k,12} [ X Y Z erX erY erZ azX azY azZ dipX dipY dipZ RMS numsta year month day hour min sec 0 0 ] (num)\n";
print OUT "%                   HYPOCENTRE 5  3D loc XCORR picks\n";
print OUT "%                   clust{i}{k,13} path of pick file of event k (char)\n";
print OUT "%                   clust{i}{k,14} [ X Y Z erX erY erZ azX azY azZ dipX dipY dipZ RMS numsta year month day hour min sec 0 0] (num)\n";
print OUT "%                   HYPOCENTRE 6  3D loc ENRICHED picks\n";
print OUT "%                   clust{i}{k,15} path of pick file of event k (char)\n";
print OUT "%                   clust{i}{k,16} [ X Y Z erX erY erZ azX azY azZ dipX dipY dipZ RMS numsta year month day hour min sec 0 0] (num)\n";
#                                                                  EllAz1  314.7 Dip1  89.8 Len1  1.27e+01 Az2  87.7 Dip2  0.1 Len2  6.85e+01 Len3  9.62e+01
print OUT "%\n";
print OUT "%                   HYPOCENTRE 7  1D reloc ENRICHED picks\n";
print OUT "%                   clust{i}{k,17} path of enrichied pick file of event k (char)\n";
print OUT "%                   clust{i}{k,18} [ X Y Z erX erY erZ azX azY azZ dipX dipY dipZ RMS-cc numsta-cc year month day hour min sec RMS-ct numsta-ct] (num)\n";
print OUT "%                   HYPOCENTRE 8  1D reloc ENRICHED picks\n";
print OUT "%                   clust{i}{k,17} path of enrichied pick file of event k (char)\n";
print OUT "%                   clust{i}{k,18} [ X Y Z erX erY erZ azX azY azZ dipX dipY dipZ RMS-cc numsta-cc year month day hour min sec RMS-ct numsta-ct] (num)\n";
print OUT "%                   HYPOCENTRE 9  1D reloc ENRICHED picks\n";
print OUT "%                   clust{i}{k,17} path of enrichied pick file of event k (char)\n";
print OUT "%                   clust{i}{k,18} [ X Y Z erX erY erZ azX azY azZ dipX dipY dipZ RMS-cc numsta-cc year month day hour min sec RMS-ct numsta-ct] (num)\n";
print OUT "%                   HYPOCENTRE 10  1D reloc ENRICHED picks\n";
print OUT "%                   clust{i}{k,17} path of enrichied pick file of event k (char)\n";
print OUT "%                   clust{i}{k,18} [ X Y Z erX erY erZ azX azY azZ dipX dipY dipZ RMS-cc numsta-cc year month day hour min sec RMS-ct numsta-ct] (num)\n";
print OUT "%\n";
print OUT "%                   MAGNITUDE AND MOMENT\n";
print OUT "%                   clust{i}{k,25} coda magnitude\n% From empirical relation :\n% Jamie Mark Farrell, Space-time seismicity and development of a geographical information system database with interactive graphics for the yellowstone region, Master’s thesis, Department of Geology and Geo- physics, the University of Utah, 2007.\n% Pechmann, J. C., J. C. Bernier, S. J. Nava, F. M. Terra, and W. J. Arabasz (2001), Correction of systematic time-dependent coda magnitude errors in the Utah and Yellowstone National Park region earthquake catalogs, 1981-2001, EOS Trans. AGU 82(47), Fall Meet. Suppl., Abstract S11B-0572.\n";
print OUT "%                   clust{i}{k,26} seismic moment [dyn.cm] \n% From empirical relation : \n% Doser, D. I., and R. B. Smith (1982), Seismic moment rates in the Utah region, Bull. Seismol. Soc. Am., 72(2), 525–552.\n% C.M. Puskas, R. B. Smith, C. M. Meertens, and W. L. Chang, Crustal deformation of the yellowstone– snake river plain volcano-tectonic system: Campaign and continuous gps observations, 1987–2004, Jour- nal of Geophysical Research 112 (2007), no. B03401.\n";
print OUT "% \n\n";
print OUT "% Fred Massin, UofU SATRG, May 7th 2011, fred.massin-\@-gmail.com\n";


print OUT "\nclust=cell($numbcluster,1);\n";
foreach $item(@list) {
	chomp($item) ;
	$idcluster = $idcluster + 1;
	my @elt = split(' ', $item) ;
	my $paf = $elt[-1] ; 
	my @intralist = `ls -d $paf/events/??????????????WY` ;
	my $numbevent =  $#intralist + 1;
	my $idevent = 0; 
	if (@ARGV >= 2) {
		if ($ARGV[2] <= $idcluster) {
			print OUT "clust{$idcluster}=cell($numbevent,$numinfo);\n";
			foreach $event(@intralist) {
				chomp($event) ;
				$idevent = $idevent + 1;
				my @eltevent = split("/",$event);
				my $date = substr($eltevent[-1],0,14).".00" ;

		# PRINTING FILE 'N PATH STUFFS
				print OUT "clust{$idcluster}{$idevent,1} = '$event' ; \n" ;
				print OUT "clust{$idcluster}{$idevent,2} = '$eltevent[-1]' ; \n" ;
				print OUT "clust{$idcluster}{$idevent,4} = '$paf';\n";



		# PRINTING 1D ABSOLUTE LOCATION STUFFS
				my $Rawloc1D = $event.'/'.$eltevent[-1].'.UUSS.inp.loc.hypo71/zl.h';
				my $Xcorrloc1D = $event.'/'.$eltevent[-1].'.inp.loc.hypo71/zl.h';
				my $Enrichedloc1D = $event.'/'.$eltevent[-1].'.inp.enriched.loc.hypo71/zl.h';

				my ($dateEQ,$heure,$year,$mont,$da,$hr,$minut,$seco,$lat,$lon,$dep,$RE,$RN,$RZ,$RMS,$sta)=read_prt($Rawloc1D) ;
				if ((1*$lat ne 0) && (1*$lon ne 0) && (1*$year ne 0)) {
					$date = substr($dateEQ,0,8).$heure; 
		print OUT "clust{$idcluster}{$idevent,5} = '$Rawloc1D' ;\nclust{$idcluster}{$idevent,6} = [$lon $lat $dep  $RE $RN $RZ  90 0 0  0 0 90  $RMS $sta $year $mont $da $hr $minut $seco 0 0] ; \n" ;	
				} else {print OUT "clust{$idcluster}{$idevent,5} = '' ;\nclust{$idcluster}{$idevent,6}(1:22) = NaN ;\n";} 

				my ($dateEQ,$heure,$year,$mont,$da,$hr,$minut,$seco,$lat,$lon,$dep,$RE,$RN,$RZ,$RMS,$sta)=read_prt($Xcorrloc1D) ;
				if ((1*$lat ne 0) && (1*$lon ne 0) && (1*$year ne 0)) {
					$date = substr($dateEQ,0,8).$heure;
		print OUT "clust{$idcluster}{$idevent,7} = '$Xcorrloc1D' ;\nclust{$idcluster}{$idevent,8} = [$lon $lat $dep  $RE $RN $RZ  90 0 0  0 0 90  $RMS $sta $year $mont $da $hr $minut $seco 0 0] ; \n" ;
				} else {print OUT "clust{$idcluster}{$idevent,7} = '' ;\nclust{$idcluster}{$idevent,8}(1:22) = NaN ;\n";}

				my ($dateEQ,$heure,$year,$mont,$da,$hr,$minut,$seco,$lat,$lon,$dep,$RE,$RN,$RZ,$RMS,$sta)=read_prt($Enrichedloc1D) ;
				if ((1*$lat ne 0) && (1*$lon ne 0) && (1*$year ne 0)) {
					$date = substr($dateEQ,0,8).$heure;
		print OUT "clust{$idcluster}{$idevent,9} = '$Enrichedloc1D' ;\nclust{$idcluster}{$idevent,10} = [$lon $lat $dep  $RE $RN $RZ  90 0 0  0 0 90  $RMS $sta $year $mont $da $hr $minut $seco 0 0] ; \n" ;
				} else {print OUT "clust{$idcluster}{$idevent,7} = '' ;\nclust{$idcluster}{$idevent,8}(1:22) = NaN ;\n";}
			
		# PRINTING 3D ABSOLUTE LOCATION STUFFS	
				my $Rawloc3D = `ls $event/$eltevent[-1].UUSS.inp.loc.nlloc/*.????????.??????.grid0.loc.hyp `;
				my $Xcorrloc3D = `ls $event/$eltevent[-1].inp.loc.nlloc/*.????????.??????.grid0.loc.hyp `;
				my $Enrichedloc3D = `ls $event/$eltevent[-1].inp.enriched.loc.nlloc/*.????????.??????.grid0.loc.hyp `;
				chomp($Rawloc3D);chomp($Xcorrloc3D);chomp($Enrichedloc3D); #print "$Rawloc3D\n$Xcorrloc3D\n$Enrichedloc3D \n";

				my ($dateEQ,$heure,$year,$mont,$da,$hr,$minut,$seco,$lat,$lon,$dep,$RE,$RN,$RZ,$AE,$AN,$AZ,$DE,$DN,$DZ,$RMS,$sta) = read_hyp($Rawloc3D);
				if ((1*$lat ne 0) && (1*$lon ne 0) && (1*$year ne 0)) {
					$date = substr($dateEQ,0,8).$heure;
		print OUT "clust{$idcluster}{$idevent,11} = '$Rawloc3D' ;\nclust{$idcluster}{$idevent,12} = [$lon $lat $dep  $RE $RN $RZ  $AE $AN $AZ  $DE $DN $DZ  $RMS $sta $year $mont $da $hr $minut $seco 0 0] ; \n" ;
				} else {print OUT "clust{$idcluster}{$idevent,11} = '' ;\nclust{$idcluster}{$idevent,12}(1:22) = NaN ;\n";}
					
				my ($dateEQ, $heure,  $year, $mont, $da, $hr, $minut, $seco, $lat, $lon, $dep, $RE, $RN, $RZ, $AE, $AN, $AZ, $DE, $DN, $DZ, $RMS, $sta) = read_hyp($Xcorrloc3D);
				if ((1*$lat ne 0) && (1*$lon ne 0) && (1*$year ne 0)) {
					$date = substr($dateEQ,0,8).$heure;
		print OUT "clust{$idcluster}{$idevent,13} = '$Xcorrloc3D' ;\nclust{$idcluster}{$idevent,14} = [$lon $lat $dep  $RE $RN $RZ  $AE $AN $AZ  $DE $DN $DZ  $RMS $sta $year $mont $da $hr $minut $seco 0 0] ; \n" ;
				} else {print OUT "clust{$idcluster}{$idevent,13} = '' ;\nclust{$idcluster}{$idevent,14}(1:22) = NaN ;\n";}
					
				my ($dateEQ, $heure,  $year, $mont, $da, $hr, $minut, $seco, $lat, $lon, $dep, $RE, $RN, $RZ, $AE, $AN, $AZ, $DE, $DN, $DZ, $RMS, $sta) = read_hyp($Enrichedloc3D);
				if ((1*$lat ne 0) && (1*$lon ne 0) && (1*$year ne 0)) {
					$date = substr($dateEQ,0,8).$heure;
		print OUT "clust{$idcluster}{$idevent,15} = '$Enrichedloc3D' ;\nclust{$idcluster}{$idevent,16} = [$lon $lat $dep  $RE $RN $RZ  $AE $AN $AZ  $DE $DN $DZ  $RMS $sta $year $mont $da $hr $minut $seco 0 0] ; \n" ;
				} else {print OUT "clust{$idcluster}{$idevent,15} = '' ;\nclust{$idcluster}{$idevent,16}(1:22) = NaN ;\n";}

		# PRINTING RELATIVE LOCATION STUFFS
				my $Enrichedreloc1D = $event.'/'.$eltevent[-1].'.inp.enriched.reloc.hypoDD.hypo71/hypoDD.reloc';
				my ($dateEQ, $heure,  $year, $mont, $da, $hr, $minut, $seco, $lat, $lon, $dep, $RE, $RN, $RZ, $RMS, $sta, $RMSCT,$staCT) = read_hypodd($Enrichedreloc1D);
				if ((1*$lat ne 0) && (1*$lon ne 0) && (1*$year ne 0)) {
					if($dateEQ > 19000000) {			#$date = substr($dateEQ,0,8).$heure;
		print OUT "clust{$idcluster}{$idevent,17} = '$Enrichedreloc1D' ;\nclust{$idcluster}{$idevent,18} = [$lon $lat $dep  $RE $RN $RZ  90 0 0  0 0 90  $RMS $sta $year $mont $da $hr $minut $seco $RMSCT $staCT] ; \n" ; 
					} else {print OUT "clust{$idcluster}{$idevent,17} = '' ;\nclust{$idcluster}{$idevent,18}(1:22) = NaN ;\n";}
				} else {print OUT "clust{$idcluster}{$idevent,17} = '' ;\nclust{$idcluster}{$idevent,18}(1:22) = NaN ;\n";}

				my $Enrichedreloc1D = $event.'/'.$eltevent[-1].'.inp.enriched.reloc.hypoDD.nlloc/hypoDD.reloc';
				my ($dateEQ, $heure,  $year, $mont, $da, $hr, $minut, $seco, $lat, $lon, $dep, $RE, $RN, $RZ, $RMS, $sta, $RMSCT,$staCT) = read_hypodd($Enrichedreloc1D);
				if ((1*$lat ne 0) && (1*$lon ne 0) && (1*$year ne 0)) {
					if($dateEQ > 19000000) {                        #$date = substr($dateEQ,0,8).$heure;
		print OUT "clust{$idcluster}{$idevent,19} = '$Enrichedreloc1D' ;\nclust{$idcluster}{$idevent,20} = [$lon $lat $dep  $RE $RN $RZ  90 0 0  0 0 90  $RMS $sta $year $mont $da $hr $minut $seco $RMSCT $staCT] ; \n" ;
					} else {print OUT "clust{$idcluster}{$idevent,19} = '' ;\nclust{$idcluster}{$idevent,20}(1:22) = NaN ;\n";}
				} else {print OUT "clust{$idcluster}{$idevent,19} = '' ;\nclust{$idcluster}{$idevent,20}(1:22) = NaN ;\n";}

				my $Enrichedreloc1D = $event.'/'.$eltevent[-1].'.inp.enriched.reloc.tomoDD.hypo71/tomoDD.reloc';
				my ($dateEQ, $heure,  $year, $mont, $da, $hr, $minut, $seco, $lat, $lon, $dep, $RE, $RN, $RZ, $RMS, $sta, $RMSCT,$staCT) = read_hypodd($Enrichedreloc1D);
				if ((1*$lat ne 0) && (1*$lon ne 0) && (1*$year ne 0)) {
					if($dateEQ > 19000000) {                        #$date = substr($dateEQ,0,8).$heure;
		print OUT "clust{$idcluster}{$idevent,21} = '$Enrichedreloc1D' ;\nclust{$idcluster}{$idevent,22} = [$lon $lat $dep  $RE $RN $RZ  90 0 0  0 0 90  $RMS $sta $year $mont $da $hr $minut $seco $RMSCT $staCT] ; \n" ;
					} else {print OUT "clust{$idcluster}{$idevent,21} = '' ;\nclust{$idcluster}{$idevent,22}(1:22) = NaN ;\n";}
				} else {print OUT "clust{$idcluster}{$idevent,21} = '' ;\nclust{$idcluster}{$idevent,22}(1:22) = NaN ;\n";}

				my $Enrichedreloc1D = $event.'/'.$eltevent[-1].'.inp.enriched.reloc.tomoDD.nlloc/tomoDD.reloc';
				my ($dateEQ, $heure,  $year, $mont, $da, $hr, $minut, $seco, $lat, $lon, $dep, $RE, $RN, $RZ, $RMS, $sta, $RMSCT,$staCT) = read_hypodd($Enrichedreloc1D);
				if ((1*$lat ne 0) && (1*$lon ne 0) && (1*$year ne 0)) {
					if($dateEQ > 19000000) {                        #$date = substr($dateEQ,0,8).$heure;
		print OUT "clust{$idcluster}{$idevent,23} = '$Enrichedreloc1D' ;\nclust{$idcluster}{$idevent,24} = [$lon $lat $dep  $RE $RN $RZ  90 0 0  0 0 90  $RMS $sta $year $mont $da $hr $minut $seco $RMSCT $staCT] ; \n" ;
					} else {print OUT "clust{$idcluster}{$idevent,23} = '' ;\nclust{$idcluster}{$idevent,24}(1:22) = NaN ;\n";}
				} else {print OUT "clust{$idcluster}{$idevent,23} = '' ;\nclust{$idcluster}{$idevent,24}(1:22) = NaN ;\n";}


		# PRINTING BEST HYPOCENTER DATE
				print OUT "clust{$idcluster}{$idevent,3} = datenum('$date','yyyymmddHHMMSS.FFF') ; \n" ;

		# PRINTING MAGNITUDE and Moment
		#  awk '$3==2011 && $4==3 && $5==19 && $8==23 && $9==43 && $10<15.70 && $10>5.70 {print $6 " <= " $0}' yell_nlloc_zmap_full_9311.cat 

				my $Y=substr($date,0,4); my $M=substr($date,4,2);my $D=substr($date,6,2);
				my @events = `awk '\$3==$Y && \$4==$M && \$5==$D {printf("%2d%2d%2d%2d%2d%5.2f\\n",\$3,\$4,\$5,\$8,\$9,\$10)}' $fileM`;
				my @magnitudes = `awk '\$3==$Y && \$4==$M && \$5==$D {print \$6 }' $fileM` ;

				$size = @events; 
				print OUT "clust{$idcluster}{$idevent,25} = NaN;\n";
				print OUT "clust{$idcluster}{$idevent,26} = NaN;\n";
				print "clust{$idcluster}{$idevent,25:26} = NaN NaN ;\n";
				for ($i=0; $i<$size; $i++) {
					chomp($events[$i]);chomp($magnitudes[$i]);
					#print "$events[$i] $magnitudes[$i]\n";
					my $test = substr($events[$i],2,12);
					my $ref = substr($date,2,12);
					my $diff = `./diffdate.pl "$ref" "$test"`;
					chomp($diff);
					if (abs($diff*1) < 5) {
						print OUT "clust{$idcluster}{$idevent,25} = $magnitudes[$i];\n";
						my $Mo=10**(1.1*$magnitudes[$i]+18.4) ; # [dyn.cm]
						print OUT "clust{$idcluster}{$idevent,26} = $Mo;\n";
						print "clust{$idcluster}{$idevent,25:26} = $magnitudes[$i] $Mo\n";
					} 
				}
		# FP
				my $fpfit = $paf."/source/fpfit/fpfit.sum" ; 
				if (-e $fpfit) { 
					print OUT "clust{$idcluster}{$idevent,27} = '$paf/source/fpfit/fpfit.pdf' ;\n";
					my @fp = `cat $fpfit `;
					$size = @fp;
					for ($i=0; $i<$size; $i++) {
						chomp($fp[$i]);
						my $strikdiprake = substr($fp[$i],83,3)." ".substr($fp[$i],86,3)." ".substr($fp[$i],89,3)." ".substr($fp[$i],94,5)." ".substr($fp[$i],99,5)." ".substr($fp[$i],104,5)." ".substr($fp[$i],109,5)." ".substr($fp[$i],114,5)." ".substr($fp[$i],119,5)." ".substr($fp[$i],124,5)." ".substr($fp[$i],129,5);
						$strikdiprake =~ s/ \*\*\* / NaN /g;
						print OUT "clust{$idcluster}{$idevent,28+$i} = [ $strikdiprake ] ;\n";
						print "clust{$idcluster}{$idevent,28+$i} = [ $strikdiprake ] ;\n";
					}
				}
			}
		}
	}
}

close(OUT) ; 

