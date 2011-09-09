#!/usr/bin/perl 
use Math::Trig qw(great_circle_distance great_circle_destination deg2rad rad2deg);

$kmperdegY = great_circle_distance(deg2rad($ARGV[0]),deg2rad(90 - $ARGV[1]),deg2rad($ARGV[0]+1),deg2rad(90 - ($ARGV[1])), 6378) ;
$kmperdegX = great_circle_distance(deg2rad($ARGV[0]),deg2rad(90 - $ARGV[1]),deg2rad($ARGV[0]),deg2rad(90 - ($ARGV[1]+1)), 6378) ;
#print "$kmperdegX  $kmperdegY \n";

($thetad) = great_circle_destination(deg2rad($ARGV[0]),deg2rad(90 - $ARGV[1]),deg2rad(90), deg2rad($ARGV[2]/$kmperdegX));

($thetad, $phid) = great_circle_destination($thetad,deg2rad(90 - $ARGV[1]),deg2rad(180), -1*deg2rad($ARGV[3]/$kmperdegY));

$thetad = rad2deg($thetad); 
$phid = rad2deg($phid);

print "$thetad $phid" ;  
