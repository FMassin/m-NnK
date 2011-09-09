function [peaks] = NNK_peakedit(CECMpeakP,amplZ,condfindP,chan,lrg,seuiltmp,CECMpeakSE,amplE,CECMpeakSN,amplN,condfindS,seuilSP)

n = 12 ;
peaks = zeros(5000,n) ;
indpeak = 0 ;
if exist('CECMpeakSE','var') == 1 && ...
        exist('CECMpeakSN','var') == 1 && ...
        exist('condfindS','var') == 1 && ...
        exist('seuilSP','var') == 1 
    flagS = 1 ;
else
    flagS = 0 ; 
end
    
for i = 1 : size(CECMpeakP,2)
    if max(max(CECMpeakP(:,i))) >= condfindP
        
        [Ppeakamps,Ppeaklocs] = myfindpeaks(CECMpeakP(:,i),lrg,seuiltmp,condfindP) ; %fix(ufen/2),
             
        if ~isempty(Ppeakamps)
            decorrel = Ppeakamps ;
            Ppeakamps = amplZ(Ppeaklocs,i) ;
            
            for ii = 1 : length(Ppeakamps)
                lespeaks = zeros(1,n) ;
                lespeaks(1,[1 4 7 9 12]) = [Ppeaklocs(ii)-lrg Ppeakamps(ii) i chan(1) decorrel(ii)] ;
                
                if flagS == 1
                    ind = fix(Ppeaklocs(ii))+(lrg*4) : min([fix(Ppeaklocs(ii))+seuilSP size(CECMpeakSE,1)]) ;


                    if max(CECMpeakSE(ind,i)) >= condfindS & flagS == 1
                        [SEpeakamps,SEpeaklocs] = myfindpeaks(CECMpeakSE(ind,i),lrg/2,lrg,condfindS) ;
                        if ~isempty(SEpeakamps)
                            [val,choix] = max(SEpeakamps) ;

                            SEpeakamps = amplE(SEpeaklocs,i) ;
                            SEpeaklocs = ind(1) + SEpeaklocs ;
                            lespeaks(1,[2 5 10]) = [SEpeaklocs(choix)-lrg SEpeakamps(choix) chan(2)] ;
                        end
                    end
                    if max(CECMpeakSN(ind,i)) >= condfindS & flagS == 1
                        [SNpeakamps,SNpeaklocs] = myfindpeaks(CECMpeakSN(ind,i),lrg/2,lrg,condfindS) ;
                        if ~isempty(SNpeakamps)
                            [val,choix] = max(SNpeakamps) ;

                            SNpeakamps = amplN(SNpeaklocs,i) ;
                            SNpeaklocs = ind(1) + SNpeaklocs ;
                            lespeaks(1,[3 6 11]) = [SNpeaklocs(choix)-lrg SNpeakamps(choix) chan(3)] ;
                        end
                    end
                end
                indpeak = indpeak +1 ;
                peaks(indpeak,1:n) = lespeaks ;
            end
        end
    end
end
if indpeak >0
    peaks = peaks(1:indpeak,1:n) ;
else
    peaks = [] ;
end
