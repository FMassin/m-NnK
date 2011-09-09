function [CECMs] = CECM_core_ligth(processmatZ,processmatN,processmatE,fen,ufen,toone)


toone=logical(processmatZ==0);
toone=toone.*logical(processmatE==0);
toone=toone.*logical(processmatE==0);

% disp('find P and S areas ...')
forsum = fix(ufen*2) ;
amplZEN = slidingsum([processmatZ processmatE processmatN],forsum) ;
amplZEN(1:end-fix(forsum)+1,:) = amplZEN(fix(forsum):end,:) ;

forrms = 2*ufen ; 
rmsZ = slidingrms(processmatZ,forrms) ;
rmsE = slidingrms(processmatN,forrms) ;
rmsN = slidingrms(processmatE,forrms) ;
ZonH = ((rmsZ./rmsE)+(rmsZ./rmsN))./2 ;
ZonH(1:end-fix(forrms)+1,:) = ZonH(fix(forrms):end,:) ;



seuilenergP = 1 ; 
[LpotentialP] = find(ZonH > seuilenergP) ;
[LpotentialS] = find(ZonH < seuilenergP) ;%& amplZEN(:,2) >= 0.5*amplZEN(:,3)) ;
[LpotentialSN] = find(ZonH < seuilenergP) ;% & amplZEN(:,3) >= 0.5*amplZEN(:,2)) ;
clear ZonH LpotentialP  LpotentialS amplZEN
% disp('...P and S areas done !')

% disp('Rms ...')
rmsZ = slidingrms(processmatZ,fen) ;
rmsE = slidingrms(processmatN,fen) ;
rmsN = slidingrms(processmatE,fen) ;
clear processmatE processmatN processmatZ
% disp('...rms done !')

%disp('sum(Rms^2) ...')
rms2sumZ = slidingsum(rmsZ.^2,ufen) ;
rms2sumE = slidingsum(rmsE.^2,ufen) ;
rms2sumN = slidingsum(rmsN.^2,ufen) ;
%disp('...sum(Rms^2) done !')

% disp('Prod(rms) ...')
prod1 = rmsZ.*rmsE ;
prod2 = rmsZ.*rmsN ; 
clear rmsZ rmsE rmsN
% disp('...prod(rms) done !')

% disp('Sum(Prod) ...')
C1prodZE = slidingsum(prod1,ufen) ;
C2prodZN = slidingsum(prod2,ufen) ;
clear prod1 prod2
% disp('...sum(Prod) done !')

% disp('Correlation ...')
C1 = C1prodZE./sqrt(rms2sumZ.*rms2sumE) ;
C2 = C2prodZN./sqrt(rms2sumZ.*rms2sumN) ;
C1(logical(toone))=1;

clear C2prodZN C1prodZE rms2sumZ rms2sumE rms2sumN 
% disp('...Correlation done !')

% disp('Prod CC...')
CECMs = C1.*C2 ;
if exist('toone','var') == 1
    CECMs(logical(toone))=1;
end

% disp('...prod CC done !')


% disp('Re-assignent...') 
CECMs(fix(ufen/2):end,:) = CECMs(1:end-fix(ufen/2)+1,:) ;
CECMs(1:fix(fen/2),:) = 1 ;
% disp('...re-assigned !')
