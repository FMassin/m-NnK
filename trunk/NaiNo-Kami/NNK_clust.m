function [path2clusters] = NNK_clust

% Module de clustering de seisme.
%
% Tapez : NNK_clust    pour lancer
%
% La fonction filtfilt peut etre deconnectee dans NNK_dtec_1 (lignes 20 21
% et 22).
%
% Frederick Massin, OVPF, 2008.




%%% Charge les parametres
NNK_takeparams ;        %
load NNK_params         %
%%%%%%%%%%%%%%%%%%%%%%%%%
clear B A pathtoNNKdtec
nbmast = 0;

%%% Reading %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Strwfs,Strdataless,lesrecord,memKEVNM,memKNETWK,lesstat,lescompo]=NNK_getwf;
save([pathtotmp '/clstwf.mat'],'pathtotmp','secutim','fen','Strwfs','lesrecord','seuilcluster','ncorrel','nbmast');

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
load([pathtotmp '/clstCC.mat']);
[listeclusters] = NNK_clust_cluster(links,nelt,lesrecord,nbmast)
save([pathtotmp '/clstClust.mat'],'listeclusters','path2dtb','stamaitre','sacextension','netcode') ;
clear CCC lesrecord seuilcluster nbmast

%%% Writing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load([pathtotmp '/clstClust.mat']) ;
[path2clusters] = NNK_clust2dtb(listeclusters,path2dtb,stamaitre,compo,sacextension,netcode) ;
save([pathtotmp '/clstClustpaths.mat'],'path2clusters','sacextension','path2dtb')

% %%% Working with the clusters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all
% NNK_dtb; % soon !











