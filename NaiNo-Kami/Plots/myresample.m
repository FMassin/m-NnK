function [Y1out , X1out, Y2out , X2out ,Y3out , X3out ] = myresample(limx, Y1in , X1in, Y2in , X2in ,Y3in , X3in )

n=1500;
smot = 10 ;
type = 'moving';
meth = 'linear';
%meth = 'zoh';

                              if size(Y1in,1)<size(Y1in,2);Y1in=Y1in';X1in=X1in';end
if exist('Y2in','var')==1;    if size(Y2in,1)<size(Y2in,2);Y2in=Y2in';X2in=X2in';end;end
if exist('Y3in','var')==1;    if size(Y3in,1)<size(Y3in,2);Y3in=Y3in';X3in=X3in';end;end


Y1out=zeros(n,size(Y1in,2)); 
X1out=Y1out;
if exist('Y2in','var')==1
    Y2out=zeros(n,size(Y2in,2));
    X2out=Y2out;
end
if exist('Y3in','var')==1
    Y3out=zeros(n,size(Y3in,2));
    X3out =Y3out;
end
resampletime = linspace(limx(1),limx(2),n);
% datestr(min(resampletime)),datestr(max(resampletime))

for i=1:size(Y1in,2)
    
    ind = find(isnan(X1in(:,i))==0);
    Y1=Y1in(ind,i);
    X1=X1in(ind,i);
    limY1=[nanmin(Y1) nanmax(Y1)];

    if exist('Y2in','var')==1;
        ind = find(isnan(X2in(:,i))==0);
        Y2=Y2in(ind,i);
        X2=X2in(ind,i);
        limY2=[nanmin(Y2) nanmax(Y2)];
    end
    
    if exist('Y3in','var')==1
        ind = find(isnan(X3in(:,i))==0);
        Y3=Y3in(ind,i);
        X3=X3in(ind,i);
        limY3=[nanmin(Y3) nanmax(Y3)];
    end
    
    whos Y1  X1
    load plot_NNK.mat
    if length(param) >=9
        if param(9) == 1
            if exist('Y1','var')==1;ts=timeseries( Y1 , X1 ) ; res_ts=resample(ts,resampletime,meth); X1 =resampletime; Y1 =reshape(res_ts.data,1,n);end
            if exist('Y2','var')==1;ts=timeseries( Y2 , X2 ) ; res_ts=resample(ts,resampletime,meth); X2 =resampletime; Y2 =reshape(res_ts.data,1,n);end
            if exist('Y3','var')==1;ts=timeseries( Y3 , X3 ) ; res_ts=resample(ts,resampletime,meth); X3 =resampletime; Y3 =reshape(res_ts.data,1,n);end
        elseif param(9) == 0
            if exist('Y1','var')==1;ts=timeseries( Y1 , X1 ) ; res_ts=resample(ts,resampletime,meth); X1 =resampletime; Y1 =smooth(reshape(res_ts.data,1,n),type,smot);end
            if exist('Y2','var')==1;ts=timeseries( Y2 , X2 ) ; res_ts=resample(ts,resampletime,meth); X2 =resampletime; Y2 =smooth(reshape(res_ts.data,1,n),type,smot);end
            if exist('Y3','var')==1;ts=timeseries( Y3 , X3 ) ; res_ts=resample(ts,resampletime,meth); X3 =resampletime; Y3 =smooth(reshape(res_ts.data,1,n),type,smot);end
        end
    else
        if exist('Y1','var')==1;ts=timeseries( Y1 , X1 ) ; res_ts=resample(ts,resampletime,meth); X1 =resampletime; Y1 =smooth(reshape(res_ts.data,1,n),type,smot);end
        if exist('Y2','var')==1;ts=timeseries( Y2 , X2 ) ; res_ts=resample(ts,resampletime,meth); X2 =resampletime; Y2 =smooth(reshape(res_ts.data,1,n),type,smot);end
        if exist('Y3','var')==1;ts=timeseries( Y3 , X3 ) ; res_ts=resample(ts,resampletime,meth); X3 =resampletime; Y3 =smooth(reshape(res_ts.data,1,n),type,smot);end
    end
    
    if exist('Y1','var')==1;ind=logical(logical(Y1>=0.001).*logical(Y1<=limY1(2)));Y1=Y1(ind);X1=X1(ind);end
    if exist('Y2','var')==1;ind=logical(logical(Y2>=0.001).*logical(Y2<=limY2(2)));Y2=Y2(ind);X2=X2(ind);end
    if exist('Y3','var')==1;ind=logical(logical(Y3>=0.001).*logical(Y3<=limY3(2)));Y3=Y3(ind);X3=X3(ind);end
    
    if exist('Y1','var')==1; 
        Y1 =reshape(Y1,size(X1,1),size(X1,2)) ;
        Y1out(1:length(Y1),i)=Y1;
        X1out(1:length(Y1),i)=X1;
        for jj=2:size(X1out,1);if X1out(jj,i)<X1out(jj-1,i);Y1out(jj,i)=NaN;end;end
    end
    if exist('Y2','var')==1; 
        Y2 =reshape(Y2,size(X2,1),size(X2,2)) ;
        Y2out(1:length(Y2),i)=Y2;
        X2out(1:length(Y2),i)=X2;
        for jj=2:size(X2out,1);if X2out(jj,i)<X2out(jj-1,i);Y2out(jj,i)=NaN;end;end
    end
    if exist('Y3','var')==1; 
        Y3 =reshape(Y3,size(X3,1),size(X3,2)) ;
        Y3out(1:length(Y3),i)=Y3;
        X3out(1:length(Y3),i)=X3;
        for jj=2:size(X3out,1);if X3out(jj,i)<X3out(jj-1,i);Y3out(jj,i)=NaN;end;end
    end
end
if exist('Y1in','var')==0 ;Y1out=[];X1out=[];end
if exist('Y2in','var')==0 ;Y2out=[];X2out=[];end
if exist('Y3in','var')==0 ;Y3out=[];X3out=[];end

