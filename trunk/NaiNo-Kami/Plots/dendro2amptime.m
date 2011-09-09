function [ax,ploted,hlegend]=dendro2amptime

global clust hpp hp
flag = 0 ;
nb=25 ;
maxi = 25 ;
excluded = ['b07';'lkw'];
cnt=0;
if exist('clust','var')==0 ;[clust] = clusters;end
pickcluster = 1:size(clust,1) ;
option = {'big-endian' 0 0 0 0 0 0 0 0 0 0} ;
%option = {'big-endian' 0 1 0 0 0 0 0 0 0 0} ; % avec filtre
windows = [5*6000 10*6000 10*6000];
filter = {4 12 50 'bandpass' 2};
compo = 'Z' ;
phase = 'PE' ;
ext = '.sac.linux' ;
tim = [] ; maxim = [] ;timenormaliz = [] ; timenormalizraw = [];ind = [];

for clst = pickcluster(1:end)
    if size(clust{clst},1)>2 %& size(clust{clst},1) < nb 
    %if size(clust{clst},1)>2 & clust{clst}{end,3}-clust{clst}{1,3}<=6   % &  clust{clst}{end,3}-clust{clst}{1,3} <= nb
        file = [char(clust{clst}{1,1}) '/' char(clust{clst}{1,2}) '.p'] ;
        file2 = [char(clust{clst}{end,1}) '/' char(clust{clst}{end,2}) '.p'] ;
        com= ['/Users/fredmassin/PostDoc_Utah/Processes/NaiNoKami_2/NNK/uuss2NNK.pl ' file ' all all > test.txt'];
        system(com);
        picks = char(importdata('test.txt'));
        sta = picks(:,93:95);
        picks = picks(:,17:22);
        [val,ind]=sort(str2num(picks),'ascend');        
        for i=min([max(ind)-1 maxi]):-1:1
            for ii=1:size(excluded,1);
                if length(ind)>=i+2
                    if strcmp(sta(ind(i),:),excluded(ii,:))==1
                        ind(i:i+1)=ind(i+1:i+2);
                    end
                end
            end
        end        
        sta = sta(ind(1:min([length(ind) maxi])),:);
        tmp='';
        for i=1:size(sta,1)
            tmp=[tmp;upper(sta(i,:));lower(sta(i,:))];
        end
        sta=tmp(1:2,:);
        
        disp(['[data,dataless]=NNK_getwf({' clust{clst}{1,4} '/events/' ';''*'';' reshape(sta',1,numel(sta)) ';' compo ';' phase '; ' ext '},option,windows,filter});'])
        [data,dataless]=NNK_getwf({[clust{clst}{1,4} '/events/'];'*';sta;compo;phase;ext},option,windows,filter);
        if size(data,5) > 0 & size(data,1) > 2
            [time,maximas,timenorm,timenormaliz2] = plot_NNKwfsmax(data(:,:,:,:,find(phase=='E')),dataless(:,:,:,:,find(phase=='E')));
            if numel(time) > 2
                cnt=cnt+1;
                tim(cnt,1:length(time)) = time(1,:);
                maxim(cnt,1:length(time)) =  maximas(1,:);
                timenormaliz(cnt,1:length(time)) = timenorm(1,:) ;
                timenormalizraw(cnt,1:length(time)) = timenormaliz2(1,:) ;
                %flag=flag+1;if flag==3;break;end
            end
        end
    end
end

[hpp] = resizepanels(hp,hpp,1);
h=[];

%nums = ones(size(timenormalizraw,1),size(timenormalizraw,2));
%nums(:,1) = 0;
for i=1:size(tim,1)
    x=find(maxim(i,:)==0);
    maxim(i,x)=NaN;
    timenormaliz(i,x)=NaN;
    timenormalizraw(i,x)=NaN;
    %nums(i,x) = 0 ;
end
[nums,timenormalizraw3] = hist(timenormalizraw',70) ;
nums = cumsum(nums);
nums = nums-repmat(min(nums),size(nums,1),1);
nums = nums./repmat(nanmax(nums),size(nums,1),1) ;

timenormalizraw2 = timenormalizraw(isnan(timenormalizraw)==0);
timenormalizraw2 = reshape(timenormalizraw2,1,numel(timenormalizraw2));
[nums2,timenormalizraw2] = hist(timenormalizraw2,70) ;
nums2 = cumsum(nums2);
nums2 = slidingmean(nums2,20);
nums2 = nums2-min(nums2);
nums2 = nums2/max(nums2);
%timenormalizraw',nums

a(3)=subplot(2,4,1,'parent',hpp(end));
plot(tim',maxim')
xlabel('Time to mainshock  [s]')
ylabel('Norm. ampl.');grid on

a(1)=subplot(2,4,3,'parent',hpp(end));
plot(timenormaliz',maxim')
xlabel('Norm. time to mainshock')
ylabel('Norm. ampl.');grid on



a(5) = subplot(2,4,5:8);
title(['Clusters ' num2str(round(pickcluster(1))) ' to ' num2str(round(pickcluster(end))) ' elt of N>' num2str(nb)]);
%whos timenormalizraw timenormalizraw3 nums
[AX,A1,A2]= plotyy(timenormalizraw3,nums,timenormalizraw2(2:end)',diff(nums2')./diff(timenormalizraw2'),'plot','plot') ;
axes(AX(1)) ; hold on ; plot(timenormalizraw2,nums2,'color','b','linewidth',2);hold off
set(A2,'linewidth',2,'linestyle','--');
xlabel('Normalized time')
%ylabel('Normalized amplitude');grid on
ylabel('N_{eq}');grid on
axes(AX(2))
ylabel('d(N_{eq})');grid on
linkaxes(AX,'x') ; 



a(4)=subplot(2,4,2,'parent',hpp(end));
hist(tim(maxim>0),50);
xlabel('Time to mainshock  [s]')
ylabel('N_{eq}');grid on

a(2)=subplot(2,4,4,'parent',hpp(end));
hist(timenormaliz(maxim>0),50);
xlabel('Norm. time to mainshock')
ylabel('N_{eq}');grid on



linkaxes(a(1:2),'x')
linkaxes(a(3:4),'x')