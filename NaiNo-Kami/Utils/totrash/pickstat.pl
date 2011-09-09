#!/usr/bin/perl 
#             -w  affiche warning
# usage ./pickstat.p ../NNK/uuss2NNK.pl /data/4Fred/WF/WY/dtec/2009/01/??/????????????????/???????????p
##########################################################################################################################
##########################################################################################################################


my $path = $ARGV[0];#'/home/fred/Documents/scripts/NaiNoKami/NaiNoKami_2/NNK/uuss2NNK.pl'
my $pathdata = $ARGV[1];#/data/4Fred/WF/WY/dtec/2009/01/??/????????????????/???????????p

print "ls $pathdata > tmp.txt \n" ; 
`ls $pathdata > tmp.txt` ;

my %lesnumsdepickperstatNNK ; 
my %lesnumsdepickperstatinit ;
my %lesnumsdepickperstatNNKS ;
my %lesnumsdepickperstatinitS ;
my %lesnumsdepickperstatNNKC ;
my %lesnumsdepickperstatinitC ;

open (LINES,"<tmp.txt") || print"WARNING: can't open constant definition file: tmp.txt" ;
while(my $file = <LINES>) {
	print "$file";
	chomp($file) ; 
	`$path $file all P > tmp0.txt` ;		
	open (PICKS,"<tmp0.txt") || print"WARNING: can't open constant definition file: tmp0.txt" ;
	while(my $pick = <PICKS>) {
		chomp($pick) ;
		my @elt = split(' ',$pick) ;
		if substr($elt[-2])
		if(exists $lesnumsdepickperstatNNK{$elt[3]}) {	
			$lesnumsdepickperstatNNK{$elt[-2]} = $lesnumsdepickperstatNNK{$elt[-2]} +1 ; 
		} else {
			$lesnumsdepickperstatNNK{$elt[2]} = 1 ; 
		}
		if(exists $lesnumsdepickperstatinit{$elt[3]}) {  
                        $lesnumsdepickperstatinit{$elt[3]} = $lesnumsdepickperstatinit{$elt[3]} +1 ;  
                } else {
                        $lesnumsdepickperstatinit{$elt[3]} = 1 ; 
                }

	}
	close(PICKS) ;
	`$path $file all S > tmp0.txt` ;
        open (PICKS,"<tmp0.txt") || print"WARNING: can't open constant definition file: tmp0.txt" ;
        while(my $pick = <PICKS>) {
                chomp($pick) ;
                my @elt = split(' ',$pick) ;
                if(exists $lesnumsdepickperstatNNKS{$elt[2]}) {
                        $lesnumsdepickperstatNNKS{$elt[2]} = $lesnumsdepickperstatNNKS{$elt[2]} +1 ;
                } else {
                        $lesnumsdepickperstatNNKS{$elt[2]} = 1 ;
                }
                if(exists $lesnumsdepickperstatinitS{$elt[3]}) {
                        $lesnumsdepickperstatinitS{$elt[3]} = $lesnumsdepickperstatinitS{$elt[3]} +1 ;
                } else {
                        $lesnumsdepickperstatinitS{$elt[3]} = 1 ;
                }

        }
        close(PICKS) ;
	`$path $file all C > tmp0.txt` ;
        open (PICKS,"<tmp0.txt") || print"WARNING: can't open constant definition file: tmp0.txt" ;
        while(my $pick = <PICKS>) {
                chomp($pick) ;
                my @elt = split(' ',$pick) ;
                if(exists $lesnumsdepickperstatNNKC{$elt[2]}) {
                        $lesnumsdepickperstatNNKC{$elt[2]} = $lesnumsdepickperstatNNKC{$elt[2]} +1 ;
                } else {
                        $lesnumsdepickperstatNNKC{$elt[2]} = 1 ;
                }
                if(exists $lesnumsdepickperstatinitC{$elt[3]}) {
                        $lesnumsdepickperstatinitC{$elt[3]} = $lesnumsdepickperstatinitC{$elt[3]} +1 ;
                } else {
                        $lesnumsdepickperstatinitC{$elt[3]} = 1 ;
                }

        }
        close(PICKS) ;

 
}
close(LINES) ;
open (OUT1,">tmp1.txt"); foreach my $k (keys(%lesnumsdepickperstatinit)) { print OUT1 "$k 0$lesnumsdepickperstatinit{$k} 0$lesnumsdepickperstatinitS{$k} 0$lesnumsdepickperstatinitC{$k}\n" ;} close(OUT1) ;
open (OUT2,">tmp2.txt"); foreach my $k (keys(%lesnumsdepickperstatNNK)) { print OUT2 "$k 0$lesnumsdepickperstatNNK{$k} 0$lesnumsdepickperstatNNKS{$k} 0$lesnumsdepickperstatNNKC{$k}\n" ;} close(OUT2) ;
#open (OUT6,">tmp6.txt"); foreach my $k (keys(%lescomp)) { print OUT6 "$k\n" ;} close(OUT6) ;
my @disp = `more tmp1.txt` ; print "tmp1.txt\n@disp\n" ; 
my @disp = `more tmp2.txt` ; print "tmp2.txt\n@disp\n" ;
 
