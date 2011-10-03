function [ax,ploted,hlegend]=dendro2wfs(in)

global clust a

maxi = 6 ;
excluded = 'lkw';

if exist('a','var') == 0 ; a = gca ; end 
if exist('clust','var')==0 ;[clust] = clusters;end

if exist('in','var')==0
    axes(a(1)) ;
    [pickevent,pickcluster] = ginput(1);
else
    pickcluster = in ;
end
   
option = {'big-endian' 0 0 0 0 0 0 0 0 0 0} ;
%option = {'big-endian' 0 1 0 0 0 0 0 0 0 0} ; % avec filtre
windows = [5*6000 10*6000 10*6000];
filter = {4 12 50 'bandpass' 2};

file = [char(clust{round(pickcluster)}{1,1}) '/' char(clust{round(pickcluster)}{1,2}) '.p'] ;
file2 = [char(clust{round(pickcluster)}{end,1}) '/' char(clust{round(pickcluster)}{end,2}) '.p'] ;
com= ['/Users/fredmassin/PostDoc_Utah/Processes/NaiNoKami_2/NNK/uuss2NNK.pl ' file ' all all > ../tmp/test.txt'];
system(com);
%PC 090101122200 066.13 S  090101122200 000.00 C  090101122200 072.00 E  090101122200 118.13 YTP YTP
%PC 090101125000 089.09 S  090101125000 000.00                                               YLT YLT
%123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789
%         10        20        30        40        50        60        70        80        90           
picks = char(importdata('../tmp/test.txt'));
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
sta=tmp;
compo = 'Z' ; 
phase = 'PE' ; 
ext = '.sac.linux' ; 

disp(['[data,dataless]=NNK_getwf({' clust{round(pickcluster)}{1,4} '/events/' ';''*'';' reshape(sta',1,numel(sta)) ';' compo ';' phase '; ' ext '},option,windows,filter});'])
[data,dataless]=NNK_getwf({[clust{round(pickcluster)}{1,4} '/events/'];'*';sta;compo;phase;ext},option,windows,filter);

figure('name',['Cluster ' num2str(round(pickcluster))]);
[CCC,TS,Strwfs,Strdataless] = NNK_clust_corr([500;1000],data,2,phase,dataless);
%[ax,ploted,hlegend] = plot_NNKwfs(data,dataless);
[ax,ploted,hlegend] = plot_NNKwfs(Strwfs(:,:,:,:,find(phase=='E')),Strdataless(:,:,:,:,find(phase=='E')),clust{round(pickcluster)});
% title(['Cluster ' num2str(round(pickcluster))]);
% xlim([0 5]);
