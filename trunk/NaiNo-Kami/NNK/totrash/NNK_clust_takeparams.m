function NNK_clust_takeparams

% fred.massin@gmail.com 
% YVO University of Utah 2010

% CCC treeshold for clustering (0.85) %
seuilcluster = 0.85 ;                 %
%=====================================%
% Components for clustering           %%%%%%%%%%%%%%%%%
stamaitre = '' ;                                      %
n = size(stamaitre,1) ; stamaitre(n+1,1:4) = 'YHHZ' ; %
n = size(stamaitre,1) ; stamaitre(n+1,1:4) = 'MCDZ' ; %
n = size(stamaitre,1) ; stamaitre(n+1,1:4) = 'YMLZ' ; %
n = size(stamaitre,1) ; stamaitre(n+1,1:4) = 'YLAZ' ; %
% n = size(stamaitre,1) ; stamaitre(n+1,1:4) = 'yufZ' ; %
% n = size(stamaitre,1) ; stamaitre(n+1,1:4) = 'YLTZ' ; %
%====================%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Windowing          %
secutim = 0.5 ;      % Before arrival
fen = 4 ;            % After arrival
codafen = 64 ;       % After coda arrival
sam_rate = 100;      % Default sampling frequency
%====================%
% Paths              %%%%%%%%%%%%%%
pathtoNNKdtec =  '/home/fred/Documents/scripts/NaiNoKami/NaiNoKami_2/NNK' ; 
pathtotmp =  '/home/fred/Documents/scripts/NaiNoKami/NaiNoKami_2/tmp' ;
                                  % '-NNK_dtec directory
netcode = 'WY' ;                  % Network
path2dtb = '/data/4Fred/WF/WY' ;  % For results
sacextension = '.sac.linux' ;     % the same in NNK_dtec_takeparams.m
%=================================%%%%%%%%%
% Formats                                 %
%pickimportcomand = 'ovpf2NNK.pl' ;       % Read OVPF pick files
pickimportcomand = 'uuss2NNK.pl' ;        % Read UUSS pick files 
%=========================%%%%%%%%%%%%%%%%%
% Special tricks          %
flagfilt = 1 ;            % = 1 : filtering (cf NNK_dtec_takeparams.m) 
seuilpickedit = 0.6 ;     % CCC treeshold for similarity picking (0.6)
ncorrel = 2 ;             % Mini. num. of well-correlated for clustering
Phase = 1 ;               % Phases used in correlation (1:P ; 2:S ; 3:Coda) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%




























































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DO NOT CHANGE :%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
secutim = (secutim*sam_rate) ;             
fen = fen*sam_rate ;  
codafen = codafen*sam_rate ;
if exist(char(path2dtb),'dir') ~= 7
    mkdir(char(path2dtb)) ; 
end
if exist(char(pathtotmp),'dir') ~= 7
    mkdir(char(pathtotmp)) ; 
end
if length(findstr(path,pathtoNNKdtec)) == 0
    path(path,char(pathtoNNKdtec)) ;
end
save NNK_clust_params * 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
