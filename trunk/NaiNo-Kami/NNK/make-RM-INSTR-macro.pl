#!/usr/bin/perl 
#             -w  affiche warning
##########################################################################################################################
##########################################################################################################################
# usage : ./make-RM-INSTR-macro.pl '~/Bureau/fred-at-dot/WF/WY/cntn/2008/*/*.SAC' '~/Bureau/fred-at-dot/WF/WY/cntn/RAW_RESP/SAC_PZs*'
##########################################################################################################################
my $out = 'vel';
my $freqs = '0.05 0.10 15 30';
my $prew = 'on';

my $suffix = uc($out);
`mv rm-instr.macro rm-instr.macro.old`;
`mv liste.txt liste.txt.old`;

`ls $ARGV[0] > lstdata`;
`ls $ARGV[1] > lstdataless`; 

open(LST1,'<lstdata');
open(LISTE,'>liste.txt');
my $cnt=0;
while(my $data = <LST1>) {
        chomp($data) ;
#	/home/fred/Bureau/fred-at-dot/WF/WY/cntn/2008/2008.001/2008.001.15.59.35.7290.WY.YFT..HHZ.M.SAC
	my @elt0=split('/',$data);
	my $filename = $elt0[-1];
	@elt0=split('\.',$filename);
	my $date0 = $elt0[0]+$elt0[1]/1000+0.0001; 
	my $dataless ='';
 	my $flag = 0 ; 

	open(LST2,'<lstdataless');
	while(my $tmpdataless = <LST2>) {
		chomp($tmpdataless) ;
#		/home/fred/Bureau/fred-at-dot/WF/WY/cntn/RAW_RESP/SAC_PZs_WY_YDC_EHZ__1987.255.00.00.00.0000_1989.221.23.59.59.99999
		my @elt1=split('/',$tmpdataless);
		my $filenameless = $elt1[-1];		
		my @elt1=split('_',$filenameless);
		my $date1=1*substr($elt1[6],0,8)+0.0001;
		my $date2=1*substr($elt1[7],0,8)+0.0001; 
		if(($elt1[2] eq $elt0[6]) && ($elt1[3] eq $elt0[7]) && ($elt1[4] eq $elt0[9]) && ($date1 <= $date0) && ($date0 <= $date2)) {
			$dataless = $tmpdataless;
			$flag = 1;
		}
	}
	close(LST2);
	if($flag == 0) {my $tmp=substr($data,0,length($data)-length($filename)); print "HEY ?! WARNING : no response found for $filename (in $tmp)\n";}
	if($flag == 1) {
		$cnt=$cnt+1;
		print LISTE "$data\n";
		open(MACRO,'>rm-instr.macro');
		print MACRO ":b\n";
		print MACRO "* *********NEW FILE***********\n";
		print MACRO "echo on\n";
		print MACRO "cut off\n";
		print MACRO "read $data\n";
		print MACRO "rmean\n";
		print MACRO "taper type hanning width 0.05\n";
		print MACRO "write cjunk\n";
		print MACRO "cuterr fillz\n";
		print MACRO "cut on b 0.0 e 30.0\n";
		print MACRO "read cjunk\n";
		print MACRO "cut off\n";
		print MACRO "cuterr usebe\n";
		print MACRO "sc rm cjunk\n";
		print MACRO "transfer from polezero s $dataless to $out freq $freqs prew $prew\n";
		print MACRO "mul 1000.0\n";
		print MACRO "chnhdr idep IVEL\n";
		print MACRO "write $data-$suffix\n";
		print MACRO "quit\n";
		print MACRO ":e\n";
		close(MACRO);
		system('/usr/local/sac/bin/sac < rm-instr.macro');
	}
	
}
close(LST1);
close(LISTE);
print "The files in liste.txt ($cnt files) have been processed in sac\n";
`rm lstdataless lstdata`;


