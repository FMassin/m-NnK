#sh /Users/fredmassin/Pictures/webcam/PuOoo/PuOoo.sh
rm O-C*.? num*.?
ls /Users/fredmassin/Desktop/Fred@Dot/dtec/2008/*/*/*/*.UUSS.inp.loc.hypo71/zl.h > list
ADRESSES=`cat list`
for i in $ADRESSES; do
        CNT=$(($CNT+1))

	awk  '$5 =/P/ &&  ($9 ~ mer && $9 ~ O-C)  {print $9}' $i > tmp1p
	cat tmp1p >> O-C-1.p
	wc -l tmp1p | awk '{print $1}' >> num-1.p
	awk '$11 =/S/ && ($15 ~ mer && $15 ~ O-C) {print $15}' $i > tmp1s
        cat tmp1s >> O-C-1.s
	wc -l tmp1s | awk '{print $1}' >> num-1.s
	
        I=`echo $i | sed 's/UUSS\.inp\.loc/inp\.loc/'`
	awk  '$5 =/P/ &&  ($9 ~ mer && $9 ~ O-C)  {print $9}' $I > tmp2p
        cat tmp2p >> O-C-2.p
	wc -l tmp2p | awk '{print $1}' >> num-2.p
        awk '$11 =/S/ && ($15 ~ mer && $15 ~ O-C) {print $15}' $I > tmp2s
        cat tmp2s >> O-C-2.s
	wc -l tmp2s | awk '{print $1}' >> num-2.s

	I=`echo $i | sed 's/UUSS\.inp\.loc/inp\.enriched.loc/'`
	awk  '$5 =/P/ &&  ($9 ~ mer && $9 ~ O-C)  {print $9}' $I > tmp3p
        cat tmp3p >> O-C-3.p
	wc -l tmp3p | awk '{print $1}' >> num-3.p
        awk '$11 =/S/ && ($15 ~ mer && $15 ~ O-C) {print $15}' $I > tmp3s
        cat tmp3s >> O-C-3.s
	wc -l tmp3s | awk '{print $1}' >> num-3.s
done
rm tmp1p tmp1s tmp2p tmp2s tmp3p tmp3s

