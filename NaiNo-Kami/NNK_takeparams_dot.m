function NNK_takeparams

% 
%
% fred.massin@gmail.com 
% YVO University of Utah 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stamaitre = '' ; % DO NOT CHANGE - EDIT BELOW     % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Basic Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You'd better edit the following parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enable real time processing %
continu = 0 ;                 % =1:infiniteiteration =0:one time process
%=============================%%%%
% Components for clustering      %
%stamaitre=[stamaitre ;'MCD'] ; %
%stamaitre=[stamaitre ;'YHH'] ; %
%stamaitre=[stamaitre ;'YPM'] ; %
stamaitre=[stamaitre ;'YLA'] ; %
%stamaitre=[stamaitre ;'YML'] ; %

stamaitre=[stamaitre ;'YMC'] ; %
stamaitre=[stamaitre ;'YGC'] ; %
stamaitre=[stamaitre ;'YDC'] ; %
stamaitre=[stamaitre ;'YFT'] ; %
%===============================%%%%%% size(stamaitre,1) >= 2*ncorrel !!
% Paths                              %  
path2dtb = '/data/4Fred/WF/WY' ;     %
pathtowfs = [path2dtb '/dtec'] ;     %
netcode = 'WY' ;                     % specifiy network code UUSS-YVO:'WY' | OVPF:'PF' | Undervolc:'YA'
%====================================%
% To input your picks                %%%%%%%%
pathtomanualinp = [path2dtb '/inp'] ;       %
inpextension = '.inp' ;                     %
%pickimportcomand = 'ovpf2NNK.pl' ;         % Read OVPF pick files
pickimportcomand = 'uuss2NNK.pl' ;          % Read UUSS pick files 
%================================%%%%%%%%%%%%
% Default byte-order in SAC file %
endian = 'big-endian';        %
%    endian  = 'big-endian' byte order (e.g., UNIX, UUSS)
%            = 'little-endian' byte order (e.g., LINUX, OVPF)
%================================%%%%%%%
% Format of data and naming convention %
maxnpts = 6400 ;                       % max number of point in readings
sacextension = '.sac.linux' ;          % outputed data extension
%=========================%%%%%%%%%%%%%%










% Advanced Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Are you sure you wanna chage that ? %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the filter               %
frequencecoupurehighpass = 4 ; % highpass cutting freq   
frequencecoupurelowpass = 12 ; % lowpass cutting freq 
%===================%%%%%%%%%%%%
% Set the detection %
seuil = 0.99 ;      % detection threeshlod [0< <1]
efen = 400 ;        % for energy window [counts]
givesmallfen = 40 ; % for the CECM window (from efen/givesmallfen)
maxdelay = 400 ;    % max delay between piktime of same event [counts]
%===================%%%%%%%%%%%%%%%%%%%
% CCC treeshold for clustering (0.85) %
seuilcluster = 0.85 ;                 %
ncorrel = 2 ;                         % Mini. num. of CCC >= seuilcluster
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











% Stupid Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Things may become crazy if you change below !%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timepause = 60 ;          % Waiting time between each iteration [s]
flagfilt = 1 ;            % = 1 : filtering (cf NNK_dtec_takeparams.m) 
seuilpickedit = [0.6 ncorrel] ; % CCC treeshold for similarity picking (0.6)
Phase = 'P' ;             % Phases used in correlation (P ; S ; C ; E ; PSCE) 
sam_rate = 100;           % Default sampling frequency
lenreg = 800 ;            % Default register length !!!!! >= 306 !!!!!
compo = 'Z' ;             % component used for clustering
% Your computer is a :    %
% mycomputer = 'pc';      % PC terminator (your soul is damned if it's your case)
mycomputer = 'unix' ;     % UNIX terminator
%=========================%
% NNK picktime file format%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       station-___  ,-polarity                                                                              %
%                          10        20        30        40        50        60        70        80                      
%                 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 1234567
formatinp(1,:) = ' CCC Pp1 yymmddHHMMSS.FF       Ss.cs S 1                                               ' ; %
%             P weight---'                    S weight---'                                                   %          
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

pha=Phase;
clear frequencecoupurehighpass frequencecoupurelowpass 
save NNK_params * 
