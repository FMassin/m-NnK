function plot_GPSinNNK

global clust oldclust a fieldedit  hpp hp



%prend les bons clusters
if numel(oldclust)>0
    [hpp] = resizepanels(hp,hpp,1);
    h=[];
    [time] = taketime;
    [clust,oldclust,limx]=takeclust(oldclust);
    a(length(a)+1) = subplot(1,10,1:9,'parent',hpp(end));
    
else
    a=gca;
end

loc=pwd;if exist('pathname.mat','file') ==2 ;load pathname.mat ;  if exist(char(PathName),'dir')==7 ;cd(PathName);end;end
[FileName,PathName] = uigetfile('*.*','Select GPS file');
cd(loc);save pathname.mat PathName

file=fullfile(PathName,FileName);
if strcmp(file(end-2:end),'pos')==1
    [sta,T,Z,erz,X,erx,Y,ery,Zlab,Xlab,Ylab]=posfile2mat(file);
elseif strcmp(file(end-2:end),'csv')==1
    [sta,T,Z,erz,X,erx,Y,ery,Zlab,Xlab,Ylab]=csvfile2mat(file);
end

if exist('limx','var')==1
    ind = logical(logical(T>=limx(1)).*logical(T<=limx(2)));
    T=T(ind);
    Z=Z(ind);
    erz=erz(ind);
    X=X(ind);
    erx=erx(ind);
    Y=Y(ind);
    ery=ery(ind);
end

[a,h1,h2]=plotyy(T,Z,T,X,'parent',a(end));
axes(a(2));
hold on;
h3=plot(T,Y,'--');
hold off;
h=[h1 h2 h3];

set(get(a(1),'Ylabel'),'String',Zlab)
set(get(a(2),'Ylabel'),'String',[Xlab(1:end-3) ' and ' Ylab])
title(sta);
legend(h,Zlab,Xlab,Ylab);

linkaxes(a,'x');axis tight;
if exist('limx','var')==1
    set(a(end),'xlim',limx)
end
plot_gooddatetick(a)

