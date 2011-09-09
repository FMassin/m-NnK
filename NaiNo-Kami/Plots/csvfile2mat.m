function [sta,T,Z,erz,X,erx,Y,ery,Zlab,Xlab,Ylab]=csvfile2mat(file)
com = ['sed -e ''s;,; ;g'' ' file ' | sed -e ''s;-; ;g'' | awk ''$1>1970 && $1<2070 && $7 >0 && $8 >0 && $9 >0 {print $1,$2,$3,$4,$5,$6,$7,$8,$9} '' > file '];
system(com);
hop =importdata('file');
[out]=split('/',file);
[out]=split('.',out(end,:));
sta=char(out(1,:));
T=datenum(hop(:,1),hop(:,2),hop(:,3)) ; % matlabdate
Z=hop(:,6)/1000;
erz=hop(:,9)/1000;
X=hop(:,4)/1000;
erx=hop(:,7)/1000;
Y=hop(:,5)/1000;
ery=hop(:,8)/1000;
Zlab = 'Up [m]';
Xlab = 'East [m]';
Ylab = 'North [m]';

