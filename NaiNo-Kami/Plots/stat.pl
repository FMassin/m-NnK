#!/usr/bin/perl 
#             -w  affiche warning
##########################################################################################################################
##########################################################################################################################
my $chem = $ARGV[0] ; #"/data/4Fred/WF/WY/dtec";
`ls -d $chem/1980/*/*/* > tmp.txt`;
`ls -d $chem/1981/*/*/* >> tmp.txt`;
`ls -d $chem/1982/*/*/* >> tmp.txt`;
`ls -d $chem/1983/*/*/* >> tmp.txt`;
`ls -d $chem/1984/*/*/* >> tmp.txt`;
`ls -d $chem/1985/*/*/* >> tmp.txt`;
`ls -d $chem/1986/*/*/* >> tmp.txt`;
`ls -d $chem/1987/*/*/* >> tmp.txt`;
`ls -d $chem/1988/*/*/* >> tmp.txt`;
`ls -d $chem/1989/*/*/* >> tmp.txt`;
`ls -d $chem/1990/*/*/* >> tmp.txt`;
`ls -d $chem/1991/*/*/* >> tmp.txt`;
`ls -d $chem/1992/*/*/* >> tmp.txt`;
`ls -d $chem/1993/*/*/* >> tmp.txt`;
`ls -d $chem/1994/*/*/* >> tmp.txt`;
`ls -d $chem/1995/*/*/* >> tmp.txt`;
`ls -d $chem/1996/*/*/* >> tmp.txt`;
`ls -d $chem/1997/*/*/* >> tmp.txt`;
`ls -d $chem/1998/*/*/* >> tmp.txt`;
`ls -d $chem/1999/*/*/* >> tmp.txt`;
`ls -d $chem/2000/*/*/* >> tmp.txt`;
`ls -d $chem/2001/*/*/* >> tmp.txt`;
`ls -d $chem/2002/*/*/* >> tmp.txt`;
`ls -d $chem/2003/*/*/* >> tmp.txt`;
`ls -d $chem/2004/*/*/* >> tmp.txt`;
`ls -d $chem/2005/*/*/* >> tmp.txt`;
`ls -d $chem/2006/*/*/* >> tmp.txt`;
`ls -d $chem/2007/*/*/* >> tmp.txt`;
`ls -d $chem/2008/*/*/* >> tmp.txt`;
`ls -d $chem/2009/*/*/* >> tmp.txt`;
`ls -d $chem/2010/*/*/* >> tmp.txt`;

#`ls -d /data/4Fred/WF/WY/dtec/2010/01/27/20100127234450WY > tmp.txt`;

open (FILE,"<tmp.txt") || print"WARNING: can't open constant definition file: tmp.txt" ;
open (NEWFILE,">statistic.txt") || print"WARNING: can't open constant definition file: statistics.txt" ;
while(my $line = <FILE>) {
        chomp($line) ;
        my $resp=`ls -dl $line`;
        my $dir = 0 ;
        my $link = 0 ; 
	my $newclust = 0 ; 
	my $endclust = 0 ; 
        $resp = substr($resp,0,1); 
        if($resp eq 'd') {  $dir = 1 ; }
        if($resp eq 'l') {  $link = 1 ; }
	if($resp eq 'l') {
		$line =~ s/dtec/clst/;
		my @elt = split("/",$line);
		my $cur = $elt[-1] ;
		my @test=`ls -dl $line/events/????????????????`;
		my $first = $test[0] ; 
		my $last = $test[-1] ;
		chomp($first); chomp($last);
		my @elt = split("/",$first);
		$first = $elt[-1] ; 
		my @elt = split("/",$last);
                $last = $elt[-1] ;
	#	print "$cur eq $first or eq  $last ? \n";
		if($cur eq $first) {  $newclust = 1 ; }
		if($cur eq $last) {  $endclust = 1 ; }
	}
	$line =~ s/clst/dtec/; 
        #print "$resp $dir $link \n";
        print NEWFILE "$line $dir $link $newclust $endclust \n";
}
close(FILE);
close(NEWFILE);

`mv tmp.txt lst.tmp`;
`mv statistic.txt total-vs-clustered.tmp`;



