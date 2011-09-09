#!/usr/bin/perl 
#             -w  affiche warning
##########################################################################################################################
##########################################################################################################################


my $difYY = (substr($ARGV[0],0,2)-substr($ARGV[1],0,2) ) ; 
my $difMM = (substr($ARGV[0],2,2)-substr($ARGV[1],2,2) ) ; 
my $difDD = (substr($ARGV[0],4,2)-substr($ARGV[1],4,2) ) ; 
my $difhh = (substr($ARGV[0],6,2)-substr($ARGV[1],6,2) ) ; 
my $difmm = (substr($ARGV[0],8,2)-substr($ARGV[1],8,2) ) ; 
my $difss = (substr($ARGV[0],10,2)-substr($ARGV[1],10,2)) ; 


if($difYY < 0) {$difMM = $difMM + (($difYY)*12) ; }
if($difYY > 0) {$difMM = -1*($difMM + (($difYY)*12)) ; }

if($difMM < 0) {$difDD = $difDD + (($difMM)*30) ; }
if($difMM > 0) {$difDD = -1*($difDD + (($difMM)*30)) ; }

if($difDD < 0) {$difhh = $difhh + (($difDD)*24) ; }
if($difDD > 0) {$difhh = -1*($difhh +(($difDD)*24)) ; }

if($difhh < 0) {$difmm = $difmm + (($difhh)*60) ; }
if($difhh > 0) {$difmm = -1*($difmm + (($difhh)*60)) ; }

if($difmm < 0) {$difss = $difss + (($difmm)*60) ; }
if($difmm > 0) {$difss = -1*($difss + (($difmm)*60)) ;} 

my $diff = $difss ;
print "$diff" ; 
