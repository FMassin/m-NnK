function NNK_takeparams
%
% CORRECT EXAMPLE OF SETTINGS FILE FOR NNK_2.1_example_package. 
% TYPE "help NNK_clust" IN MATLAB, ON HOW TO USE THIS FILE.
%
% Triggered waveform data should be stored in architecture
%  yyyy/mm/dd/yyyymmddHHMMSSnc/STN_C_nc.sac.linux
% 
% yyyy: year. mm: month. dd: day.
% HH: hour. MM: minute. SS: second
% STN: station name (lim to 3 char). 
%   C: component (lim to 1 char). 
%  nc: network code (lim to 2 char)
% 
%
% fred.massin@gmail.com UofU 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stamaitre = '' ; % DO NOT CHANGE - EDIT BELOW     % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% Basic Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You'd better edit the following parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enable real time processing %
continu = 0 ;                 %1:continuous re-analysis.0:one analysis
%=============================%%%
% Components for clustering     %%%%%%%%
stamaitre=[stamaitre ; 'YHH' ; 'MCD']; % 
%===============================%%%%%% size(stamaitre,1) >= 2*ncorrel !!
% Paths                              %  
pathtowfs =[pwd '/example/dtec'] ;   % path to the directories containing waveform record of each event
path2dtb = [pwd '/example'] ;        % path to the database
netcode = 'WY' ;                     % specifiy network code UUSS-YVO:'WY' | OVPF:'PF' | Undervolc:'YA'
%====================================%
% To input your picks                %%%%%%%%
inpextension = '.inp' ;                     %
%pickimportcomand = 'ovpf2NNK.pl' ;         % Read OVPF pick files (hypo71)
pickimportcomand = 'uuss2NNK.pl' ;          % Read UUSS pick files (p-file)
pathtomanualinp = [pwd '/example/pick'] ;   % for manual pick 
%================================%%%%%%%%%%%%
% Default byte-order in SAC file %
endian = 'big-endian';           %
%    endian  = 'big-endian' byte order (e.g., UNIX, UUSS)
%            = 'little-endian' byte order (e.g., LINUX, OVPF)
%================================%%%%%%%
% Format of data and naming convention %
maxnpts = 6400 ;                       % max number of point in readings
sacextension = '.sac.linux' ;          % outputed data extension
%=========================%%%%%%%%%%%%%%






% Advanced Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Are you sure you wanna change that ? %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the filter               %
frequencecoupurehighpass = 4 ; % highpass cutting freq |
frequencecoupurelowpass = 12 ; % lowpass cutting freq  |- changes needed for LPs
%===================%%%%%%%%%%%%
% Set the detection %
seuil = 0.99 ;      % detection threeshlod [0< <1]
efen = 400 ;        % for energy window [counts]
givesmallfen = 40 ; % for the CECM window (from efen/givesmallfen)
maxdelay = 400 ;    % max delay between piktime of same event [counts]
%===================%%%%%%%%%%%%%%%%%%%
% CCC treeshold for clustering (0.85) %
seuilcluster = 0.91 ;                 %
ncorrel = 1 ;                         % Mini. num. of CCC >= seuilcluster
%========================%%%%%%%%%%%%%%
% Windows for clustering %
secutim = 0.5 ;          % Before arrival
fen = 4 ;                % After arrival (secutim+fen must be > lenreg)
codafen = 64 ;           % After coda arrival
%========================%%%%%%%%%%%%
% Paths                             %
pathtoNNKdtec = [pwd '/NNK'] ;      % NNK sources directory
pathtotmp =  [pwd '/tmp'] ;         %  
%===================================%
% aliases for 3 charateres stations names
aliases= [pwd '/aliases.txt'];          %
%=======================================%











% Stupid Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Things may become crazy if you change below !%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timepause = 60 ;          % Waiting time between each iteration [s]
flagfilt = 1 ;            % = 1 : filtering (cf NNK_dtec_takeparams.m) 
seuilpickedit = [0.6 ncorrel] ; % CCC treeshold for similarity picking (0.6)
Phase = 'P' ;             % Phases used in correlation (P ; S ; C ; E ; PSCE) 
sam_rate = 100;           % Default sampling frequency
lenreg = 800 ;            % Default register length !!!!! >= 306 !!!!!
compo = 'Z' ;            %
% Your computer is a :    %
% mycomputer = 'pc';      % PC terminator (your soul is damned if it's your case)
mycomputer = 'unix' ;     % UNIX based terminator (linux, mac, sun, etc)
%=========================%
% NNK picktime file format%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       station-___  ,-polarity                                                                              %                      
formatinp(1,:) = ' CCC Pp1 yymmddHHMMSS.FF      0Ss.cs      S 1                                0 0.000000' ; %
%             P weight---'                         S weight---'                                              %          
formatinp(2,:) = '                 10                                                                    ' ; %
%                                   '---end mark                                                             %
%                                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                    %
% To change use "C" to put station name & length     %
%               "yy"..........year place             %
%               "MM"..........month place            %
%               "dd"..........day place              %
%               "hh"..........hour place             %
%               "mm"..........minut place            %
%               "Ps.ss".......P time place           %
%               "p"...........P polarity             %
%               "Ss.cs".......S time place           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%










































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DO NOT CHANGE :%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frequencedeNyquist=sam_rate/2;
       
secutim = (secutim*sam_rate) ;             
fen = fen*sam_rate ;  
codafen = codafen*sam_rate ;
ufen = fix(fen/givesmallfen) ;

demande = {pathtowfs ; '*' ; stamaitre ; compo ; Phase};
option = {endian 1 flagfilt 0 0 0 0 0 0 0 1} ;
windows = [5*6000 10*6000 10*6000];
filter = {frequencecoupurehighpass frequencecoupurelowpass frequencedeNyquist 'bandpass' 2};


if size(stamaitre,1) < ncorrel
    disp(char(['========= Unconsistent parameters, edit NNK_takeparams.m : =========']))
    disp(char(['size(stamaitre,1) = ' num2str(size(stamaitre,1)) ' and ncorrel = '  num2str(ncorrel)]))
    warning(char(['Increase "stamaitre" or decrease "ncorrel" until size(stamaitre,1) > ncorrel ']))
end
if exist(char(pathtowfs),'dir') ~= 7                                     
    warning(char(['Can t access to data directory : ' char(pathtowfs)]))    
end 
if exist(char(pathtomanualinp),'dir') ~= 7
    warning(char(['Can t access to your picks directory : ' char(pathtomanualinp) ' will be created.'])) 
    mkdir(char(pathtomanualinp))
end
if exist(char(path2dtb),'dir') ~= 7
    warning(char(['Can t access to NNK directory : ' char(path2dtb) ' will be created.'])) 
    mkdir(char(path2dtb)) ; 
end
if exist(char(pathtotmp),'dir') ~= 7
    warning(char(['Can t access to tempory directory : ' char(pathtotmp) ' will be created.'])) 
    mkdir(char(pathtotmp)) ; 
end
if isempty(findstr(path,pathtoNNKdtec))
    warning(char(['NNK scripts directory is not in Matlab path : ' char(pathtoNNKdtec) ' will be added']))
    path(path,char(pathtoNNKdtec)) ;
end


clear frequencecoupurehighpass frequencecoupurelowpass 
save NNK_params * 
