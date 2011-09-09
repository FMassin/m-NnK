function map2source(in)

global clust oldclust a dates1 dates2 cumnums clustratio uniqratio neoratio endratio fieldedit   hpp hp indeq indices

if exist('in','var') ==0 
    [LAT,LON,DEP,IND]=ginputm(1);%scales
else
    LAT=0;LON=0;DEP=0;IND=in;
end
[poub,answer]=system(['./distance.pl ' num2str([ LON LAT LON+1 LAT ])]);
kmlon=abs(str2num(answer));
[poub,answer]=system(['./distance.pl ' num2str([ LON LAT LON LAT+1 ])]);
kmlat=abs(str2num(answer));

%prepare les truc a ploter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[time,indeq,lims] = taketime ;
[clust,oldclust,poub,indices]=takeclust(oldclust);
[X,Y,Z,X1,X2,Y1,Y2,Ylat,Maxi,erX,erY,erZ,fp,slip,fault] = filtclust(clust,indeq,lims);
X=X(:,:,1);Y=Y(:,:,1);Z=Z(:,:,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   

% sort %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isnan(IND)==1
    dist = (((nanmean(X)-LON)*kmlon).^2+((nanmean(Y)-LAT)*kmlat).^2+(nanmean(Z)-DEP).^2).^0.5;
    [dist,order]=sort(dist,'ascend');
    IND = 1;
elseif isnan(IND) == 0
    order =1:length(clust);
    dist = (((nanmean(X)-nanmean(X(:,IND)))*kmlon).^2+((nanmean(Y)-nanmean(Y(:,IND)))*kmlat).^2+(nanmean(Z)-nanmean(Z(:,IND))).^2).^0.5;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% SET plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[hpp] = resizepanels(hp,hpp,1);
ax(1) = subplot(10,3,[5:3:30],'parent',hpp(end));
ax(2) = subplot(10,3,[6:3:30],'parent',hpp(end));
ax(3) = subplot(10,3,[13:3:30],'parent',hpp(end));
ax(4) = subplot(10,3,[4:3:10],'parent',hpp(end));
IND0=IND;
save IND.mat IND dist order IND0 ax;

uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[1/30 9/10 12/30 1/10],...
    'String','<=<','TooltipString','Show previous cluster','Callback','plot_oneclust(1);');
uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[17/30 9/10 12/30 1/10],...
    'String','>=>','TooltipString','Show next cluster','Callback','plot_oneclust(2);');

uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[29/30 0 1/30 2/6],...
    'String','v','TooltipString','Show previous solution','Callback','plot_oneclust(3);');
uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[29/30 2/6 1/30 1/9],...
    'CData',geticon('fpplot'),'TooltipString','See fpplot output file','Callback','plot_oneclust(6);');
uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[29/30 (2/6)+1/9 1/30 1/9],...
    'CData',geticon('trace'),'TooltipString','See stacked waveforms','Callback','plot_oneclust(10);');
uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[29/30 (2/6)+2/9 1/30 1/9],...
    'CData',geticon('reload'),'TooltipString','Reload current source','Callback','plot_oneclust(11);');
uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[29/30 4/6 1/30 2/6],...
    'String','^','TooltipString','Show next solution','Callback','plot_oneclust(5);');

uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[13/30 9/10 1.5/60 1/10],...
    'CData',geticon('DC'),'TooltipString','Record current solution as DC','Callback','plot_oneclust(4);');
uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[13/30+(1.5/60) 9/10 0.5/60 1/10],...
    'String','''','TooltipString','Record current solution as DC, selecting the other fult plane','Callback','plot_oneclust(-4);');

uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[14/30 9/10 1/30 1/10],...
    'String','nDC','TooltipString','Record current solution as non-DC','Callback','plot_oneclust(7);');
uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[15/30 9/10 1/30 1/10],...
    'CData',geticon('isotrop'),'TooltipString','Record current solution as possibly isotropic','Callback','plot_oneclust(8);');
uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[16/30 9/10 1/30 1/10],...
    'CData',geticon('clvd'),'TooltipString','Record current solution as possibly CLVD','Callback','plot_oneclust(9);');

plot_oneclust(0);
