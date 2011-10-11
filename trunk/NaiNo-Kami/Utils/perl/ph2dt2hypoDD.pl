#!/usr/bin/perl 
#             -w  affiche warning
##########################################################################################################################
# usage ./NNK2hypoDD.pl ##################################################################################################


#`mv dt.cc dt.cc.old`;
open (PRTS,"<$ARGV[0]") || print"WARNING: can't open constant definition file: 4dt.cc" ;
open (DTCC,">./4DDs/dt.cc.$ARGV[1]") || print"WARNING: can't open constant definition file: ./4DDs/dt.cc" ;

while(my $line = <PRTS>) {
	chomp($line) ;#fichier1 ID1 fichier2 ID2
	my($prt1,$ID1,$prt2,$ID2)  = split(" ",$line);
	print DTCC "\# $ID1 $ID2 0.0\n";

	if ((-e $prt1) && (-e $prt2)) {
		#print "$prt1\n";
		my $date1;my $heure1;      
		open (FILE,"<$prt1") || print"WARNING: can't open constant definition file: $prt1" ;
        	while(my $line = <FILE>) {
	                chomp($line) ;
                	if($line =~ /([\d\s]\d\d\d\d\d)\s*(\d{1,2})\s*(\d{1,2})\s*(\d{1,2}\.\d{1,2})/) {
        	                my $date = $1;
				if($1 < 100000) {$date=20000000+$1;}
	                        elsif($1 > 100000) {$date=19000000+$1;}
                        	$date1=substr($date,0,4)*370+substr($date,4,2)*31+substr($date,6,2);
                	        $heure1= ($2*60*60)+($3*60)+$4;
				#print "$prt1 $date $2:$3 $4 $date1 $heure1\n";
        	};}
	        close(FILE);

		my $date2;my $heure2;
                open (FILE,"<$prt2") || print"WARNING: can't open constant definition file: $prt2" ;
                while(my $line = <FILE>) {
                        chomp($line) ;
                        if($line =~ /([\d\s]\d\d\d\d\d)\s*(\d{1,2})\s*(\d{1,2})\s*(\d{1,2}\.\d{1,2})/) {
                                my $date = $1;
				if($1 < 700000) {$date=20000000+$1;}
                                elsif($1 > 700000) {$date=19000000+$1;}
                                $date2=substr($date,0,4)*370+substr($date,4,2)*31+substr($date,6,2);
                                $heure2= ($2*60*60)+($3*60)+$4;
				#print "$prt2 $date $2:$3 $4 $date2 $heure2\n";
                };}
                close(FILE);
		

		open (FILE,"<$prt1") || print"WARNING: can't open constant definition file: $prt1" ;
		while(my $line = <FILE>) {
			chomp($line) ;	
			if($line =~ /\s(\d*)\s*(\d{1,3}\.\d{1,2})/) {
				$line =~ s/ P / PX/;$line =~ s/ S / SX/;
				my @test=split(":",$line);
				@test = (split(" ",$test[0]) , split(" ",$test[1]));
if(length($test[5]) gt 2) {@test = ($test[0],$test[1],$test[2],$test[3],$test[4],substr($test[5],0,length($test[5])-2),substr($test[5],length($test[5])-2,2),$test[6],$test[7],$test[8],$test[9],$test[10],$test[11],$test[12],$test[13]) ; }
				
				if ((((substr($test[4],0,1) eq "P") || (substr($test[4],0,1) eq "S")) && (1*$test[7] > 0)) || ((substr($test[11],0,1) eq "S") && (1*$test[12] > 0))) {
					my $indW = 4 ; my $indsec = 7 ; my $wave = "P" ;
					if (substr($test[11],0,1) eq "S") { $indW = 11;$indsec = 12 ;$wave = "S";}
					if (substr($test[4],0,1) eq "S") { $indW = 4;$indsec = 7 ;$wave = "S";}
					my $w1 = 1-(substr($test[$indW],2,1)/4) ;my $ar1 = ($test[5]*60*60)+($test[6]*60)+($test[$indsec]);if($ar1 < $heure1) {$ar1=$ar1+(60*60*24);}
					my $pt1 = $ar1-$heure1;
#					print "prt1 $test[5] $test[6] $test[$indsec] \n";

				        open (FILE2,"<$prt2") || print"WARNING: can't open constant definition file: $prt2" ;
                                	while(my $line2 = <FILE2>) {
						chomp($line2) ;
			                        if($line2 =~ /\s(\d*)\s*(\d{1,3}\.\d{1,2})/) {
                        		        	$line2 =~ s/ P / PX/;$line2 =~ s/ S / SX/;
					                $line =~ s/ P\?/ PX/;$line =~ s/ S\?/ SX/;

                               				my @test2=split(":",$line2);
                                			@test2 = (split(" ",$test2[0]) , split(" ",$test2[1]));
							if(length($test2[5]) gt 2) {@test2 = ($test2[0],$test2[1],$test2[2],$test2[3],$test2[4],substr($test2[5],0,length($test2[5])-2),substr($test2[5],length($test2[5])-2,2),$test2[6],$test2[7],$test2[8],$test2[9],$test2[10],$test2[11],$test2[12]) ; }
                                
                                			if ((substr($test2[$indW],0,1) eq $wave) && (1*$test2[$indsec] > 0) && ($test[0] eq $test2[0])) {
                                        			my $w2 = 1-(substr($test2[$indW],2,1)/4) ;my $ar2 = ($test2[5]*60*60)+($test2[6]*60)+($test2[$indsec]);if($ar2 < $heure2) {$ar2=$ar2+(60*60*24);}
        	                                		my $pt2 = $ar2-$heure2;
#								print "prt2 : $test2[5] $test2[6] $test2[$indsec]\n";
								my $dpt = $pt1-$pt2 ;
								$dpt = substr($dpt,0,5);
								my $w = ($w1+$w2)/2;
								if(($dpt < 50) && ($dpt > -50)) {print DTCC "$test[0] $dpt $w $wave\n";}
	                                		}
						}
					}
					close(FILE2);
				}
			}	
		}
		close(FILE);
	}
}
close(PRTS);
close(DTCC);
#`rm $ARGV[0]`;

