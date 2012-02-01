#!/bin/sh
# 

cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,20,1)=="P" \&\& substr(\$0,41,5)!="  O-C" {print substr(\$0,41,5)} N &\/*UUSS.inp.loc.hypo71\/zl.h;' | tr -s "N" "'" | sh > ../../tmp/res-P-UUSS-hypo71.txt
cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,52,1)=="S" \&\& substr(\$0,68,5)!="  O-C" {print substr(\$0,68,5)} N &\/*UUSS.inp.loc.hypo71\/zl.h;' | tr -s "N" "'" | sh > ../../tmp/res-S-UUSS-hypo71.txt

cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,20,1)=="P" \&\& substr(\$0,41,5)!="  O-C" {print substr(\$0,41,5)} N &\/*.enriched.loc.hypo71\/zl.h;' | tr -s "N" "'" | sh > ../../tmp/res-P-NNK-hypo71.txt
cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,52,1)=="S" \&\& substr(\$0,68,5)!="  O-C" {print substr(\$0,68,5)} N &\/*.enriched.loc.hypo71\/zl.h;' | tr -s "N" "'" | sh > ../../tmp/res-S-NNK-hypo71.txt


