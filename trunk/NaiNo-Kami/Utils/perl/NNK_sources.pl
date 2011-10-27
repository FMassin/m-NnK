#!/usr/bin/perl 
#             -w  affiche warning
##########################################################################################################################
#M#	 USAGE : ./NNK_sources.pl 'path' 'task code'
#M#
#M#	 TASK CODES : 
#M#	  hyp
#M#	  nll
#M#	  hypodd-hypo71
#M#	  hypodd-nlloc
#M#       hypodd3d-hypo71
#M#       hypodd3d-nlloc
#M#	  tomodd-hypo71
#M#	  tomodd-nlloc
#M#	  fpfit
#M#	  locs : hyp nll
#M#	  relocs : hypodd-hypo71 hypodd-nlloc hypodd3d-hypo71 hypodd3d-nlloc
#M#	  1d : hyp hypodd-hypo71 
#M#	  3d : nll hypodd3d-nlloc
#M#	  all : hyp nll hypodd-hypo71 hypodd-nlloc hypodd3d-hypo71 hypodd3d-nlloc fpfit
#M#
#M#	 EXAMPLES :
#M#	  ./NNK_sources.pl "/data/4Fred/WF/WY/clst/*/*/*/*WY" "tomodd-hypo71"
#M#	  ./NNK_sources.pl "/data/4Fred/WF/WY/clst/*/*/*/*WY" "tomodd-nlloc"
#M#	  ./NNK_sources.pl "/data/4Fred/WF/WY/clst/*/*/*/*WY" fpfit
#M#	  ./NNK_sources.pl '/data/4Fred/WF/WY/clst/2008/01/01/20080101222940WY/events/*/*.inp' 'nll'
#M#	  ./NNK_sources.pl "/data/4Fred/WF/WY/dtec/1992/*/*/*WY/*.UUSS.inp" "locs"
#M#
#M#	fred.massin@gmail.com UUSATRG 10/13/2011
##########################################################################################################################
my $flagdir =1;
my $apriori = "/home/fred/Documents/WY";
#my $suffix = ".UUSS.inp";
#my $suffix = "WY.inp" ; 
my $suffix = ".inp.enriched" ; 
my $tomo = 0 ; 
my $nbel = @ARGV;

##########################################################################################################################
#0. preparation of inputs and output
#if($nbel eq 2) {$ARGV[1]="all";}
my $test=substr($ARGV[0],length($ARGV[0])-3,3);
if ($test eq "inp") {
	system("ls $ARGV[0] > inpfilesnames");
	$flagdir =0;
};
if ($test ne "inp") {
	$flagdir = 1 ;
      	system("ls -dl $ARGV[0] | grep drw | awk '{print \$8}' > inpfilesnames");
};

##########################################################################################################################
# Locations ##############################################################################################################
if ($ARGV[1] ne "fpfit") {
	if (-e "./OLD_Result") { system("rm -r ./OLD_Result/*");}
	system("mkdir -p ./OLD_Result");
	`mkdir -p ./4DDs`;
	system("rm ./4DDs/ID.txt");

	open(INPS,"<inpfilesnames") || print"WARNING: can't open constant definition file: inpfilesnames" ;
	while(my $inp = <INPS>) {
		chomp($inp) ;
		if ($flagdir eq 0) {`ls $inp > tmp`;}
		if ($flagdir eq 1) {`ls $inp/events/*/*$suffix > tmp`;} 
		open(THEINPS,"<tmp") || print"WARNING: can't open constant definition file: tmp" ;
		while(my $theinp = <THEINPS>) {
			chomp($theinp);
			`ls $theinp >> ./4DDs/ID.txt`;
			if(($ARGV[1] eq "locs") || ($ARGV[1] eq "1d")  || ($ARGV[1] eq "all") || ($ARGV[1] eq "hyp")) {
				##########################################################################################################################
				#1. Localisation hypo71 with station elevation correction (Nercessian)####################################################
				print "### Location hypo71 using : $theinp\n";
				system("cat $theinp > inpfiles");
				if (-e "./hypo71") { system("rm -r ./hypo71");};
				system("mkdir -p ./hypo71");
				system("cat $apriori/4hypo71/STATE inpfiles > h.i");
				system("echo h.i > zh"); 
				system("echo $apriori/4hypo71/h.l >> zh"); 
				system("echo $apriori/4hypo71/h.p >> zh");
				system("echo $apriori/4hypo71/h.r >> zh");
				system("echo >> zh "); 
				system("echo $apriori/4hypo71/h.z >> zh");
				system("Hypo < zh > zl.h");
				system("mv h.i zh zl.h ./hypo71/");
				system("cp $apriori/4hypo71/h.* ./hypo71/");
				system("rm -rf $theinp.loc.hypo71");
				system("cp -r ./hypo71 $theinp.loc.hypo71");
				#print "cp -r ./hypo71 $theinp.loc.hypo71\n";
			}
			
			if(($ARGV[1] eq "locs") || ($ARGV[1] eq "3d")  || ($ARGV[1] eq "all") || ($ARGV[1] eq "nll")) {	
				##########################################################################################################################
				#2. Localisation NLLoc (Lomax) ###########################################################################################
				print "### Location NLLoc using  : $theinp\n";
				system("cat $theinp > test");
				system("sed -e 's;                 10;#;' test > inpfiles");
				if (-e "./NLLoc") { system("rm -r ./NLLoc ");};
				system("mkdir -p ./NLLoc"); 
				system("NLLoc $apriori/4NLL/NLL.inp > ./NLLoc.log2"); 
				system("mv NLLoc ./NLLoc/");
				system("rm -rf $theinp.loc.nlloc");
				system("cp -r ./NLLoc $theinp.loc.nlloc");
				system("head -n 8 $theinp.loc.nlloc/WY_.????????.??????.grid0.loc.hyp | tail -n 2");
				#print "cp -r ./NLLoc $theinp.loc.nlloc\n";
			}
			
			if($ARGV[1] eq "loctv") {
				##########################################################################################################################
				#3. Localisation tomoTV (Monteillier & Got) ##############################################################################
				#print "### Location tomoTV using : $theinp \nloc $apriori/4tomoTV/loc.par\n";
				#system("loc $apriori/4tomoTV/loc.par") ; 
				#system("mv res_loc  ./res_loc/");if($info eq 1) {print "$command";}
				##########################################################################################################################
			}
		}
		close(THEINPS);
		`rm tmp`;
	}
#	close(INPS);

	if(($ARGV[1] eq "relocs") || ($ARGV[1] eq "all") || ($ARGV[1] eq "3d")  || ($ARGV[1] eq "1d")  || ($ARGV[1] eq "tomodd-nlloc")  || ($ARGV[1] eq "hypodd") || ($ARGV[1] eq "hypodd-hypo71")  || ($ARGV[1] eq "hypodd-nlloc") ) {
		print "### Preparation of hypoDD catalogs\n";
		system("./prt2ph2dt.pl"); 

		if(($ARGV[1] eq "relocs") || ($ARGV[1] eq "1d")  || ($ARGV[1] eq "all") || ($ARGV[1] eq "hypodd") || ($ARGV[1] eq "hypodd-hypo71") ) {
			##########################################################################################################################
			#4. Localistaion DD hypoDD with station correction (Nercessian from Waldhauser)
			print "### Re-location hypoDD with hypo71 outputs\n";
			system("cp $apriori/4hypoDD/ph2dt.inp.hypo71  $apriori/4hypoDD/hypoDD.inp.hypo71 $apriori/4hypoDD/station.dat ."); 
			if (-e "./hypoDD-hypo71") { system("rm -r ./hypoDD-hypo71");}
			system("mkdir -p ./hypoDD-hypo71");
			system("ph2dt ph2dt.inp.hypo71");
			system("hypoDD hypoDD.inp.hypo71");
			system("cp 4DDs/*.hypo71 4DDs/ID.txt  ./hypoDD-hypo71/");
			system("mv ph2dt.inp.hypo71 hypoDD.inp.hypo71 *.hypo71 dt.ct ph2dt.log station.sel station.dat event.??? hypoDD.??? *reloc* ./hypoDD-hypo71/");
			system("./DD2NNK.pl ./hypoDD-hypo71/ hypo71");
		}
		if(($ARGV[1] eq "relocs") || ($ARGV[1] eq "all") || ($ARGV[1] eq "hypodd") || ($ARGV[1] eq "hypodd-nlloc") ) {
			##########################################################################################################################
			#4. Localistaion DD hypoDD with station correction (Nercessian from Waldhauser)
			print "### Re-location hypoDD with nlloc outputs\n";
			system("cp $apriori/4hypoDD/ph2dt.inp.nlloc  $apriori/4hypoDD/hypoDD.inp.nlloc $apriori/4hypoDD/station.dat ."); 
			if (-e "./hypoDD-nlloc") { system("rm -r ./hypoDD-nlloc");}
			system("mkdir -p ./hypoDD-nlloc");
			system("ph2dt ph2dt.inp.nlloc");
			system("hypoDD hypoDD.inp.nlloc");
			system("cp 4DDs/ID.txt  4DDs/*.nlloc ./hypoDD-nlloc/");         
			system("mv ph2dt.inp.nlloc hypoDD.inp.nlloc *.nlloc dt.ct ph2dt.log station.dat station.sel event.??? hypoDD.??? *reloc* ./hypoDD-nlloc/");
			system("./DD2NNK.pl ./hypoDD-nlloc/ nlloc");
		}
		if(($ARGV[1] eq "relocs") || ($ARGV[1] eq "3d") || ($ARGV[1] eq "all") || ($ARGV[1] eq "hypodd") || ($ARGV[1] eq "hypodd3d-nlloc") ) {
                        ##########################################################################################################################
                        #4. Localistaion DD hypoDD with station correction (Nercessian from Waldhauser)
                        print "### 3D Re-location hypoDD with nlloc outputs\n";
                        system("cp $apriori/4hypoDD3d/ph2dt.inp.nlloc  $apriori/4hypoDD3d/hypoDD.inp.nlloc $apriori/4hypoDD3d/station.dat .");
                        if (-e "./hypoDD3d-nlloc") { system("rm -r ./hypoDD3d-nlloc");}
                        system("mkdir -p ./hypoDD3d-nlloc");
                        system("ph2dt ph2dt.inp.nlloc");
                        system("hypoDD hypoDD.inp.nlloc");
			system("cp 4DDs/ID.txt 4DDs/*.nlloc ./hypoDD3d-nlloc/");
                        system("mv ph2dt.inp.nlloc hypoDD.inp.nlloc *.nlloc dt.ct ph2dt.log station.dat event.??? station.sel hypoDD.??? *reloc* ./hypoDD3d-nlloc/");
                        system("./DD2NNK.pl ./hypoDD3d-nlloc/ nlloc hypoDD 3d");
                }
		if(($ARGV[1] eq "relocs") || ($ARGV[1] eq "3d")  || ($ARGV[1] eq "all") || ($ARGV[1] eq "hypodd") || ($ARGV[1] eq "hypodd3d-hypo71") ) {
                        ##########################################################################################################################
                        #4. Localistaion DD hypoDD with station correction (Nercessian from Waldhauser)
                        print "### 3D Re-location hypoDD with hypo71 outputs\n";
                        system("cp $apriori/4hypoDD3d/ph2dt.inp.hypo71  $apriori/4hypoDD3d/hypoDD.inp.hypo71 $apriori/4hypoDD3d/station.dat .");
                        if (-e "./hypoDD3d-hypo71") { system("rm -r ./hypoDD3d-hypo71");}
                        system("mkdir -p ./hypoDD3d-hypo71");
                        system("ph2dt ph2dt.inp.hypo71");
                        system("hypoDD hypoDD.inp.hypo71");
			system("cp 4DDs/ID.txt  4DDs/*.hypo71 ./hypoDD3d-hypo71/");
                        system("mv ph2dt.inp.hypo71 hypoDD.inp.hypo71 *.hypo71 dt.ct ph2dt.log station.dat event.??? station.sel hypoDD.??? *reloc* ./hypoDD3d-hypo71/");
                        system("./DD2NNK.pl ./hypoDD3d-hypo71/ hypo71 hypoDD 3d");
		}

		if($ARGV[1] eq "tomodd-hypo71") {
			##########################################################################################################################
			#5. Localistaion DD tomoDD (Zhang)
			print "### 3D Re-location tomoDD with hypo71 outputs\n";
			my $local = `pwd`;	chomp($local) ;
			`mkdir -p ./tomoDD-hypo71`;
			`rm ./tomoDD-hypo71/*`;

			print "Preparing ./tomoDD-hypo71\n";
			`cp inpfiles inpfilesnames ./4DDs/ID.txt ./4DDs/loc.txt.hypo71 ./4DDs/event.dat.hypo71 ./4DDs/phase.dat.hypo71 ./4DDs/4dt.cc.hypo71 ./4DDs/dt.cc.hypo71 ./tomoDD-hypo71`;
			`cp $apriori/4tomoDD/ph2dt.inp.hypo71  $apriori/4tomoDD/tomoDD.inp.hypo71 $apriori/4tomoDD/station.dat  $apriori/4tomoDD/MOD ./tomoDD-hypo71/`;
			`awk '{if (\$1=="#") {print \$1 " " \$15} else print \$0}'  ./4DDs/phase.dat.hypo71 > ./tomoDD-hypo71/phase.dat.hypo71.tomoDD `;

			chdir "tomoDD-hypo71" ;
			print "ph2dt ...\n"; 
			`ph2dt ph2dt.inp.hypo71 > ph2dt.errors`;
			`awk '{print \$0 " 0"} '  event.dat > event.dat.hypo71`;

			print "tomoDD ...\n"; 
			`echo "1" > paterntomoDD`;
			`tomoDD09 tomoDD.inp.hypo71 < paterntomoDD > tomoDD.errors`;
			chdir $local ;
			`./DD2NNK.pl ./tomoDD-hypo71/ hypo71 tomoDD`;    
		}

		if($ARGV[1] eq "tomodd-nlloc") {
			##########################################################################################################################
			#5. Localistaion DD tomoDD (Zhang)
			print "### 3D Re-location tomoDD with nlloc outputs\n";
			my $local = `pwd`;      chomp($local) ;
			`mkdir -p ./tomoDD-nlloc`;
			`rm ./tomoDD-nlloc/*`;

			print "Preparing ./tomoDD-nlloc\n";
			`cp inpfiles inpfilesnames ID.txt loc.txt.nlloc event.dat.nlloc phase.dat.nlloc 4dt.cc.nlloc dt.cc.nlloc ./tomoDD-nlloc/`;
			`cp $apriori/4tomoDD/ph2dt.inp.nlloc  $apriori/4tomoDD/tomoDD.inp.nlloc $apriori/4tomoDD/station.dat  $apriori/4tomoDD/MOD ./tomoDD-nlloc/`;
			`awk '{if (\$1=="#") {print \$1 " " \$15} else print \$0}'  phase.dat.nlloc > ./tomoDD-nlloc/phase.dat.nlloc.tomoDD `;

			chdir "tomoDD-nlloc" ;
			print "ph2dt ...\n";
			`ph2dt ph2dt.inp.nlloc > ph2dt.errors`;
			`awk '{print \$0 " 0"} '  event.dat > event.dat.nlloc`;

			print "tomoDD ...\n";
			`echo "1" > paterntomoDD`;
			`tomoDD09 tomoDD.inp.nlloc < paterntomoDD > tomoDD.errors`;
			chdir $local ;
			`./DD2NNK.pl ./tomoDD-nlloc/ nlloc tomoDD`;

		}
	}
}

if(($ARGV[1] eq "fpfit") || ($ARGV[1] eq "all")) {
	my $local = `pwd`;      chomp($local) ;
	open(INPS,"<inpfilesnames") || print"WARNING: can't open constant definition file: inpfilesnames" ;
	while(my $inp = <INPS>) {
		chomp($inp) ;
		if ($flagdir eq 0) {`ls $inp > tmp`;}
		if ($flagdir eq 1) {
			`ls $inp/events/*/*$suffix > tmp`; 
			`rm $inp/source/fpfit.prt`;
			open(THEINPS,"<tmp") || print"WARNING: can't open constant definition file: tmp" ;
			while(my $theinp = <THEINPS>) {
				chomp($theinp);
				#`./DD2prt.pl $theinp`;
				my $hyp1 = $theinp.".loc.hypo71/h71.prt" ;
				my $hyp2 = $theinp.".loc.nlloc/h71.prt";
				my $hyp3 = $theinp.".reloc.hypoDD.hypo71/h71.prt" ;
				my $hyp4 = $theinp.".reloc.hypoDD.nlloc/h71.prt" ;
				my $hyp5 = $theinp.".reloc.hypoDD3d.hypo71/h71.prt" ;
                                my $hyp6 = $theinp.".reloc.hypoDD3d.nlloc/h71.prt" ;
				my $hyp7 = $theinp.".reloc.tomoDD.hypo71/h71.prt";
				my $hyp8 = $theinp.".reloc.tomoDD.nlloc/h71.prt" ;
				my $hyp = $hyp1 ;
				if (-e $hyp1) {$hyp = $hyp1 ;}
				if (-e $hyp2) {$hyp = $hyp2 ;}
				if (-e $hyp3) {$hyp = $hyp3 ;}
				if (-e $hyp4) {$hyp = $hyp4 ;}
				if (-e $hyp5) {$hyp = $hyp5 ;}
				if (-e $hyp6) {$hyp = $hyp6 ;}
				if (-e $hyp7) {$hyp = $hyp7 ;}
                                if (-e $hyp8) {$hyp = $hyp8 ;}
				`cat $hyp >> $inp/source/fpfit.prt `;
				`echo " " >> $inp/source/fpfit.prt `;
			}
			`mkdir -p ./fpfit`;
			`cp  $inp/source/fpfit.prt $apriori/4fpfit/paternfpfit $apriori/4fpfit/paternfpplot $apriori/4fpfit/fpfit.inp ./fpfit/`;
			chdir "./fpfit" ;
			`fpfit < paternfpfit`;
			`fpplot < paternfpplot`;
			sleep undef, undef, undef, 1;
			`mv LaserWriter.ps fpfit.ps` ; 
			`ps2raster -Tf -A fpfit.ps`;
			chdir $local ;
			`rm -r $inp/source/fpfit`;
			`mv ./fpfit $inp/source/fpfit`;
			print "fpfit results in $inp/source/fpfit \n";
		}
	}
}



if(($ARGV[1] eq "relocs") || ($ARGV[1] eq "all") || ($ARGV[1] eq "loctvdd")) {
        #       ##########################################################################################################################
        #       #6. Localistaion DD tomoTV (Monteillier & Got)
        #       system("loc_dd $apriori/loc_dd.par") ; if($info eq 1) {print "$command\n";}
        #       #    les resultats sont dans: res_loc_dd. Localisations de seisme (avec les differences de temps) dans le modele de vitesse synthetique
}
if(($ARGV[1] eq "tomos") || ($ARGV[1] eq "all") || ($ARGV[1] eq "tomodd")) {
	#       ##########################################################################################################################
        #       #7. tomographie tomoDD (Zhang)################################################################################
        #       if($tomo eq 1) {system("tomo $apriori/tomo.par");if($info eq 1) {print "$command\n";}}
        #       #       les resultats sont dans resultats res_tomo. Inversion conjointe des vitesse P hypocentres (avec les temps d'arrivee). 	
}
if(($ARGV[1] eq "tomos") || ($ARGV[1] eq "all") || ($ARGV[1] eq "tomotv")) {
	#	##########################################################################################################################
	#	#8. tomographie tomoTV (Monteillier & Got)################################################################################
	#	if($tomo eq 1) {system("tomo $apriori/tomo.par");if($info eq 1) {print "$command\n";}}
	#	#    	les resultats sont dans resultats res_tomo. Inversion conjointe des vitesse P hypocentres (avec les temps d'arrivee).	

	#	#9. tomographie DD tomoTV (Monteillier & Got)#############################################################################
	#	if($tomo eq 1) {system("tomo0_dd $apriori/tomo_dd.par"); if($info eq 1) {print "$command\n";}}
	#	#   	les resultats sont dans: res_tomo_dd. Inversion conjointe des vitesse P hypocentres (avec les differences de temps).	
	#	#   Pour visualiser les resultats, lancer matlab dans les repertoire du resultat concerne et lancer vi_iter a partir de la console matlab.
}
