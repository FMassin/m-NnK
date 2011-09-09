function NNK_stats

% ls -d  /data/4Fred/WF/WY/dtec/*/*/*/* > lst.tmp
system('./stat.pl  "/data/4Fred/WF/WY/dtec"'); %>total-vs-clustered.tmp



%lst = char(importdata('lst.tmp.old'));
lst = char(importdata('tmp.txt'));
dates1=datenum(lst(:,end-15:end-2),'yyyymmddHHMMSS');

%lst = importdata('total-vs-clustered.tmp.old');
lst = importdata('statistic.txt');
dates2 = char(lst.textdata) ; 
dates2 = datenum(dates2(:,end-15:end-2),'yyyymmddHHMMSS');

nums = lst.data ;
for i=1:size(dates2,1)
    inds = [max([i-100 1]) : i] ; 
    clustratio(i) = sum(nums(inds,2))/length(inds);
    uniqratio(i) = sum(nums(inds,1))/length(inds);
end

% plot(dates2,clustratio)
[AX,H1,H2]=plotyy(dates2,clustratio,dates1,1:length(dates1),'plot','plot');
set(get(AX(2),'Ylabel'),'String','Cumulated number of earthquake') 
set(get(AX(1),'Ylabel'),'String','Ratio clustered / total seismicity') 
% set(H1,'LineStyle','none','marker','o')
% set(H2,'LineStyle','none','marker','o')
set(H1,'linewidth',2,'marker','o')
set(H2,'linewidth',2)
lims = get(AX(2),'ylim');
set(AX(2),'ytick',[lims(1):abs(diff(lims))/100:lims(2)])
linkaxes(AX,'x')
plot_gooddatetick(AX(1),'x',1);
plot_gooddatetick(AX(2),'x',0);



% plot(dates1,1:length(dates),'ob');
% plot_gooddatetick(gca,'x',0);
% ylabel('Cumulated number of earthquake')


% set(gca,'YAxisLocation','right')
% xlim(datenum(['20100117';'20100223'],'yyyymmdd')); plot_gooddatetick(gca,'x',0);
%  xlim(datenum(['20081226';'20090111'],'yyyymmdd')); plot_gooddatetick(gca,'x',0);

% load total-vs-clustered.tmp.old
% day = statistics(:,1)+100.1;day=num2str(day);day=day(:,2:3)
% month = statistics(:,2)+100.1;month=num2str(month);month=month(:,2:3)
% year = statistics(:,3);year=num2str(year);
% dates=datenum([day month year],'ddmmyyyy')
% 
% plot(dates,statistics(:,5)./statistics(:,4),'ob');
% plot_gooddatetick(gca,'x',0);
% 
% 
% % xlim(datenum(['20080101';'20100223'],'yyyymmdd'));
% % plot_gooddatetick(gca,'x',0);ylim([0 1]);
% % set(gca,'YAxisLocation','right')