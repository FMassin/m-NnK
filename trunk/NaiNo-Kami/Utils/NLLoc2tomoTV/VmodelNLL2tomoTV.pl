#!/usr/bin/perl
use List::Util qw(sum);

my %Vit ;
my $cnt = 0 ;
my %X ;
my %Y ;
my %Z ;
open (MODEL, "<$ARGV[0]") || die "couldn't open the file !";
while ($line = <MODEL>) {
	chomp($line);
	my @elt = split(' ',$line);
	# -110.0459   43.5551   -56.0  -105.0    -4.0  -9.99
	$cnt = $cnt+1 ; 
	$Vit{$elt[0]}{$elt[1]}{$elt[2]} = $elt[5];
	#print "Vit($elt[0],$elt[1],$elt[2]) = $Vit{$elt[0]}{$elt[1]}{$elt[2]}\n" ; 
	$X{$elt[0]} = $elt[0];
	$Y{$elt[1]} = $elt[1];	
	$Z{$elt[2]} = $elt[2];
}
close(MODEL);

my $cnt=0;my $mem;my $HX=0;
foreach my $key  (sort  keys %X) {
	$cnt=$cnt+1;
	if($cnt gt 1) {$HX=$HX+($key-$mem);}
	$mem=$key;
}
$HX = $HX/($cnt-1);
my $NX = $cnt ; 

my $cnt=0;my $mem;my $HY=0;
foreach my $key  (sort  keys %Y) {
        $cnt=$cnt+1;
        if($cnt gt 1) {$HY=$HY+($key-$mem);}
        $mem=$key;
}
$HY = $HY/($cnt-1);
my $NY = $cnt ;

my $cnt=0;my $mem;my $HZ=0;
foreach my $key  (sort  keys %Z) {
        $cnt=$cnt+1;
        if($cnt gt 1) {$HZ=$HZ+($key-$mem);}
        $mem=$key;
}
$HZ = $HZ/($cnt-1);
my $NZ = $cnt ;
print "HX = $HX HY = $HY HZ = $HZ\n";
print "NX = $NX NY = $NY NZ = $NZ \n";

