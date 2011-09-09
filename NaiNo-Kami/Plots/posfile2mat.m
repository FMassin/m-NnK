function [sta,T,Z,erz,X,erx,Y,ery,Zlab,Xlab,Ylab]=posfile2mat(file)
if exist('file','var')==0;file='/Users/fredmassin/PostDoc_Utah/Datas/GPS/wlwy.uusatrg.pos';end
hop =importdata(file);
% hop.textdata(1,:) =      'sta'    'mjd'    'North(m)'    'dN'    'East(m)'    'dE'    'Up(m)'    'dU'
sta=char(hop.textdata(2,1));
T=mjd2date(hop.data(:,1)) ; % matlabdate
Z=hop.data(:,6);
erz=hop.data(:,7);
X=hop.data(:,4);
erx=hop.data(:,5);
Y=hop.data(:,2);
ery=hop.data(:,3);
Zlab = char(hop.textdata(1,7));
Xlab = char(hop.textdata(1,5));
Ylab = char(hop.textdata(1,3));

Zlab(find(Zlab=='(')) = '[';
Zlab(find(Zlab==')')) = ']';
Xlab(find(Xlab=='(')) = '[';
Xlab(find(Xlab==')')) = ']';
Ylab(find(Ylab=='(')) = '[';
Ylab(find(Ylab==')')) = ']';
