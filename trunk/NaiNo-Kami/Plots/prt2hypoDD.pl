#!/usr/bin/perl
#             -w  affiche warning
##########################################################################################################################
# usage ./prt2hypoDD.pl "/data/fred/dot/clst-test/2008/05/05/*/events/*/*.inp" ###########################################

my $NLL = 0 ;
`ls $ARGV[0]> ID.txt`;
my $clust = 0;
my $memclust = "0" ;
my $ID = 0 ;
my @list="";
my @list3d="";

`mv event.dat event.dat.old`;
`mv phase.dat phase.dat.old`;

open (EVTS,">event.dat") ;
open (PHAS,">phase.dat") ;
open (LOCS,">loc.txt") ;
open (DTCC,">4dt.cc") ;

open (LOCS3D,">loc3d.txt") ;
open (EVTS3D,">event3d.dat") ;
open (PHAS3D,">phase3d.dat") ;
open (DTCC3D,">4dt3d.cc") ;

open (INPS,"<ID.txt") || print"WARNING: can't open constant definition file: ID.txt" ;

while(my $inp = <INPS>) {
    chomp($inp) ;#/data/fred/dot/clst-test/2008/05/05/20080505011500WY/events/20080505011500WY/080505011500.inp
    my @pathtest = split("/",$inp);
    $pathtest[@pathtest-1] ="";
    my $test="";my $flag=1;foreach (@pathtest) {$test=$test."/".$_;my $testls=`ls -dl $test`;if(substr($testls,0,1) ne "d") {$flag=0;};};
    
    if ($flag eq 1) {
        $ID = $ID + 1 ;
        my @elt = split("/",$inp);
        if($elt[-3] eq "events") {if($elt[-4] ne $memclust) {@list="";$clust = $clust + 1 ; $memclust = $elt[-4] ; } ; } ;
        
        my $prt = substr($inp,0,length($inp)-3)."prt";
        my $prt2 = substr($inp,0,length($inp)-7)."loc.h71";
#        print "$prt\n$prt2\n";
        my $date;my $heure;my $lat;my $lon;my $year;my $mont; my $da;my $mag=1;my $dep;my $hr;my $minut;my $seco;my $flagE="";my $flagN="";my $flagprint=0;my $RH=0;my $RZ=0;my $RMS=0;
        if (-e $prt) {
            @list = (@list,$prt." ".$ID);
            open (FILE,"<$prt") || print"WARNING: can't open constant definition file: $prt" ;
            while(my $line = <FILE>) {
                chomp($line) ;
                my @test=split(":",$line);
                @test = (split(" ",$test[0]) , split(" ",$test[1]));
                if($test[0] eq "RMS") {$RMS = $test[1] ; }
                if(($test[0] eq "Altitude") || ($test[0] eq "Profondeur"))   { $dep = -1*$test[3] ; $RZ = $test[-2];}
                if($test[0]  eq "Latitude") {$lat = $test[1]+($test[2]/60) ;	$RH = $RH+$test[9]/2 ;
                if($test[3] eq "S") { $flagN = "-"; }}
                if($test[0] eq "Longitude") {$lon = $test[1]+($test[2]/60) ;	$RH = $RH+$test[9]/2 ;
                if($test[3] eq "W") { $flagE = "-"; }}
                if($line =~ /([\d\s]\d\d\d\d\d)\s*(\d{1,2})\s*(\d{1,2})\s*(\d{1,2}\.\d{1,2})/) {
                    $year = $1 ;
                    if($year < 100000) {$year=20000000+$year;}
                    elsif($year > 100000) {$year=19000000+$year;}
                    $date=$year;$da=1*substr($year,6,2);$mont=1*substr($year,4,2);$year=1*substr($year,0,4);
                    $hr=$2;$minut=$3;$seco=$4;$heure= ($hr*10000)+($minut*100)+$seco;
                }
                my $test2 = substr($line,0,10) ;
                if($test2 =~ /\s(\d*)\s*(\d{1,3}\.\d{1,2})/) {
                    $line =~ s/ P / PX/;$line =~ s/ S / SX/;
                    my @test=split(":",$line);
                    @test = (split(" ",$test[0]) , split(" ",$test[1]));
                    if(length($test[5]) gt 2) {@test = ($test[0],$test[1],$test[2],$test[3],$test[4],substr($test[5],0,length($test[5])-2),substr($test[5],length($test[5])-2,2),$test[6],$test[7],$test[8],$test[9],$test[10]) ; }
                    if($flagprint == 0) {
                        $lon = $flagE.substr((substr($lon,0,9)+1000.00001),1,8) ;
                        $lat = $flagN.substr((substr($lat,0,9)+1000.00001),2,7) ;
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
                    if((substr($test[9],0,1) eq "S") && (1*$test[10] > 0)) {
                        my $w = 1-(substr($test[9],2,1)/4) ;
                        my $pt = ($da*60*60*24)+($hr*60*60)+($minut*60)+($seco);
                        my $ar = ($da*60*60*24)+($test[5]*60*60)+($test[6]*60)+($test[10]);
                        if($ar+(60*60) < $pt) {$ar=$ar+(60*60*24);}
                        $pt = $ar-$pt;
                        $pt = substr($pt,0,5);
                        if($pt < 50) {print PHAS "$test[0] $pt $w S\n";}
                        if($pt >= 50) {print "warning in $prt : $test[0] $pt S ($da)+($test[5])+($test[6])+($test[10]) - ($da)+($hr)+($minut)+($seco)\n";}
                    }
                }
            }
            close(FILE);
        }
        my $date;my $heure;my $lat;my $lon;my $year;my $mont; my $da;my $mag=1;my $dep;my $hr;my $minut;my $seco;my $flagE="";my $flagN="";my $flagprint=0;my $RH=0;my $RZ=0;my $RMS=0;
        if (-e $prt2) {
            @list3d = (@list3d,$prt2." ".$ID);
            open (FILE,"<$prt2") || print"WARNING: can't open constant definition file: $prt2" ;
            while(my $line = <FILE>) {
                chomp($line) ;
                my $test = substr($line,0,8);
                if($test =~ /\s*\d{6,7}/) {
                    #                                                                                     ADJ
                    #  DATE    ORIGIN    LAT     LONG          DEPTH  MAG  NO DM GAP M RMS   ERH  ERZ Q SQD IN   NR  AVR    AAR  NM AVXM SDXM NF AVFM SDFM I
                    # 1100805 0512 57.80 43 35.92-110 -32.12   6.54   0.00 10  6 211 0 0.26  2.0  2.5 D C D 0.00  0  0-0.00 0.00  0  0.0  0.0  0  0.0  0.0 0
                    #0123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 1234
                    #          10        20        30        40        50        60        70        80        90        100       110       120       130
                    $line =~ s/ /0/;
                    $date = substr($line,2,6);
                    if($date*1 < 700000) {$date=20000000+$date;}
                    elsif($date*1 > 700000) {$date=19000000+$date;}
                    $heure = substr($line,9,4).substr($line,14,5);
                    $lat = substr($line,19,3)+substr($line,23,5)/60;
                    $lon = substr($line,28,4)+substr($line,33,5)/60;
                    $dep = substr($line,40,5);
                    $mag = substr($line,49,4);
                    $RH  = substr($line,71,4);
                    $RZ  = substr($line,76,4);
                    $RMS = substr($line,66,4);
                    $year = substr($date,0,4) ;
                    $mont = substr($date,4,2) ;
                    $da = substr($date,6,2) ;
                    $hr = substr($heure,0,2) ;
                    $minut = substr($heure,2,2) ;
                    $seco = substr($heure,4,5) ;
                    
                    print LOCS3D "$clust $ID $lon  $lat $dep $mag $year $mont $da $hr $minut $seco\n";
                    print EVTS3D "$date   $heure   $lat   $lon   $dep   $mag   $RH   $RZ   $RMS   $ID\n";
                    print PHAS3D "# $year $mont $da $hr $minut $seco $lat $lon $dep $mag $RH $RZ $RMS $ID\n";
                }
                $line =~ s/ P / PX/;$line =~ s/ S / SX/;
                my @test=split(":",$line);
                @test = (split(" ",$test[0]) , split(" ",$test[1]));
                if(length($test[5]) gt 2) {@test = ($test[0],$test[1],$test[2],$test[3],$test[4],substr($test[5],0,length($test[5])-2),substr($test[5],length($test[5])-2,2),$test[6],$test[7],$test[8],$test[9],$test[10]) ; }
                if((substr($test[4],0,1) eq "P") && (1*$test[7] > 0)) {
                    my $w = 1-(substr($test[4],2,1)/4) ;
                    my $pt = ($da*60*60*24)+($hr*60*60)+($minut*60)+($seco);
                    my $ar = ($da*60*60*24)+($test[5]*60*60)+($test[6]*60)+($test[7]);
                    if($ar < $pt) {$ar=$ar+(60*60*24);}
                    $pt = $ar-$pt;
                    $pt = substr($pt,0,5);
                    if($pt < 50) {print PHAS3D "$test[0] $pt $w P\n";}
                    if($pt >= 50) {
                        print "warning in $prt2 : $test[0] $pt P ($da)+($test[5])+($test[6])+($test[7]) - ($da)+($hr)+($minut)+($seco)\n";}
                }
                if((substr($test[9],0,1) eq "S") && (1*$test[10] > 0)) {
                    my $w = 1-(substr($test[9],2,1)/4) ;
                    my $pt = ($da*60*60*24)+($hr*60*60)+($minut*60)+($seco);
                    my $ar = ($da*60*60*24)+($test[5]*60*60)+($test[6]*60)+($test[10]);
                    if($ar+(60*60) < $pt) {$ar=$ar+(60*60*24);}
                    $pt = $ar-$pt;
                    $pt = substr($pt,0,5);
                    if($pt < 50) {print PHAS3D "$test[0] $pt $w S\n";}
                    if($pt >= 50) {
                        print "warning in $prt2 : $test[0] $pt S ($da)+($test[5])+($test[6])+($test[10]) - ($da)+($hr)+($minut)+($seco)\n";}
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
    }
}
close(INPS);
close(LOCS);
close(EVTS);
close(PHAS);
close(DTCC);
close(LOCS3D);
close(EVTS3D);
close(PHAS3D);
close(DTCC3D);
`./NNK2hypoDD.pl`;
