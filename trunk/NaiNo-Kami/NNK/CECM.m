function [CECMs,peaks] = CECM(processmatZ,processmatN,processmatE,fen,ufen,seuil,chan)


%%%%%%%%%
test=0; % Plot some interesting stuff
%%%%%%%%%



if exist('fen','var') == 0 ; fen = 400 ; ufen = 10 ; seuil = 0.94 ; end

if test==1
    figure ; hold on ;
    fornorm = repmat(8*max(abs(processmatZ)),size(processmatZ,1),1) ;
    forshift = repmat(1:size(processmatZ,2),size(processmatZ,1),1);
    plot(((5/6)+processmatZ./fornorm)+forshift,'-k') ;
    plot(((3/6)+processmatE./fornorm)+forshift,'-r') ;
    plot(((1/6)+processmatN./fornorm)+forshift,'-r') ; 
end

% disp('Correlate ...')
% CECMs = ones(size(processmatZ,1),size(processmatZ,2)) ; 
CECMpeakP = ones(size(processmatZ,1),size(processmatZ,2)) ; 
CECMpeakSE = CECMpeakP ; 
CECMpeakSN = CECMpeakP ; 

amplZ = processmatZ ; %ones(size(processmatZ,1),size(processmatZ,2)) ; 
amplE = processmatE ; %amplZ ; 
amplN = processmatN ; %amplZ ;

smallmeanZ=slidingmean(processmatZ,fix(ufen/3));
% smallmeanE=slidingmean(processmatE,fen/ufen);
% smallmeanN=slidingmean(processmatN,fen/ufen);

bigmeanZ=slidingmean(processmatZ,2*fen);
% bigmeanE=slidingmean(processmatE,fen);
% bigmeanN=slidingmean(processmatN,fen);

tooneZ = logical(processmatZ==0);
tooneE = logical(processmatE==0);
tooneN = logical(processmatN==0);
toone=tooneZ.*tooneE.*tooneN;

for i = 1 : size(processmatZ,2)
%     [tmpCECMsSE,tmpCECMsSN,tmpCECMsP,amplZEN] = ...
%        CECM_core(processmatZ(:,i),processmatN(:,i),processmatE(:,i),fen,ufen,toone(:,i)) ;     

    [tmpCECMsSE,tmpCECMsSN,tmpCECMsP,amplZEN] = ...
       CECM_core(processmatZ(:,i),processmatN(:,i),processmatE(:,i)...
       ,fen,ufen,toone(:,i),smallmeanZ(:,i),bigmeanZ(:,i)) ; 

       
    CECMpeakP(:,i) = tmpCECMsP; 
    CECMpeakSN(:,i) = tmpCECMsSN ;
    CECMpeakSE(:,i) = tmpCECMsSE ;
    
    amplZ(:,i) = amplZEN(:,1) ; 
    amplE(:,i) = amplZEN(:,2) ; 
    amplN(:,i) = amplZEN(:,3) ; 
    
end
clear processmatZ processmatN processmatE tmpCECMsSN tmpCECMsSE tmpCECMsP 
% disp('... correlation done !')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

condfindP = 1-seuil ;
condfindS = (1-seuil)/4 ;
seuiltps = 500 ;
seuilSP = 500 ;
lrg = fix(ufen/2) ; 



[peaks] = NNK_peakedit(1-CECMpeakP,amplZ,condfindP,chan,lrg,seuiltps,1-CECMpeakSE,amplE,1-CECMpeakSN,amplN,condfindS,seuilSP) ;
CECMs = CECMpeakP+CECMpeakSE+CECMpeakSN ; 


if test==1
    
    plot(((2/3)+CECMpeakP-5/6)+forshift,'-m','linewidth',2) ;
    plot(((1/3)+CECMpeakSE-5/6)+forshift,'-g','linewidth',2) ;
    plot(((0/3)+CECMpeakSN-5/6)+forshift,'-g','linewidth',2) ;
    
    if ~isempty(peaks)
        plot(peaks(:,1),((5/6)+peaks(:,4)./peaks(:,4))+peaks(:,7)-1,'sb')
        plot(peaks(:,2),((3/6)+peaks(:,5)./peaks(:,5))+peaks(:,7)-1,'+b')
        plot(peaks(:,3),((1/6)+peaks(:,6)./peaks(:,6))+peaks(:,7)-1,'+b')
    end
end
clear Ppeaklocs Ppeakamps Speaks Speaklocs Speakamps ind

