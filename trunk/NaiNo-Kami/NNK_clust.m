function [path2clusters] = NNK_clust

% Module de clustering de seisme.
%
% Tapez : NNK_clust    pour lancer
%
% La fonction filtfilt peut etre deconnectee dans NNK_dtec_1 (lignes 20 21
% et 22).
%
% Frederick Massin, OVPF, 2008.




%%% Set parameters
if exist('setting','var')==0 
    if exist('settingfilename.mat','file')==2
        load settingsfilename.mat
    else
        disp('Please tell me the setting file name you want to use...\n by the way, next time you launch a NNK commande the same filename will be used without asking.\n Change the settings filename by specification in NNK commande (ex: NNK(''this-file-is-my-new-settings-file.m'') ')
        setting = input('Settings filename (no spaces):', 's');        
    end
end
save settingsfilename.mat setting
eval(setting);     % NNK_takeparams ; %
load NNK_params.mat%
%%%%%%%%%%%%%%%%%%%%
clear B A pathtoNNKdtec
nbmast = 0;



%%% Reading %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Strwfs,Strdataless,lesrecord,memKEVNM,memKNETWK,lesstat,lescompo]=NNK_getwf;
save([pathtotmp '/clstwf.mat'],'pathtotmp','secutim','fen','Strwfs','Strdataless','lesrecord','seuilcluster','ncorrel');%,'nbmast'

%%% Cross correlate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load([pathtotmp '/clstwf.mat'])
for i=1:size(stamaitre,1)
    [CCC] = NNK_clust_corr(secutim+fen,Strwfs(:,1,i,1,1),1) ;
    save([pathtotmp '/tmp1_' num2str(i) '.mat'],'CCC','lesrecord','seuilcluster','ncorrel','nbmast')
end
clear Strwfs

%%% Concatenate and reduce to linkage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[links,nelt,a]= NNK_CCCs2links(pathtotmp,stamaitre,seuilcluster,ncorrel,'tmp1_');
save([pathtotmp '/clstCC.mat'],'links','nelt','a','lesrecord','nbmast') ;

%%% Clustering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load([pathtotmp '/clstCC.mat']);
[listeclusters] = NNK_clust_cluster(links,nelt,lesrecord) ;
save([pathtotmp '/clstClust.mat'],'listeclusters','path2dtb','stamaitre','sacextension','netcode') ;
clear CCC lesrecord seuilcluster nbmast

%%% Writing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load([pathtotmp '/clstClust.mat']) ;
[path2clusters] = NNK_clust2dtb(listeclusters,path2dtb,stamaitre,compo,sacextension,netcode) ;
save([pathtotmp '/clstClustpaths.mat'],'path2clusters','sacextension','path2dtb')

% %%% Working with the clusters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all
% NNK_dtb; % soon !











