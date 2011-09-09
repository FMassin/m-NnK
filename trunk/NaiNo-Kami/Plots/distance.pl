#!/usr/bin/perl 
use Math::Trig qw(great_circle_distance deg2rad);

my @km ; 
# Notice the 90 - latitude: phi zero is at the North Pole.
sub NESW { deg2rad($_[0]), deg2rad(90 - $_[1])}
my @L = NESW( $ARGV[0], $ARGV[1]);
my @T = NESW($ARGV[2], $ARGV[3]);
$km[0] = great_circle_distance(@L, @T, 6378); # About 9600 km.

my $sign = "";
my $testX= $ARGV[2]-$ARGV[0];
my $testY= $ARGV[3]-$ARGV[1];
if(($testY <= 0) & ($testX <= 0)) {$sign="-" }

print "$sign$km[0]" ;  
