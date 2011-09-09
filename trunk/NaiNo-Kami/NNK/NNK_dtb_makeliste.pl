#!/usr/bin/perl 
#             -w  affiche warning
# 0 : date lim | 1 : extention fichier | 2 : path des data | 3=>... : stations  
##########################################################################################################################
##########################################################################################################################
my $out = '' ;
my $item = '' ; 
my $irec = 0 ;
my $ista = 0 ;
my $icomp = 0 ;
my %lesrec ; 
my %lesstat ; 
my %lescomp ; 
 
open (OUT,">tmp10.txt");
open (OUT1,">tmp11.txt");
open (OUT2,">tmp12.txt");
open (OUT3,">tmp13.txt");
open (OUT4,">tmp14.txt"); 
open (OUT5,">tmp15.txt"); 
open (OUT6,">tmp16.txt");

	my @list = `ls -dl $ARGV[2]/events/???????????????? | grep drwxr` ;
	my $numb =  $#list + 1; 

	foreach $item (@list) {
		chomp($item) ;
		my @elt = split('/',$item) ;  
		my $direct = substr($elt[-1],0,14)*1 ; 
		my @elt = split(' ',$item) ; 
		my $paf = $elt[-1] ;
        
        
		if($direct > $ARGV[0]) {
            my @sublist = `ls $paf/???_?_$ARGV[1]`;
            
			foreach $subitem (@sublist) {
                chomp($subitem) ;
				my $file = $subitem; 

                my @subelt = split('/',$file);
				my $stat = substr($subelt[-1],0,3) ; 
				my $compo = substr($subelt[-1],4,1) ; 

				if(-e $file) { 
					print OUT "$file\n" ;
					
					if(exists $lesrec{$direct}) {} else {$lesrec{$direct} = ++$irec ; print OUT4 "$paf\n" ; }
					if(exists $lesstat{$stat}) {} else {$lesstat{$stat} = ++$ista ; print OUT5 "$stat\n" ;}
					if(exists $lescomp{$compo}) {} else {$lescomp{$compo} = ++$icomp ; print OUT6 "$compo\n" ; }
					
					print OUT1 "$lesrec{$direct}\n" ; 
					print OUT2 "$lesstat{$stat}\n" ;
					print OUT3 "$lescomp{$compo}\n" ;
					
				}
			}
		}
	}

close(OUT) ; 
close(OUT1) ; 
close(OUT2) ; 
close(OUT3) ;
close(OUT4) ;
close(OUT5) ;
close(OUT6) ;


