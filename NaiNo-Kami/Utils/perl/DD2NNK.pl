#!/usr/bin/perl 
#             -w  affiche warning
##########################################################################################################################
# usage ./DD2NNK.pl ./hypoDD-hypo71/ hypo71 tomoDD #######################################################################

my $len = scalar(@ARGV) ;
if($len == 2) {$ARGV[2] = "hypoDD";} 
my $cnt = 0 ; 
my $fileref = '';
my $file1 = `ls $ARGV[0]/ID.txt`;
my $file2 = `ls $ARGV[0]/loc.txt.$ARGV[1]`;
my $file3 = $ARGV[0].'/'.$ARGV[2].'.reloc';
chomp($file1);
chomp($file2);
open (LOCS,"<$file2") || print"WARNING: can't open constant definition file" ;


while(my $loc = <LOCS>) {
	chomp($loc) ;
	my @eltL=split(' ',$loc) ; 

	print "sed -n $eltL[1]p <$file1\n";
	my $inp = `sed -n "$eltL[1]p" <$file1`;
	chomp($inp);
	if(length($inp) > 5) {	
		print "awk '\$1 == $eltL[1] { print \$0 }' $file3 \n";
		my $reloc = `awk '\$1 == $eltL[1] { print \$0 }' $file3 `;

		chomp($reloc);
		if(length($reloc) > 5) {

			$cnt = $cnt+1 ;

			my $file4 = $inp.'.reloc.'.$ARGV[2].'.'.$ARGV[1];
			my $file5 = $file4 .'/'.$ARGV[2];

			print "mkdir -p $file4\n";
			`mkdir -p $file4`;
			$file4 = $file4.'/'.$ARGV[2].'.reloc';

			print "echo '$reloc' > $file4\n";
			`echo '$reloc' > $file4`;
			if ($cnt == 1) {
			print "rm -rf $file5\n";
				`rm -r $file5`;
				print "cp -r $ARGV[0] $file5\n";
				`cp -r $ARGV[0] $file5`;
				my @elt = split('/',$file5);
				$fileref = '../../../../../../../'.$elt[-8].'/'.$elt[-7].'/'.$elt[-6].'/'.$elt[-5].'/'.$elt[-4].'/'.$elt[-3].'/'.$elt[-2].'/'.$elt[-1].'/'.$elt[0] ;
			} else {
				print "rm -rf $file5\n";
				`rm -r $file5`;
				print "ln -s $fileref  $file5\n";
				`ln -s $fileref  $file5`;
			}	
		}
	}
	print "======================NEXT============================\n";
}
close(LOCS);
