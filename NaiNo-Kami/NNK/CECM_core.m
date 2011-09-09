function [CECMsSE,CECMsSN,CECMsP,amplZEN,CECMs] = CECM_core(processmatZ,processmatN,processmatE,fen,ufen,toone,smallmeanZ,bigmeanZ)

flag=0;
if sum(sum(abs(processmatN))) ==0 & sum(sum(abs(processmatE))) ==0
    flag=1;
end
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

save temp.mat LpotentialP  LpotentialS amplZEN
clear ZonH LpotentialP  LpotentialS amplZEN
% disp('...P and S areas done !')

% disp('Rms ...')
rmsZ = slidingrms(processmatZ,fen) ;
rmsE = slidingrms(processmatN,fen) ;
rmsN = slidingrms(processmatE,fen) ;
clear processmatE processmatN processmatZ 
if exist('bigmeanZ','var')==1
    rmssmall=slidingrms(smallmeanZ,fen) ;
    rmsbig=slidingrms(bigmeanZ,fen) ;
    clear smallmeanZ bigmeanZ
end
% disp('...rms done !')

%disp('sum(Rms^2) ...')
rms2sumZ = slidingsum(rmsZ.^2,ufen) ;
rms2sumE = slidingsum(rmsE.^2,ufen) ;
rms2sumN = slidingsum(rmsN.^2,ufen) ;
if exist('rmssmall','var')==1
    rms2sumZsmall=slidingsum(rmssmall.^2,ufen) ;
    rms2sumZbig=slidingsum(rmsbig.^2,ufen) ;
end
%disp('...sum(Rms^2) done !')

% disp('Prod(rms) ...')
prod1 = rmsZ.*rmsE ;
prod2 = rmsZ.*rmsN ; 
clear rmsZ rmsE rmsN
if exist('rmssmall','var')==1
    prod1smallbig=rmssmall.*rmsbig;
    clear rmssmall rmsbig
end
% disp('...prod(rms) done !')

% disp('Sum(Prod) ...')
C1prodZE = slidingsum(prod1,ufen) ;
C2prodZN = slidingsum(prod2,ufen) ;
clear prod1 prod2
if exist('prod1smallbig','var')==1
    C3prodsmallbig = slidingsum(prod1smallbig,ufen) ;
    clear prod1smallbig
end
% disp('...sum(Prod) done !')

% disp('Correlation ...')
C1 = C1prodZE./sqrt(rms2sumZ.*rms2sumE) ;
C2 = C2prodZN./sqrt(rms2sumZ.*rms2sumN) ;
clear C2prodZN C1prodZE rms2sumZ rms2sumE rms2sumN
if exist('C3prodsmallbig','var')==1
    C3 = C3prodsmallbig./sqrt(rms2sumZsmall.*rms2sumZbig) ;
    C3(logical(toone))=1;
    clear rms2sumZbig rms2sumZsmall C3prodsmallbig
end
if exist('toone','var') == 1
    C1(logical(toone))=1;
    C2(logical(toone))=1;
end
clear toone
% disp('...Correlation done !')

% disp('Prod CC...')
CECMs = C1.*C2 ;
if exist('C3','var')==1
    CECMs(fix(ufen/2):end,:)=CECMs(fix(ufen/2):end,:).*C3(1:end-fix(ufen/2)+1,:);
end
if flag == 1
    CECMs(fix(ufen/2):end,:)=C3(1:end-fix(ufen/2)+1,:);
end
% disp('...prod CC done !')


% disp('Re-assignent...') 
CECMs(fix(ufen/2):end,:) = CECMs(1:end-fix(ufen/2)+1,:) ;
CECMs(1:fix(fen/2),:) = 1 ;
% disp('...re-assigned !')

load temp.mat 
CECMsSE = C1 ; 
CECMsSN = C2 ;
CECMsP = CECMs ; 
clear C1 C2


CECMsSE((LpotentialP)) = 1 ;
CECMsSN((LpotentialP)) = 1 ;
CECMsP((LpotentialS)) = 1 ; 


delete temp.mat ; 
