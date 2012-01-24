function plot_tilmeters

NN=1;
[T,R,n]=loadtilt('~/PostDoc_Utah/Datas/Tiltmeters/B205Xshort.txt');
tim(1:n, NN )=T ; tilt(1:n, NN )=R ; head(NN,:)='B205-X';
NN=2;
[T,R,n]=loadtilt('~/PostDoc_Utah/Datas/Tiltmeters/B205Yshort.txt'); 
tim(1:n, NN )=T ; tilt(1:n, NN )=R ; head(NN,:)='B205-Y';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NN=3;
% [T,R,n]=loadtilt('~/PostDoc_Utah/Datas/Tiltmeters/B945Xshort.txt'); 
% tim(1:n, NN )=T ; tilt(1:n, NN )=R ; head(NN,:)='B945-X';
% NN=4;
% [T,R,n]=loadtilt('~/PostDoc_Utah/Datas/Tiltmeters/B945Yshort.txt'); 
% tim(1:n, NN )=T ; tilt(1:n, NN )=R ; head(NN,:)='B945-Y';
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NN=5;
% [T,R,n]=loadtilt('~/PostDoc_Utah/Datas/Tiltmeters/B207Xshort.txt'); 
% tim(1:n, NN )=T ; tilt(1:n, NN )=R ; head(NN,:)='B207-X';
% NN=6;
% [T,R,n]=loadtilt('~/PostDoc_Utah/Datas/Tiltmeters/B207Yshort.txt'); 
% tim(1:n, NN )=T ; tilt(1:n, NN )=R ; head(NN,:)='B207-Y';
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

whos tilt
tim(tim==0)=NaN;
tilt = tilt-slidingmean(tilt,100);
tilt = tilt-slidingmean(tilt,10000);
% tilt = tilt./repmat(max(abs(tilt)),size(tilt,1),1) ;
figure
plot(tim,tilt,'linewidth',2) ; plot_gooddatetick; legend(head) ; tit='\bf{De-trended tilt [\mu radian]}'; ylabel(tit) ;plot_gooddatetick % ylim([-1 1]);

% for NN = 1:8
%     ax(NN)=subplot(8,1,NN);linkaxes(ax,'x')
%     plot(tim(:,NN),tilt(:,NN)-slidingmean(tilt(:,NN),100),'linewidth',2) ; plot_gooddatetick; legend(head(NN,:)) ; tit='\bf{De-trended tilt [radian]}'; ylabel(tit) ; ylim([-40 40]);plot_gooddatetick
% end

function [tim,tilt,n]=loadtilt(file)

data = load(file);

tim(:, 1 ) = datenum(num2str(data(:,1),'%13.2f'),'yyyymmddHHMMSS.FFF');
ind=logical(logical(tim>=datenum(2008,1,1)).*logical(tim<=datenum(2011,12,31))) ; 
data = data(ind,:);
n=size(data,1);
[~,ind] = sort(data(:,1));
tilt = data(:,2) ; 
 tim = datenum(num2str(data(ind,1),'%13.2f'),'yyyymmddHHMMSS.FFF');
 
 