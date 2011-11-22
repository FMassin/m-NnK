function NNK_dtb(dtbliste)

% Module principale d'operation sur les clusters.
%
% Tapez : NNK_dtb   pour lancer
%
% La fonction filtfilt peut etre deconnectee dans NNK_dtec_1 (lignes 20 21
% et 22).
%
% Frederick Massin, OVPF, 2008.




%%% Set parameters
if exist('setting','var')==0 
    if exist('settingsfilename.mat','file')==2
        load  settingsfilename.mat
    else
        disp('Please tell me the setting file name you want to use...\n by the way, next time you launch a NNK commande the same filename will be used without asking.\n Change the settings filename by specification in NNK commande (ex: NNK(''this-file-is-my-new-settings-file.m'') ')
        setting = input('Settings filename (no spaces):', 's');        
    end
end
save settingsfilename.mat setting
eval(setting);     % NNK_takeparams ; %
load NNK_params.mat%
%%%%%%%%%%%%%%%%%%%%

clc ; NNK_disp_end(0,0) ;
time0 = clock ;

if exist('dtbliste','var')==0
    %%% Update cluster database catalog %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    system(['./NNK/NNK_dendro_1.pl ' path2dtb '/clst tmp/']);
    dtbliste = char(importdata('tmp/tmp7.txt'));
end


for i=1111:size(dtbliste,1) %52
    %%% Prepare %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    path2clst=dtbliste(i,1:length(path2dtb)+33);
    system(['mkdir -p ' fullfile(path2clst,'tmp')]);
    system(['mkdir -p ' fullfile(path2clst,'interf')]);
    system(['mkdir -p ' fullfile(path2clst,'stacks')]);
    system(['rm -r ' fullfile(path2clst,'stacks/*')]);
    system(['mkdir -p ' fullfile(path2clst,'values')]);
    system(['mkdir -p ' fullfile(path2clst,'source')]);
   
    %%% Reading %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Strwfs,Strdataless,lesrecord,memKEVNM,memKNETWK,lesstat,lescompo,mempha]=NNK_getwf({[path2clst '/events']; '*' ; '*' ; '*' ; 'PSE'});
    save([path2clst '/tmp/dtbwf.mat'],'pathtotmp','secutim','fen','Strwfs','lesrecord','seuilcluster','ncorrel');

    %%% Cross correlate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load([path2clst '/tmp/dtbwf.mat'])
    [CCC,TS,Strwfs,Strdataless] = NNK_clust_corr([secutim+fen secutim+codafen],Strwfs,2,mempha,Strdataless) ;
    save([path2clst '/tmp/dtbCCC.mat'],'CCC','TS','Strwfs','Strdataless','fen','secutim','codafen','lesrecord','seuilcluster','ncorrel')

    %%%% enrich data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     load([path2clst '/tmp/dtbCCC.mat'])
    [Strwfs,Strdataless] = NNK_enrich(Strwfs,Strdataless);
    save([path2clst '/tmp/dtbCCCenriched.mat'],'CCC','TS','Strwfs','Strdataless','fen','secutim','codafen','lesrecord','seuilcluster','ncorrel')

    %%% write Stacked and alligned %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load([path2clst '/tmp/dtbCCCenriched.mat'])
    % load([path2clst '/tmp/dtbCCC.mat'])
    [filesstacks] = NNK_wsac(Strwfs(end,:,:,:,:),Strdataless(end,:,:,:,:),fullfile(path2clst,'stacks'),fullfile(path2dtb,'stat'),[sacextension '.stack'],'',formatinp,mycomputer) ;
    [files] = NNK_wsac(Strwfs(1:end-1,:,:,:,find(mempha=='E')),Strdataless(1:end-1,:,:,:,find(mempha=='E')),fullfile(path2clst,'events'),fullfile(path2dtb,'stat'),[sacextension '.alligned'],'',formatinp,mycomputer) ;

    %%% Use stacked as master wf %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    system(['./NNK/NNK_stack2master.pl "' path2clst '" ']);
    
    %%% enrich pick file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    enrichinp([path2clst '/events/*'],'*WY.inp','unix');

    %%% Interfers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load([path2clst '/tmp/dtbCCC.mat'])
    %[interf] = NNK_clust_interf([secutim+fen secutim+fen],Strwfs) ;
    %save([path2clst '/tmp/dtbntfm.mat'],'interf','fen','secutim','codafen','lesrecord','seuilcluster','ncorrel')

    disp(['Cluster ' path2clst ' done'])
end

%%% Pretty ending %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clc ; NNK_disp_end(1,time0) ;






