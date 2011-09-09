#!/usr/bin/perl 
#             -w  affiche warning 
##########################################################################################################################
##########################################################################################################################
my $sources = $ARGV[0] ; 
my $path = $ARGV[1] ;
my $numbcluster = 0;
my $numbevents = 0;

open (OUT1,">".$path."tmp7.txt");

my @list = `ls -dl $sources/????/??/??/???????????????? | grep drwxr` ;
$numbcluster =  $#list + 1;

foreach $item(@list) {
    chomp($item) ;
    my @elt = split(' ', $item) ;
    my $paf = $elt[-1] ;    
    print OUT1 "$paf\n" ;
}

close(OUT1) ; 