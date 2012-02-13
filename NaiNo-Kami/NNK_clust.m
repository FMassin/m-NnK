function [path2clusters] = NNK_clust(setting)
%
% HELP FOR MODULE NNK_clust.m
%
% NNK_clust is a module for event clustering.
%
% Type : NNK_clust    to launch
%        NNK_clust('your_settings_file') to launch with a specified
%                                         settings file (truncate '.m')
%
% Run example: NNK_clust('NNK_takeparams_example')
%
% The module execute 5 tasks before launching another module (cf NNK_dtb).
% The 5 tasks are : 
%  1- data reading (line 55)
%  2- calculation of cross-correlation (line 65)
%  3- finding doublets as defined in the settings file (line 75)
%  4- partitional clustering of doublets into multiplets (line 85)
%  5- writting multiplets in database (line 95)
%
% The results of each task can be previewed with the commented command lines
% that follow tasks.
% The results of each tasks is save in the tmp directory defined in the 
% settings file. 
%
% An example of settings file is provided : NNK_takeparams_example.m
%
% Extension : 
% type help NNK_dtb  to known on clusters processing
%
% Frederick Massin, UofU, 2011.



%%% Set parameters
if exist('setting','var')==0 
    if exist('settingsfilename.mat','file')==2
        load  settingsfilename.mat
    else
        disp(['Please tell me the setting file name you want to use ...    ' ; ...
              'Next time you launch a NNK commande the same filename       ' ; ...
              'will be used without asking. Change the settings filename by' ; ...
              'specification in NNK commande (ex:                          ' ; ...
              'NNK(''this-file-is-my-new-settings-file'')                    ' ]); 
        setting = input('Settings filename (no spaces, no .m):', 's');        
    end
end
save settingsfilename.mat setting
eval(setting);     % 
load NNK_params.mat%
%%%%%%%%%%%%%%%%%%%%
clear B A pathtoNNKdtec
nbmast = 0;



%%% 1 Reading %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Strwfs,Strdataless,lesrecord,memKEVNM,memKNETWK,lesstat,lescompo]=NNK_getwf;
save([pathtotmp '/clstwf.mat'],'pathtotmp','secutim','fen','Strwfs','Strdataless','lesrecord');
%%% Plot the waveforms : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;load NNK_params.mat;load([pathtotmp '/clstwf.mat']);for i=1:size(stamaitre,1);ax(i)=subplot(1,2,i);hold on;m=[0 0];for j=1:size(Strwfs,1);imagesc(1:length(Strwfs{j,1,i}),j,Strwfs{j,1,i}'/max(abs(Strwfs{j,1,i})));end;axis tight;box on;title(stamaitre(i,:));end;linkaxes(ax,'xy')





%%% 2 Cross correlate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load([pathtotmp '/clstwf.mat'])
for i=1:size(stamaitre,1)
    [CCC] = NNK_clust_corr(secutim+fen,Strwfs(:,1,i,1,1),1) ;
    save([pathtotmp '/tmp1_' num2str(i) '.mat'],'CCC','lesrecord')
end ; clear Strwfs
%%% Plot the cross correlations maxima : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load NNK_params.mat;figure;for i=1:size(stamaitre,1);eval(['load ' pathtotmp '/tmp1_' num2str(i) '.mat']);ax(i)=subplot(1,2,i);hold on;for j=1:length(CCC);imagesc(1:length(CCC),repmat(j,length(CCC),1),CCC{j});end;axis image;colorbar;end;linkaxes(ax,'xy')


%%% 3 Concatenate and reduce to linkage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[links,nelt,a,lesrecord]= NNK_CCCs2links(pathtotmp,stamaitre,seuilcluster,ncorrel,'tmp1_');
save([pathtotmp '/clstCC.mat'],'links','nelt','a','lesrecord') ;
%%% Plot the links : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load NNK_params.mat;load([pathtotmp '/clstCC.mat']);figure;hold on;for i=1:length(links);plot(find(links{i}>0),i,'s');end;axis image;box on;
%%% Plot the linked waveforms : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load NNK_params.mat;load([pathtotmp '/clstCC.mat']);load([pathtotmp '/clstwf.mat']);figure;for i=1:size(stamaitre,1);ax(i)=subplot(1,2,i);hold on;cnt=0;for j=1:length(links);for k=[j find(links{j}>0)];cnt=cnt+1;imagesc(1:length(Strwfs{k,1,i}),cnt,Strwfs{k,1,i}'/max(abs(Strwfs{k,1,i})));end;cnt=cnt+1;end;box on;axis tight;title(stamaitre(i,:));end;linkaxes(ax,'xy')



%%% 4 Clustering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load([pathtotmp '/clstCC.mat']);
[listeclusters] = NNK_clust_cluster(links,nelt,lesrecord) ;
save([pathtotmp '/clstClust.mat'],'listeclusters','path2dtb','stamaitre','sacextension','netcode') ;
clear CCC lesrecord seuilcluster nbmast
%%% Plot the clusters : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load NNK_params.mat;load([pathtotmp '/clstClust.mat']);figure;hold on;for i=1:length(listeclusters);t=datenum(listeclusters{i}(:,end-15:end-2),'yyyymmddHHMMSS');plot(t,repmat(i,1,length(t)),'-','color',[0.7 0.7 0.7],'linewidth',2);plot(t,i,'ok'),plot(t,i,'.g');end;axis tight;box on;set(gca,'xticklabel',datestr(get(gca,'xtick'),'HH:MM'))
%%% Plot the clustered waveforms : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load NNK_params.mat;load([pathtotmp '/clstClust_tmp.mat']);load([pathtotmp '/clstwf.mat']);figure;for i=1:size(stamaitre,1);ax(i)=subplot(1,2,i);hold on;cnt=0;for j=1:length(links);for k=[j find(links{j}>0)];cnt=cnt+1;imagesc(1:length(Strwfs{k,1,i}),cnt,Strwfs{k,1,i}'/max(abs(Strwfs{k,1,i})));end;cnt=cnt+1;end;box on;axis tight;title(stamaitre(i,:));end;linkaxes(ax,'xy')

%%% 5 Writing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load([pathtotmp '/clstClust.mat']) ;
[path2clusters] = NNK_clust2dtb(listeclusters,path2dtb,stamaitre,compo,sacextension,netcode) ;
dtbliste ='';for i=1:length(path2clusters);if size(path2clusters{i},1)>0;dtbliste = [dtbliste ; path2clusters{i}(1,:)] ;end;end
save([pathtotmp '/clstClustpaths.mat'],'path2clusters','sacextension','path2dtb','dtbliste');

%%% Working with the clusters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load([pathtotmp '/clstClustpaths.mat'])
dtbliste ='' ; for i=1:length(path2clusters) ; if size(path2clusters{i},1) >0 ; dtbliste = [dtbliste ; path2clusters{i}(1,:)];end;end
NNK_dtb(dtbliste); 












