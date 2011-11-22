cp fpfit.prt fpfit.prt.old
cp fpfit.prt fpfit.prt.bu


cat ../../events/*/*.UUSS.inp | awk '$2=="PD0" {print $0}' | sed -e 's; PD; PC;' | sed -e 's; ;sed -e xs/;' | sed -e 's; P;.................P;' | sed -e 's;0 .*;/\&X/x fpfit.prt.bu | sed -e xs/CX/D/x > fpfit.prt  \n mv fpfit.prt fpfit.prt.bu ;'  | sed -e s/"x"/"'"/g | sh
cat ../../events/*/*.UUSS.inp | awk '$2=="PC0" {print $0}' | sed -e 's; PC; PD;' | sed -e 's; ;sed -e xs/;' | sed -e 's; P;.................P;' | sed -e 's;0 .*;/\&X/x fpfit.prt.bu | sed -e xs/DX/C/x > fpfit.prt  \n mv fpfit.prt fpfit.prt.bu ;'  | sed -e s/"x"/"'"/g | sh
mv fpfit.prt.bu fpfit.prt

fpfit <paternfpfit
fpplot <paternfpplot
mv LaserWriter.ps fpfit.ps
