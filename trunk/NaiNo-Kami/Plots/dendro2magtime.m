function [ax,ploted,hlegend]=dendro2magtime

global clust hpp hp fieldedit oldclust

[time] = taketime ; 
[clust,oldclust,limx]=takeclust(oldclust);

nb=[2 +inf] ;
cnt=0;
if exist('clust','var')==0 ;[clust] = clusters;end
pickcluster = 1:size(clust,1) ;

for clst = pickcluster(1:end)
    if size(clust{clst},1)>2 %& size(clust{clst},1) < nb 
        cnt=cnt+1;
    end
end
tim = zeros(cnt,300) ;maxim=tim;time2main=tim;normtime=tim';cumE=tim';Rnormtime=tim';cumEq=tim';DcumE=tim';DcumEq=tim';




cnt=0;
for clst = pickcluster(1:end)
    if size(clust{clst},1)> nb(1) & size(clust{clst},1) < nb(2) 
        cnt=cnt+1;
        
        test=cell2mat(clust{clst}(:,25))';
        test(test==-9.99) = NaN ; 
        test = 10.^(1.1*test+18.4);
        
        [~,main] = nanmax(test) ;
        maxim(cnt,1:size(clust{clst},1)) = (test-nanmin(test))./diff(minmax(test)) ; 
        
        test = cell2mat(clust{clst}(:,3))'*24*60*60;
        tim(cnt,1:size(clust{clst},1)) = test - nanmin(test);
        
        test = (test-test(main)); %test = test./nanmax(abs(test));
        test(isnan(test)==1) = 0 ;
        time2main(cnt,1:size(clust{clst},1)) = test ;
                
        normtime(1:size(clust{clst},1),cnt) = tim(cnt,1:size(clust{clst},1))./diff(minmax(tim(cnt,1:size(clust{clst},1)))) ;
            
        test = 10.^(1.1*cell2mat(clust{clst}(:,25))+18.4);
        test(isnan(test)==1) = 0;
        testime = normtime(1:size(clust{clst},1),cnt);
        [testime,test]=cumhist(testime,test,300) ;
        test = cumsum(test);%test(end-2:end)=test(end-2);
        test = (test-nanmin(test))./diff(minmax(test')) ;
        cumE(1:length(test),cnt) = test ;
        Rnormtime(1:length(testime),cnt) = testime ;
        DcumE(2:length(test),cnt) = diff(test)./diff(testime) ;
        
        testime = normtime(1:size(clust{clst},1),cnt);
        [testime,test]=cumhist(testime,ones(length(testime),1),300) ;
        test = cumsum(test);%test(end-2:end)=test(end-2);
        test = (test-nanmin(test))./diff(minmax(test')) ;        
        cumEq(1:length(test),cnt) = test ;
        DcumEq(2:length(test),cnt) = diff(test)./diff(testime) ;
    end
end


[hpp] = resizepanels(hp,hpp,1);
normtime(normtime<=0.001) = NaN;
normtime(1,:)=0;
cumEq(cumEq==0)=NaN;
cumEq(1,:) = 0 ; 
cumE(cumE==0)=NaN;
cumE(1,:) = 0 ; 


%layout %%%%%%%%%%%%%%%%%%%%%%%%%%%
a(3)=subplot(3,4,[3],'parent',hpp(end));
a(4)=subplot(3,4,[4],'parent',hpp(end));
a(11)=subplot(3,4,[7],'parent',hpp(end));
a(21)=subplot(3,4,[11],'parent',hpp(end));
a(12)=subplot(3,4,[8],'parent',hpp(end));
a(22)=subplot(3,4,[12],'parent',hpp(end));
a(6) =subplot(2,4,1:2,'parent',hpp(end));
a(5) =subplot(2,4,5:6,'parent',hpp(end));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% recurrence time analysis %%%%%%%%
axes(a(3))
semilogx(tim',maxim','o','Parent',a(3))
xlabel({'\bf Time [s]'})
ylabel({'\bf Norm. Mo'});
set(a(3),'XTick',[10^0  10^2 10^4 10^6 10^8 10^10],'XminorTick','off');grid on

axes(a(4))
dmax = get(a(3),'xlim');
[Y,X]=hist(tim(maxim>0),logspace(0,10,200));Y(1)=0;
semilogx(X,Y,'Parent',a(4))
% %[Y2,X2]=diffhist(tim,logspace(0,10,70),maxim);
% [Rx,Ry]=cumhist(tim,maxim,1000); 
% Ry(1) =0;Ry=Ry.^(1/3);
% Y2 = fft(Ry);
% Y2(1)=[];
% n=length(Y2);
% power = abs(Y2(1:floor(n/2))).^2;
% nyquist = 1/2;
% freq = (1:n/2)/(n/2)*nyquist;
% period=1./freq;
% X2 = period ;
% whos X2 Y2
%hold on; semilogx(X2(1:400),Y2(1:400),'-r','Parent',a(4)); hold off
xlabel({'\bf Time [s]'})
ylabel({'\bf N_{eq}'});grid on
set(a(4),'XTick',[10^0  10^2 10^4 10^6 10^8 10^10],'XminorTick','off');grid on
linkaxes(a(3:4),'x')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% rate analyses %%%%%%%%%%%%%%%

d= 0.01 ; bins=-d:d:1+d;
for i=1:size(cumEq,1)
    [matr(1:length(bins),i),~]=histc(cumEq(i,:),bins);
    matr(1:length(bins),i) = smooth(matr(1:length(bins),i),5);
end
axes(a(6))
%[AX,A1,A2]= plotyy(Rnormtime,cumEq,Rnormtime(1:end-5,1),nanmean(DcumEq(1:end-5,:),2),'plot','plot','Parent',a(6)) ;
[AX,A1,A2]= plotyy(1,1,Rnormtime(1:end-5,1),smooth(nanmean(DcumEq(1:end-5,:),2),5),'plot','plot','Parent',a(6)) ;
axes(AX(1)) ; 
surface(Rnormtime(:,1),bins+d/2,zeros(size(matr)),(matr.^0.5),'Parent',AX(1),'FaceColor','texturemap','EdgeColor','none');
hold on ; plot(Rnormtime(:,1),smooth(nanmedian(cumEq,2),5),'color','k','linewidth',2,'Parent',AX(1));hold off
set(A2,'linewidth',2,'linestyle','-');
set(AX(1),'Ydir','normal','xlim',[0 1],'ylim',[0 1],'ytick',[0 0.5 1]);
xlabel({'\bf Normalized time'})
ylabel({'\bf N/N_{max}'});grid on
axes(AX(2))
ylabel({'\bf d(N/N_{max})'});grid on
linkaxes(AX,'x') ; 
title([num2str(cnt) '/' num2str(round(pickcluster(end))) ' clusters ' num2str(nb(1)) '<N<' num2str(nb(2))]);
set(AX(1),'Layer','top');

for i=1:size(cumEq,1)
    [matr(1:length(bins),i),~]=histc(cumE(i,:),bins);
    matr(1:length(bins),i) = smooth(matr(1:length(bins),i),5);
end
axes(a(5))
%[AX,A1,A2]= plotyy(Rnormtime,cumE,Rnormtime(1:end-5,1),nanmean(DcumE(1:end-5,:),2),'plot','plot','Parent',a(5)) ;
[AX,A1,A2]= plotyy(1,1,Rnormtime(1:end-5,1),smooth(nanmean(DcumE(1:end-5,:),2),5),'plot','plot','Parent',a(5)) ;
axes(AX(1)) ; 
surface(Rnormtime(:,1),bins+d/2,zeros(size(matr)),(matr.^0.5),'Parent',AX(1),'FaceColor','texturemap','EdgeColor','none');
hold on ; plot(Rnormtime(:,1),smooth(nanmedian(cumE,2),5),'color','k','linewidth',2,'Parent',AX(1));hold off
set(A2,'linewidth',2,'linestyle','-');
set(AX(1),'Ydir','normal','xlim',[0 1],'ylim',[0 1],'ytick',[0 0.5 1]);
xlabel({'\bf Normalized time'})
ylabel({'\bf Mo/Mo_{max}'});grid on
axes(AX(2))
ylabel({'\bf d(Mo/Mo_{max})'});grid on
linkaxes(AX,'x') ; 
set(AX(1),'Layer','top');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% after/fore shock sequence analyse %%%%%%%
bins = logspace(0,10,100) ;
axes(a(11))
semilogx(-1*time2main',maxim','o','Parent',a(11))
xlabel({'\bf Time to mainshock [s]'})
ylabel({'\bf Norm. Mo'});grid on
set(a(11),'XDir','reverse')
%view(180,-90)
axes(a(21))
[Y,X]=hist(-1*time2main(time2main~=0),sort(bins));Y(1) = 0 ;
semilogx(X,Y,'Parent',a(21))
xlabel({'\bf Time to mainshock [s]'})
ylabel({'\bf N_{eq}'});grid on
set(a(11),'XTick',[10^0  10^2 10^4 10^6 10^8 10^10],'XminorTick','off','XDir','reverse');grid on
set(a(21),'XTick',[10^0  10^2 10^4 10^6 10^8 10^10],'XminorTick','off','XDir','reverse');grid on
%view(180,-90)

axes(a(12))
semilogx(time2main,maxim,'o','Parent',a(12))
ylabel({'\bf Norm. Mo'});grid on
axes(a(22))
hold on
[Y,X]=hist(-1*time2main(time2main~=0),sort(bins));Y(1) = 0 ;
semilogx(X,Y,'color',[0.6 0.6 0.6],'Parent',a(22))
[Y,X]=hist(time2main(time2main~=0),sort(bins));Y(1) = 0 ;
semilogx(X,Y,'Parent',a(22))
hold off
ylabel({'\bf N_{eq}'});grid on
set(a(12),'YAxisLocation','right','XScale','log','XTick',[10^0  10^2 10^4 10^6 10^8 10^10],'XminorTick','off');grid on
set(a(22),'YAxisLocation','right','XScale','log','XTick',[10^0  10^2 10^4 10^6 10^8 10^10],'XminorTick','off');grid on;box on
linkaxes(a([11 12 21 22]),'x')
set(a(21:22),'ylim',minmax([get(a(21),'ylim') get(a(22),'ylim')]))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bins = linspace(-1,1,200) ;
% a(11)=subplot(2,4,3:4,'parent',hpp(end));
% plot(-1*time2main',maxim','o')
% xlabel({'\bf Norm. time to mainshock'})
% ylabel({'\bf Norm. 10^{M}'});grid on
% a(21)=subplot(2,4,7:8,'parent',hpp(end));
% [Y,X]=hist(-1*time2main(time2main~=0),sort(bins));Y(1) = 0 ;
% plot(X,Y)
% xlabel({'\bf Norm. time to mainshock [-1]'})
% ylabel({'\bf N_{eq}'});grid on
% linkaxes(a([11 21]),'x')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a(11)=subplot(2,4,3:4,'parent',hpp(end));
% plot(time2main',maxim','o')
% xlabel({'\bf Norm. time to mainshock'})
% ylabel({'\bf Norm. Magn.'});grid on
% a(21)=subplot(2,4,7:8,'parent',hpp(end));
% hist(time2main(time2main~=0),100);
% xlabel({'\bf Norm. time to mainshock'})
% ylabel({'\bf N_{eq}'});grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





