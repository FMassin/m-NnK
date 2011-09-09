#!/usr/bin/perl 
#             -w  affiche warning
##########################################################################################################################
##########################################################################################################################

my $p = '                      ' ;
my $s = '                      ' ;
my $c = '                      ' ; 
my $e = '                      ' ;
my $staNNK ;
my $sta = '   ' ;
my $cnt = 0 ;
my $path = '/Users/fredmassin/PostDoc_Utah/Processes/NaiNoKami_2/NNK' ;
my $file = $ARGV[0] ;
my $stauuss = $ARGV[1] ; # substr(`$path/staname4NNK1.pl $ARGV[1] -1`,0,3) ;
if($ARGV[1] eq "all") {
	$stauuss = '\w\w\w' ; 
}
if(-e $file) {
	open (lefichier,"<$file") || print"WARNING: can't open variable definition file: ".$file ; 
	my $datehhmms = 0 ; 
	while(my $line = <lefichier>) {
        	chomp($line) ;
		
        
        my $pol = ' ' ;
#        my $P = ' ' ;
#        my $weightP = ' ' ;
#        my $pickP = '               ' ;
#        my $pickS = '      ' ;
#        my $S = ' ' ;
#        my $weightS = ' ' ;
#        my $pickC = '      ' ;
#        my $C = ' ' ;
        if($line =~ /(\d\d\d\d\d\d\d\d\d\d)/) {$datehhmms = $1 ; }
        if($line =~ /($stauuss[\s\w])\s*([\w\?])\s*(\d)\s*(\d{1,3}\.\d{1,2})\s*(\d)\s*(\d{1,3}\.\d{1,2})\s*(\d{1,3})\s*(\d\.\d{1,2})\s*(\d\.\d{1,2})\s*(\d{1,2})\s*(\d{1,2})/) {
        # reconnait |YGC  ?   1  61.38 0   0.00   6  1.91  2.21  65  70     0
        # reconnait |yhbz d   0  60.43 2  61.50   0  0.00  0.00   0   0     0
        # reconnait |ymrz ?   1  62.47 2  64.81   0  0.00  0.00   0   0     0
	#            MCID ?   1  89.59 0   0.00  21  1.85  3.15  96 110     0
        #            stat pol w  p     w  s       duration
            $sta = $1 ; 
            #print "$datehhmms\n$line\n$1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11\n-$sta-\n";
            if(substr($sta,length($sta)-1,1) eq ' ') {$sta = substr($sta,0,length($sta)-1);}
            if(substr($sta,length($sta)-1,1) eq 'z') {$sta = substr($sta,0,length($sta)-1);}
            if(substr($sta,length($sta)-1,1) eq 'Z') {$sta = substr($sta,0,length($sta)-1);}
            $staNNK = `$path/staname4NNK1.pl $sta 1` ;
           # print "$sta-$staNNK-$ARGV[1]\n";

            if(($sta eq $ARGV[1]) || ($staNNK eq $ARGV[1]) || ($ARGV[1] eq "all")) {
                    $P = 'P';
                    if($2 eq 'c') {$pol = 'C';}
                    if($2 eq 'd') {$pol = 'D';}
                    if($2 eq '?') {$pol = ' ';}
                    $weightP = $3 ;
	
		    $sta2print[$cnt] = $sta.' '.$staNNK ; 
		    $p[$cnt] = '                       ' ; 
                    $s[$cnt] = '                       ' ;
                    $c[$cnt] = '                       ' ;
                    $e[$cnt] = '                       ' ;

                    if($4 gt 0)  {$p[$cnt] = $P.$pol.' '.$datehhmms.'00 '.substr($4+1000.001,1,6).' '  ;}
                    if($6 gt 0)  {$s[$cnt] = 'S  '.$datehhmms.'00 '.substr($6+1000.001,1,6).' ' ;}
                    if($10 gt 0) {$c[$cnt] = 'C  '.$datehhmms.'00 '.substr($10+1000.001,1,6).' ' ;}	
                    if($7 gt 0)  {$e[$cnt] = 'E  '.$datehhmms.'00 '.substr($4+$7+1000.001,1,6).' ' ;}	
		    $cnt=$cnt+1;
            }
        }
     }
}
for ($i = 0; $i <= $cnt ; ++$i) {  
if($ARGV[2] eq "P" ){
        print "$p[$i]$sta2print[$i]\n" ;
}
if($ARGV[2] eq "S" ){
        print "$s[$i]$sta2print[$i]\n" ;
}
if($ARGV[2] eq "C" ){
	print "$c[$i]$sta2print[$i]\n" ;    
}
if($ARGV[2] eq "E" ){
        print "$e[$i]$sta2print[$i]\n" ;
}
if($ARGV[2] eq "all" ){
        print "$p[$i]$s[$i]$c[$i]$e[$i]$sta2print[$i]\n" ;
}
}
