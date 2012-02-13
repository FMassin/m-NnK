#!/usr/bin/perl 
#             -w  affiche warning
##########################################################################################################################
##########################################################################################################################

if(substr($ARGV[0],-1,1) eq "/") { $ARGV[0] = substr($ARGV[0],0,length($ARGV[0])-1 ) ; };

my @list = `ls -dl $ARGV[0] | grep drwxr | awk '{print \$NF}'`;

foreach (@list) {
	chomp($_);
	print "Stacks set as master waveforms for future upgrades\n";
	my $com= "ls ".$_."/stacks/*/*_E.sac.linux.stack | sed -e 's;/WY_;/F-;g' | sed -e 's;.*;cp & F-&-F;' | sed -e 's;/F-;/WY_;' | sed -e 's;/F-;/;' | sed -e 's;F-".$_."/stacks/................;".$_.";' | sed -e 's;.stack-F;-F;' | sed -e 's;_E.sac.linux-F;_WY.sac.linux;'" ;
	`$com > test.sh`;
	`sed -e 's;/MCI;/MCD;' test.sh > test2.sh`;
	`mv test2.sh test.sh`;
	my $a = `cat test.sh`;#print "$a";
	`sh test.sh`
}

