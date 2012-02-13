function NNK_dtb(dtbliste)
%
% HELP FOR MODULE NNK_dtb.m
%
% NNK_dtb is a module for clusters processing. NNK_dtb require results 
% outputed from NNK_clust.
%
% Type : NNK_dtb(liste_of_cluster_root_paths)    to launch
%
% Run example after NNK_clust ran: 
%        load tmp/clstClustpaths.mat;NNK_dtb(dtbliste);
%
% the results of clusters processing are written in the cluster root path 
% (database path /year/month/day/cluster first event/). The database path is
% defined in the settings  file.
%
% The NNK_dtb module execute 8 tasks:
%  1- creation of results directories in the cluster root path (line 70)
%  2- cluster's data reading (line 80)
%  3- calculation of cross-correlation on all components, allign waveforms, 
%     and stack (line 90)
%  4- calculation of coda interferograms, results in "interf" (line 100) 
%            - 4 is commented and still in devellopement -
%  5- update missing waveforms with normalized stack (line 110)
%  6- write alligned pick file (hypo71 format) and alligned-windowed 
%     waveforms in the "event" directories and write the stacked full 
%     waveforms in the "stacks" directory of the cluster root path (line 120)
%  7- place stacked waveform as cluster's waveforms for future upgrade of 
%     the cluster database (line 130)
%            - 7 is commented and imply a delicate choice - 
%  8- create hybrid pick file with enriched picks in the "event" 
%     directories (line 140) 
%
% The results of each tasks is save in the cluster's tmp directory defined 
% in task 1. 
% 
% Future update: previews of the results of each task with some commented 
% command lines that follow tasks.
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


for i=438:438 % 1:size(dtbliste,1) % 1111 52
    %%% Prepare %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    path2clst=dtbliste(i,1:length(path2dtb)+33);
    [~,~,~]=mkdir(fullfile(path2clst,'tmp'));   [~,~,~]=mkdir(fullfile(path2clst,'interf'));
    [~,~,~]=rmdir(fullfile(path2clst,'stacks'));[~,~,~]=mkdir(fullfile(path2clst,'stacks'));
    [~,~,~]=mkdir(fullfile(path2clst,'values'));[~,~,~]=mkdir(fullfile(path2clst,'source'));
   
    
    
    

    %%% Reading %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Strwfs,Strdataless,lesrecord,memKEVNM,memKNETWK,lesstat,lescompo,mempha]=NNK_getwf({[path2clst '/events']; '*' ; '*' ; '*' ; 'PSE'});
    save([path2clst '/tmp/dtbwf.mat'],'pathtotmp','secutim','fen','Strwfs','lesrecord','seuilcluster','ncorrel');

    
    
    
    
    
    
    %%% Cross correlate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load([path2clst '/tmp/dtbwf.mat'])
    [CCC,TS,Strwfs,Strdataless] = NNK_clust_corr([secutim+fen secutim+codafen],Strwfs,2,mempha,Strdataless) ;
    save([path2clst '/tmp/dtbCCC.mat'],'CCC','TS','Strwfs','Strdataless','fen','secutim','codafen','lesrecord','seuilcluster','ncorrel')

    
    
    
    
    
    %%% Coda Interf %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load([path2clst '/tmp/dtbCCC.mat'])
%     [interf] = NNK_clust_interf([secutim+fen secutim+fen],Strwfs) ;
%     save([path2clst '/tmp/dtbntfm.mat'],'interf','fen','secutim','codafen','lesrecord','seuilcluster','ncorrel')
    
    
    
    
    
    
    %%%% enrich data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load([path2clst '/tmp/dtbCCC.mat'])
    clc;disp(['Cluster ' num2str(i) '/' num2str(size(dtbliste,1))]);disp(['... ' path2clst(end-33:end)])
    [Strwfs,Strdataless] = NNK_enrich(Strwfs,Strdataless);
    save([path2clst '/tmp/dtbCCCenriched.mat'],'CCC','TS','Strwfs','Strdataless','fen','secutim','codafen','lesrecord','seuilcluster','ncorrel')

    
    
    
    
    %%% write Stacked and alligned %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load([path2clst '/tmp/dtbCCCenriched.mat'])
    % load([path2clst '/tmp/dtbCCC.mat'])
    system(['rm -r ' fullfile(path2clst,'stacks/*')]);
    clc;disp(['Cluster ' num2str(i) '/' num2str(size(dtbliste,1))]);disp(['... ' path2clst(end-33:end)])
    [filesstacks] = NNK_wsac(Strwfs(end,:,:,:,:),Strdataless(end,:,:,:,:),fullfile(path2clst,'stacks'),fullfile(path2dtb,'stat'),[sacextension '.stack'],'',formatinp,mycomputer) ;
    [files] = NNK_wsac(Strwfs(1:end-1,:,:,:,find(mempha=='E')),Strdataless(1:end-1,:,:,:,find(mempha=='E')),fullfile(path2clst,'events'),fullfile(path2dtb,'stat'),[sacextension '.alligned'],'',formatinp,mycomputer) ;

    
    
    
    %%% Use stacked as master wf %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     clc;disp(['Cluster ' num2str(i) '/' num2str(size(dtbliste,1))]);disp(['... ' path2clst(end-33:end)])
%     system(['./NNK/NNK_stack2master.pl "' path2clst '" ']);
    
    
    
    
    
        
    
    %%% enrich pick file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clc;disp(['Cluster ' num2str(i) '/' num2str(size(dtbliste,1))]);disp(['... ' path2clst(end-33:end)])
    enrichinp([path2clst '/events/*'],'*WY.inp','unix');

    
    disp(['Cluster ' path2clst ' done']);
end

%%% Pretty ending %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clc ; NNK_disp_end(1,time0) ;






