function NNK_dtec_takeparams

% Petit module de reglage pour NNK_dtec. la premiere partie peut etre 
% changee. La seconde partie doit etre maintenu intact pour le
% bon fonctionnement de NNK_dtec.
% 
% La fonction filtfilt peut etre deconnectee dans NNK_dtec_1 (lignes 20 21
% et 22).
% 
% Bibliographie :
% * M. N. Zhizhin, D. Rouland, J. Bonnin, A. D. Gvishiani and A.
% Burtsev. Rapid Estimation of Earthquake Source Parameters from Pattern 
% Analysis of Waveforms Recorded at a Single Three-Component Broadband 
% Station, Port Vila, Vanuatu. Bulletin of the Seismological Society of 
% America; v. 96 ; no. 6; p. 2329-2347; December 2006;      
% DOI: 10.1785/0120050172
%
% Frederick Massin, OVPF, 2008.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You can change here :%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                     %
%%%% General parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% See NNK_dtec.m
timepause = 120 ;                                    % en seconde
pathtoNNKdtec = [pwd '/NNK'] ;                       % > NNK_dtec directory
pathtodtb = '/data/4Fred/WF/WY/dtec' ;               % > PATH for results directory 
pathtostadtb = '/data/4Fred/WF/WY/stat' ;            % > PATH for stations directory 
pathtomanualinp = '/data/4Fred/WF/WY/inp' ;          %
                                                     %
wfsformat = 'sac' ;                                  % 
pathtowfs = '/data/4Fred/WF/WY' ;                    % > data sac
directorylen = 20 ; 
directformat = 'yyyymmdd_HHMMSS_FFF' ; 
wfsextention = '.WY' ; 
statnameind = 1 ; 
componameind = 5 ; 
maxnpts = 9000 ; 

inpextension = '.inp' ;                              % > result file extension
sacextension = '.sac.linux' ;                        %
                                                     %
%%%% Correlation parameters %%%%%%%%%%%%%%%%%%%%%%%%%% See NNK_dtec_1.m and 
flagfilt = 1  ;                                      % NNK_dtec_core.m
frequencedeNyquist = 50 ;                            % > half of sampl. freq.
frequencecoupurehighpass = 4 ;                       % > highpass filter   
frequencecoupurelowpass = 12 ;                       % > lowpass filter cut 
                                                     % off frequency 
givesmallfen = 40 ;                                  % > see Zhizhin et al*
fen = 400 ;                                          % > energy window
% energy window is the minimal time between 2 detections with good quality
% ufen = fen/givesmallfen = correlation window ; minimal time between P and
% detected S waves  
% !!!!!!!!!!!!!!!!!!!!!!    keep 2 < ufen << fen  !!!!!!!!!!!!!!!!!!!!!!!!
% +fen => +calc => better detection 
% +givesmallfen => -calc => reduce noise  
% give better detection if givesmallfen == 40 and fen == 400)
                                                     %
%%%% Detection parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%% See NNK_dtec_2.m
seuil = 0.98 ;                                       % > detec threeshlod
lenreg = 800 ;                                       % > register length !!!!! >= 306 !!!!!
maxdelay = 400 ;                                     % > max delay between
                                                     % piktime of same
                                                     % event
                                                     %
%%%% picktime file format
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DO NOT MODIFY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[B,A] = butter(2,[frequencecoupurehighpass/frequencedeNyquist ; ...
    frequencecoupurelowpass/frequencedeNyquist],'bandpass') ;            % 
                                                                       %
if exist(char(pathtowfs),'dir') ~= 7                                     %
    disp(char(['Can t access to data directory : ' char(pathtowfs)]))    %
end                                                                      %

if length(findstr(path,pathtoNNKdtec)) == 0
    path(path,char(pathtoNNKdtec)) ;
end

if exist(char(pathtomanualinp),'dir') ~= 7
    mkdir(char(pathtomanualinp)) ; 
end

ufen = fix(fen/givesmallfen) ;         
clear frequencecoupurehighpass frequencedeNyquist frequencecoupurelowpass 
save NNK_dtec_params *                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








