#!/usr/bin/perl 
#             -w  affiche warning
# usage ./pickstat.p ../NNK/uuss2NNK.pl /data/4Fred/WF/WY/dtec/2009/01/??/????????????????/???????????p
##########################################################################################################################
##########################################################################################################################

my @labels = ("P","S","C");
my $max = 3 ; 
my $path = $ARGV[0];#'/home/fred/Documents/scripts/NaiNoKami/NaiNoKami_2/NNK/uuss2NNK.pl'
my $pathdata = $ARGV[1];#/data/4Fred/WF/WY/dtec/2009/01/??/????????????????/???????????p

print "ls $pathdata > tmp.txt \n" ; 
`ls $pathdata > tmp.txt` ;

my %lesnumsdepickperstatNNK ; 
my %lesdatedepickperstat;

open (LINES,"<tmp.txt") || print"WARNING: can't open constant definition file: tmp.txt" ;
while(my $file = <LINES>) {
	print "$file";
	chomp($file) ; 
	print "$path $file all all > tmp0.txt";
	`$path $file all all > tmp0.txt` ;		
	open (PICKS,"<tmp0.txt") || print"WARNING: can't open constant definition file: tmp0.txt" ;
	while(my $pick = <PICKS>) {
		chomp($pick) ;
		my @elt = split(' ',$pick) ;
		#PC 090101011100 080.75 S  090101011100 000.00 C  090101011100 092.00 E  090101011100 130.75 YLA YLA
		#0  3            16                     38                     59                     100
		#print "\n$pick\n";

		for ($i = 0; $i < $max; ++$i) {
			my $ind = 16+(23*$i) ; 
			my $test = substr($pick,$ind,6) ; 
			#print "$test ";		
			if($test gt 0) {
				$lesnumsdepickperstatNNK{$elt[-2]}{$labels[$i]} = $lesnumsdepickperstatNNK{$elt[-2]}{$labels[$i]} +1 ; 
				$lesdatedepickperstat{$elt[-2]}{$labels[$i]}{$elt[1]} = $elt[1].' '.$testP;
			} 
		}
        }
        close(PICKS) ;
}
close(LINES) ;
`rm tmp0.txt`;

open (OUT2,">hist_stat_NNK.txt"); 
foreach my $k1 (sort keys %lesnumsdepickperstatNNK) { 
	print OUT2 "$k1 ";
	for ($i = 0; $i < $max; ++$i) {
		print OUT2 "0$lesnumsdepickperstatNNK{$k1}{$labels[$i]} ";
	}
	print OUT2 "\n" ;
} 
close(OUT2) ;


foreach my $k1 (sort  keys %lesdatedepickperstat) {
	for ($i = 0; $i < $max; ++$i) {

		open (OUT1,">../tmp/pick.$k1.$labels[$i].txt");
		foreach my $k3 (sort  keys %{$lesdatedepickperstat{$k1}{$labels[$i]}}) { 
			print OUT1 "$lesdatedepickperstat{$k1}{$labels[$i]}{$k3}\n" ;
		}
		close(OUT1);
	}
} 

#my @disp = `more hist_stat_init.txt ` ; print "tmp1.txt\n@disp\n" ; 
#my @disp = `more hist_stat_NNK.txt` ; print "tmp2.txt\n@disp\n" ;
 
