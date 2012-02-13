#!/usr/bin/perl
#             -w  affiche warning
##########################################################################################################################
# usage ./prt2ph2dt.pl "../tmp" "/data/fred/dot/clst-test/2008/05/05/*/events/*/*.inp" ###########################################

my $NLL = 0 ;
if (@ARGV < 0) { $ARGV[0] = "../tmp";};
`mkdir -p $ARGV[0]/4DDs`;
if (@ARGV > 1) {`ls $ARGV[1]> $ARGV[0]/4DDs/ID.txt`;};
my $clust = 0;
my $memclust = "0" ;
my $ID = 0 ;
my @list="";
my @list3d="";
my $flagnewclust = 0;

open (EVTS,">$ARGV[0]/4DDs/event.dat.hypo71") ;
open (PHAS,">$ARGV[0]/4DDs/phase.dat.hypo71") ;
open (LOCS,">$ARGV[0]/4DDs/loc.txt.hypo71") ;

open (LOCS3D,">$ARGV[0]/4DDs/loc.txt.nlloc") ;
open (EVTS3D,">$ARGV[0]/4DDs/event.dat.nlloc") ;
open (PHAS3D,">$ARGV[0]/4DDs/phase.dat.nlloc") ;
open (PHAS3D2,">$ARGV[0]/4DDs/phase.dat.nlloc.tomoDD") ;

open (DTCC,">$ARGV[0]/4DDs/4dt.cc.hypo71") ;
open (DTCC3D,">$ARGV[0]/4DDs/4dt.cc.nlloc") ;

open (INPS,"<$ARGV[0]/4DDs/ID.txt") || print"WARNING: can't open constant definition file: $ARGV[0]/ID.txt" ;

while(my $inp = <INPS>) {
    chomp($inp) ;#/data/fred/dot/clst-test/2008/05/05/20080505011500WY/events/20080505011500WY/080505011500.inp
    my @pathtest = split("/",$inp);
    $pathtest[@pathtest-1] ="";
    my $test="";my $flag=1;
    foreach (@pathtest) {
	$test=$test."/".$_;	
	my $testls=`ls -dl $test`;
	#print "$testls\n";
	if(substr($testls,0,1) ne "d") {$flag=0;};
	};
    #print "$inp $flag\n";

    if ($flag eq 1) {
        $ID = $ID + 1 ;
        my @elt = split("/",$inp);
	$flagnewclust = 0;
        if($elt[-3] eq "events") {
		if($elt[-4] ne $memclust) {
			#@list="";
			$flagnewclust = 1 ; $clust = $clust + 1 ; $memclust = $elt[-4] ; 
		        foreach (@list) {
            			my @elt=split(" ",$_);
            			if (-e $elt[0]) {
			                my $prt = $_ ;
					foreach (@list) {
				   		my @elt=split(" ",$_);
				   		if ((-e $elt[0]) && ($prt ne $_)) {
							print DTCC "$prt $_ \n";
				    	};};};}
			foreach (@list3d) {
			    	my @elt=split(" ",$_);
			    	if (-e $elt[0]) {
					my $prt = $_ ;
					foreach (@list3d) {
				    		my @elt=split(" ",$_);
				    		if ((-e $elt[0]) && ($prt ne $_)) {
							print DTCC3D "$prt $_ \n";
				    };};};}

			@list="";
			@list3d="";
		} ; 
	} ;
        
        my $prt = $inp.".loc.hypo71/zl.h";
        my $prt2 = `ls $inp.loc.nlloc/*.loc.h71`;
	chomp($prt2);
	print "taking $prt\n   and $prt2\n";

        my $date;my $heure;my $lat;my $lon;my $year;my $mont; my $da;my $mag=1;my $dep;my $hr;my $minut;my $seco;my $flagE="";my $flagN="";my $flagprint=0;my $RH=0;my $RZ=0;my $RMS=0;
        if (-e $prt) {
            open (FILE,"<$prt") || print"WARNING: can't open constant definition file: $prt" ;
            while(my $line = <FILE>) {
                chomp($line) ;
                my @test=split(":",$line);
                @test = (split(" ",$test[0]) , split(" ",$test[1]));
                if($test[0] eq "RMS") {$RMS = $test[1] ; }
                if(($test[0] eq "Altitude") || ($test[0] eq "Profondeur"))   { $dep = $test[3] ; $RZ = $test[-2];}
                if($test[0]  eq "Latitude") {$lat = $test[1]+($test[2]/60) ;	$RH = $RH+$test[9]/2 ;
                if($test[3] eq "S") { $flagN = "-"; }}
                if($test[0] eq "Longitude") {$lon = $test[1]+($test[2]/60) ;	$RH = $RH+$test[9]/2 ;
                if($test[3] eq "W") { $flagE = "-"; }}
                if($line =~ /([\d\s][\d\s][\d\s]\d\d\d)\s*(\d{1,2})\s*(\d{1,2})\s*(\d{1,2}\.\d{1,2})\s*Nb/) {
                    $year = $1 ;
                    if($year < 700000) {$year=20000000+$year;}
                    elsif($year > 700000) {$year=19000000+$year;}
                    $date=$year;$da=1*substr($year,6,2);$mont=1*substr($year,4,2);$year=1*substr($year,0,4);
                    $hr=substr(100+$2,1,2);
		    $minut=substr(100+$3,1,2);
		    $seco=substr(100.001+$4,1,5);
		    $heure= ($2*10000)+($3*100)+$4;
			#print "$line \n date : $1 heure:$2 min:$3 seco:$4\n";
                }
                my $test2 = substr($line,0,10) ;
                if(($test2 =~ /\s(\d*)\s*(\d{1,3}\.\d{1,2})/) && (abs($lat) > 0) && (abs($date) > 19700000)) {
                    $line =~ s/ P / PX/;$line =~ s/ S / SX/;
                    my @test=split(":",$line);
                    @test = (split(" ",$test[0]) , split(" ",$test[1]));
                    if(length($test[5]) gt 2) {@test = ($test[0],$test[1],$test[2],$test[3],$test[4],substr($test[5],0,length($test[5])-2),substr($test[5],length($test[5])-2,2),$test[6],$test[7],$test[8],$test[9],$test[10],$test[11],$test[12],$test[13],$test[14]) ; }
                    if($flagprint == 0) {
                        $lon = $flagE.substr((substr($lon,0,9)+1000.00001),1,8) ;
                        $lat = $flagN.substr((substr($lat,0,9)+1000.00001),2,7) ;
            		@list = (@list,$prt." ".$ID);
                        print LOCS "$clust $ID $lon  $lat $dep $mag $year $mont $da $hr $minut $seco\n";
                        print EVTS "$date   $heure   $lat   $lon   $dep   $mag   $RH   $RZ   $RMS   $ID\n";
                        print PHAS "# $year $mont $da $hr $minut $seco $lat $lon $dep $mag $RH $RZ $RMS $ID\n";
                        $flagprint = 1;
                    }
                    if((substr($test[4],0,1) eq "P") && (1*$test[7] > 0)) {
                        my $w = 1-(substr($test[4],2,1)/4) ;
                        my $pt = ($da*60*60*24)+($hr*60*60)+($minut*60)+($seco);
                        my $ar = ($da*60*60*24)+($test[5]*60*60)+($test[6]*60)+($test[7]);
                        if($ar < $pt) {$ar=$ar+(60*60*24);}
                        $pt = $ar-$pt;
                        $pt = substr($pt,0,5);
                        if($pt < 50) {print PHAS "$test[0] $pt $w P\n";}
                        if($pt >= 50) {print "warning in $prt : $test[0] $pt P ($da)+($test[5])+($test[6])+($test[7]) - ($da)+($hr)+($minut)+($seco)\n";}
                    }
                    if((substr($test[11],0,1) eq "S") && (1*$test[12] > 0)) {
                        my $w = 1-(substr($test[11],2,1)/4) ;
                        my $pt = ($da*60*60*24)+($hr*60*60)+($minut*60)+($seco);
                        my $ar = ($da*60*60*24)+($test[5]*60*60)+($test[6]*60)+($test[12]);
                        if($ar+(60*60) < $pt) {$ar=$ar+(60*60*24);}
                        $pt = $ar-$pt;
                        $pt = substr($pt,0,5);
			#print "printed 1D : $test[0] $pt $w S\n";
                        if($pt < 50) {print PHAS "$test[0] $pt $w S\n";}
                        if($pt >= 50) {print "warning in $prt : $test[0] $pt S ($da)+($test[5])+($test[6])+($test[10]) - ($da)+($hr)+($minut)+($seco)\n";}
                    }
                }
            }
            close(FILE);
        }
        my $date;my $heure;my $lat;my $lon;my $year;my $mont; my $da;my $mag=1;my $dep;my $hr;my $minut;my $seco;my $flagE="";my $flagN="";my $flagprint=0;my $RH=0;my $RZ=0;my $RMS=0;
#        print "$prt2\n";
	if (-e $prt2) {
            open (FILE,"<$prt2") || print"WARNING: can't open constant definition file: $prt2" ;
            while(my $line = <FILE>) {
                chomp($line) ;
                my $test = substr($line,0,8);
                if($test =~ /\s*\d{6,7}/) {
                    #                                                                                     ADJ
                    #  DATE    ORIGIN    LAT     LONG          DEPTH  MAG  NO DM GAP M RMS   ERH  ERZ Q SQD IN   NR  AVR    AAR  NM AVXM SDXM NF AVFM SDFM I
		    # 021109 0207 54.32 43 52.65-110 -20.22  -3.42   0.00 10 85 338 0999.99 -nan -nan E D D 0.00  0  0-0.00 0.00  0  0.0  0.0  0  0.0  0.0 0
                    #                                                                 9.99  9.9  9.9 
                    # 021027 0313 16.64 43 43.09-110 -20.29   3.47   0.00  7113 347 0999.992987.8 45.3 E D D 0.00  0  0-0.00 0.00  0  0.0  0.0  0  0.0  0.0 0
		    # 110805 0512 57.80 43 35.92-110 -32.12   6.54   0.00 10  6 211 0 0.26  2.0  2.5 D C D 0.00  0  0-0.00 0.00  0  0.0  0.0  0  0.0  0.0 0
                    # 931103 0945 23.12 44 44.39-111 -0.06    5.43   0.00  6  2 128 0 0.12  1.5  3.0 C B B 0.00  0  0-0.00 0.00  0  0.0  0.0  0  0.0  0.0 0
                    #0123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 
                    #          10        20        30        40        50        60        70        80        90        100       110       120       130
                    $line =~ s/ /0/;
                    $date = substr($line,1,6);
                    if($date*1 < 700000) {$date=20000000+$date;}
                    elsif($date*1 > 700000) {$date=19000000+$date;}
                    $heure = substr($line,8,4).substr($line,13,2).substr($line,16,2);
		    $heure =~ s/ /0/g;
                    $lat = substr($line,18,3)+substr(substr($line,22,5)/60,0,6);
                    $lon = substr($line,27,4)+substr(substr($line,32,5)/60,0,6);
		    if(substr($line,33,5) < 10 ) {$line =~ s/ /  /;};
                    $dep = substr($line,40,5);
                    $mag = substr($line,48,4);
		    $line =~ s/999.99 -nan -nan / 9.99  9.9  9.9 /;
		    $line =~ s/999.99/ 9.99 /;
                    $RH  = substr($line,70,4);
                    $RZ  = substr($line,75,4);
                    $RMS = substr($line,65,4);
                    $year = substr($date,0,4) ;
                    $mont = substr($date,4,2) ;
                    $da = substr($date,6,2) ;
                    $hr = substr($heure,0,2) ;
                    $minut = substr($heure,2,2) ;
                    $seco = substr($heure,4,2)+(substr($heure,6,2)/100) ;
                   
		    #print " $line \n $date $heure $hr $minut $seco \n" ;  
		    if (($RMS lt 1)  && (abs($lat) > 0) && (abs($date) > 19700000)) {
            		@list3d = (@list3d,$prt2." ".$ID);
                    	print LOCS3D "$clust $ID $lon  $lat $dep $mag $year $mont $da $hr $minut $seco\n";
                   	print EVTS3D "$date  $heure $lat $lon $dep $mag $RH $RZ $RMS $ID 0\n";
                   	print PHAS3D "# $year $mont $da $hr $minut $seco $lat $lon $dep $mag $RH $RZ $RMS $ID\n";
			print PHAS3D2 "# $ID\n";
                	}
		}
                $line =~ s/ P / PX/;$line =~ s/ S / SX/;
                $line =~ s/ P\?/ PX/;$line =~ s/ S\?/ SX/;
		my @test=split(":",$line);
                @test = (split(" ",$test[0]) , split(" ",$test[1]));
                if(length($test[5]) gt 2) {@test = ($test[0],$test[1],$test[2],$test[3],$test[4],substr($test[5],0,length($test[5])-2),substr($test[5],length($test[5])-2,2),$test[6],$test[7],$test[8],$test[9],$test[10]) ; }
		if((substr($test[4],0,1) eq "P") && (1*$test[7] > 0) && ($RMS lt 1)  && (abs($lat) > 0) && (abs($date) > 19700000)) {
                    my $w = 1-(substr($test[4],2,1)/4) ;
                    my $pt = ($da*60*60*24)+($hr*60*60)+($minut*60)+($seco);
                    my $ar = ($da*60*60*24)+($test[5]*60*60)+($test[6]*60)+($test[7]);
                    if($ar < $pt) {$ar=$ar+(60*60*24);}
                    $pt = $ar-$pt;
                    $pt = substr($pt,0,5);
                    if($pt < 50) {print PHAS3D "$test[0] $pt $w P\n";    print PHAS3D2 "$test[0] $pt $w P\n"; }
                    if($pt >= 50) {
                        print "warning in $prt2 : $test[0] $pt P ($da)+($test[5])+($test[6])+($test[7]) - ($da)+($hr)+($minut)+($seco)\n";}
                }
		
                if((substr($test[4],0,1) eq "S") && (1*$test[7] > 0) && ($RMS lt 1)  && (abs($lat) > 0) && (abs($date) > 19700000)) {
                    my $w = 1-(substr($test[4],2,1)/4) ;
                    my $pt = ($da*60*60*24)+($hr*60*60)+($minut*60)+($seco);
                    my $ar = ($da*60*60*24)+($test[5]*60*60)+($test[6]*60)+($test[7]);
                    if($ar+(60*60) < $pt) {$ar=$ar+(60*60*24);}
                    $pt = $ar-$pt;
                    $pt = substr($pt,0,5);
		    #print "printed 3D : $test[0] $pt $w S\n";
                    if($pt < 50) {print PHAS3D "$test[0] $pt $w S\n";    print PHAS3D2 "$test[0] $pt $w S\n"; }
                    if($pt >= 50) {
                        print "warning in $prt2 : $test[0] $pt S ($da)+($test[5])+($test[6])+($test[10]) - ($da)+($hr)+($minut)+($seco)\n";}
                }
            }
	    close(FILE);
        }
    }
}
foreach (@list) {
	my @elt=split(" ",$_);
	if (-e $elt[0]) {
		my $prt = $_ ;
		foreach (@list) {
		my @elt=split(" ",$_);
		if ((-e $elt[0]) && ($prt ne $_)) {
			print DTCC "$prt $_ \n";
		};};};}
foreach (@list3d) {
    my @elt=split(" ",$_);
    if (-e $elt[0]) {
	my $prt = $_ ;
	foreach (@list3d) {
	    my @elt=split(" ",$_);
	    if ((-e $elt[0]) && ($prt ne $_)) {
		print DTCC3D "$prt $_ \n";
	    };};};}

close(INPS);
close(LOCS);
close(EVTS);
close(PHAS);
close(DTCC);
close(LOCS3D);
close(EVTS3D);
close(PHAS3D);
close(DTCC3D);
close(PHAS3D2);
system("./ph2dt2hypoDD.pl $ARGV[0]/4DDs/4dt.cc.hypo71 hypo71 $ARGV[0]/4DDs");
system("./ph2dt2hypoDD.pl $ARGV[0]/4DDs/4dt.cc.nlloc nlloc $ARGV[0]/4DDs ");
