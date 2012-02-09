#!/bin/sh
# 

#cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,20,1)=="P" \&\& substr(\$0,41,5)!="  O-C" {print substr(\$0,41,5)} N &\/*UUSS.inp.loc.hypo71\/zl.h | wc -l | awk N {print $1} N;' | tr -s "N" "'" | sh > ../../tmp/N-P-UUSS-hypo71.txt
#cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,52,1)=="S" \&\& substr(\$0,68,5)!="  O-C" {print substr(\$0,68,5)} N &\/*UUSS.inp.loc.hypo71\/zl.h | wc -l | awk N {print $1} N;' | tr -s "N" "'" | sh > ../../tmp/N-S-UUSS-hypo71.txt

#cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,20,1)=="P" \&\& substr(\$0,41,5)!="  O-C" {print substr(\$0,41,5)} N &\/*UUSS.inp.loc.hypo71\/zl.h;' | tr -s "N" "'" | sh > ../../tmp/res-P-UUSS-hypo71.txt
#cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,52,1)=="S" \&\& substr(\$0,68,5)!="  O-C" {print substr(\$0,68,5)} N &\/*UUSS.inp.loc.hypo71\/zl.h;' | tr -s "N" "'" | sh > ../../tmp/res-S-UUSS-hypo71.txt


#cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,20,1)=="P" \&\& substr(\$0,41,5)!="  O-C" {print substr(\$0,41,5)} N &\/*.enriched.loc.hypo71\/zl.h | wc -l | awk N {print $1} N;' | tr -s "N" "'" | sh > ../../tmp/N-P-NNK-hypo71.txt
#cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,52,1)=="S" \&\& substr(\$0,68,5)!="  O-C" {print substr(\$0,68,5)} N &\/*.enriched.loc.hypo71\/zl.h | wc -l | awk N {print $1} N;' | tr -s "N" "'" | sh > ../../tmp/N-S-NNK-hypo71.txt

#cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,20,1)=="P" \&\& substr(\$0,41,5)!="  O-C" {print substr(\$0,41,5)} N &\/*.enriched.loc.hypo71\/zl.h;' | tr -s "N" "'" | sh > ../../tmp/res-P-NNK-hypo71.txt
#cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,52,1)=="S" \&\& substr(\$0,68,5)!="  O-C" {print substr(\$0,68,5)} N &\/*.enriched.loc.hypo71\/zl.h;' | tr -s "N" "'" | sh > ../../tmp/res-S-NNK-hypo71.txt

#cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,20,1)=="P" \&\& substr(\$0,41,5)!="  O-C" {print substr(\$0,41,5)} N &\/*WY.inp.loc.hypo71\/zl.h | wc -l | awk N {print $1} N;' | tr -s "N" "'" | sh > ../../tmp/N-P-xcorr-hypo71.txt
#cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,52,1)=="S" \&\& substr(\$0,68,5)!="  O-C" {print substr(\$0,68,5)} N &\/*WY.inp.loc.hypo71\/zl.h | wc -l | awk N {print $1} N;' | tr -s "N" "'" | sh > ../../tmp/N-S-xcorr-hypo71.txt

#cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,20,1)=="P" \&\& substr(\$0,41,5)!="  O-C" {print substr(\$0,41,5)} N &\/*WY.inp.loc.hypo71\/zl.h;' | tr -s "N" "'" | sh > ../../tmp/res-P-xcorr-hypo71.txt
#cat ../../tmp/Inventoryclstevents.txt | awk '$0!="_" {print $0}' | sed -e 's;.*;awk N substr(\$0,52,1)=="S" \&\& substr(\$0,68,5)!="  O-C" {print substr(\$0,68,5)} N &\/*WY.inp.loc.hypo71\/zl.h;' | tr -s "N" "'" | sh > ../../tmp/res-S-xcorr-hypo71.txt

cat ../../tmp/Inventoryclstevents.txt | sed -e 's;.*;grep "Latitude" &/*.UUSS.inp.loc.hypo71/zl.h ;' | sh | awk '{print substr($0,19,3)+substr($0,22,8)/60}' > tmp1
cat ../../tmp/Inventoryclstevents.txt | sed -e 's;.*;grep "Longitude" &/*.UUSS.inp.loc.hypo71/zl.h ;' | sh | awk '{print substr($0,19,3)+substr($0,22,8)/60}' > tmp2
cat ../../tmp/Inventoryclstevents.txt | sed -e 's;.*;grep "Profondeur" &/*.UUSS.inp.loc.hypo71/zl.h ;' | sh | awk '{print substr($0,22,7)}' > tmp3
paste tmp1 tmp2 tmp3 > ../../tmp/XYZ-UUSS-hypo71.txt

cat ../../tmp/Inventoryclstevents.txt | sed -e 's;.*;grep "Latitude" &/*.enriched.loc.hypo71/zl.h ;' | sh | awk '{print substr($0,19,3)+substr($0,22,8)/60}' > tmp1
cat ../../tmp/Inventoryclstevents.txt | sed -e 's;.*;grep "Longitude" &/*.enriched.loc.hypo71/zl.h ;' | sh | awk '{print substr($0,19,3)+substr($0,22,8)/60}' > tmp2
cat ../../tmp/Inventoryclstevents.txt | sed -e 's;.*;grep "Profondeur" &/*.enriched.loc.hypo71/zl.h ;' | sh | awk '{print substr($0,22,7)}' > tmp3
paste tmp1 tmp2 tmp3 > ../../tmp/XYZ-NNK-hypo71.txt

cat ../../tmp/Inventoryclstevents.txt | sed -e 's;.*;grep "Latitude" &/*WY.inp.loc.hypo71/zl.h ;' | sh | awk '{print substr($0,19,3)+substr($0,22,8)/60}' > tmp1
cat ../../tmp/Inventoryclstevents.txt | sed -e 's;.*;grep "Longitude" &/*WY.inp.loc.hypo71/zl.h ;' | sh | awk '{print substr($0,19,3)+substr($0,22,8)/60}' > tmp2
cat ../../tmp/Inventoryclstevents.txt | sed -e 's;.*;grep "Profondeur" &/*WY.inp.loc.hypo71/zl.h ;' | sh | awk '{print substr($0,22,7)}' > tmp3
paste tmp1 tmp2 tmp3 > ../../tmp/XYZ-xcorr-hypo71.txt

