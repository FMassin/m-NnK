function NNK_dtb

% Module principale d'operation sur les clusters.
%
% Tapez : NNK_dtb   pour lancer
%
% La fonction filtfilt peut etre deconnectee dans NNK_dtec_1 (lignes 20 21
% et 22).
%
% Frederick Massin, OVPF, 2008.




%%% Charge les parametres
NNK_takeparams ;        %
load NNK_params         %
%%%%%%%%%%%%%%%%%%%%%%%%%

clc ; NNK_disp_end(0,0) ;
time0 = clock ;

%%% Update cluster database catalog %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
system(['./NNK/NNK_dendro_1.pl ' path2dtb '/clst tmp/']);
dtbliste = char(importdata('tmp/tmp7.txt'));

for i=1:size(dtbliste,1)%1:size(dtbliste,1)
    %%% Prepare %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    path2clst=dtbliste(i,1:length(path2dtb)+33);
    system(['mkdir -p ' path2clst '/tmp']);
    system(['mkdir -p ' path2clst '/interf']);
    system(['mkdir -p ' path2clst '/stacks']);
    system(['mkdir -p ' path2clst '/values']);
    system(['mkdir -p ' path2clst '/source']);
   
    %%% Reading %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Strwfs,Strdataless,lesrecord,memKEVNM,memKNETWK,lesstat,lescompo]=NNK_getwf({[path2clst '/events/' ; '*' ; '*' ; 'Z' ; 'PS' ]});
    save([path2clst '/tmp/dtbwf.mat'],'pathtotmp','secutim','fen','Strwfs','lesrecord','seuilcluster','ncorrel','nbmast');

    %%% Cross correlate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load([path2clst '/tmp/dtbwf.mat'])
    [CCC,TS,Strwfs] = NNK_clust_corr([secutim+fen secutim+fen],Strwfs,2) ;
    save([path2clst '/tmp/dtbCCC.mat'],'CCC','TS','Strwfs','fen','secutim','codafen','lesrecord','seuilcluster','ncorrel')
    
    %%% Interfers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load([path2clst '/tmp/dtbCCC.mat'])
    %[interf] = NNK_clust_interf([secutim+fen secutim+fen],Strwfs) ;
    %save([path2clst '/tmp/dtbntfm.mat'],'interf','fen','secutim','codafen','lesrecord','seuilcluster','ncorrel')
    
    %%% Stacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load([path2clst '/tmp/dtbCCC.mat'])
    %[Stacks] = NNK_clust_stack([secutim+fen secutim+codafen],Strwfs) ;
    %save([path2clst '/tmp/dtbstcks.mat'],'Stacks','fen','secutim','codafen','lesrecord','seuilcluster','ncorrel')
    
end

%%% Pretty ending %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc ; NNK_disp_end(1,time0) ;



