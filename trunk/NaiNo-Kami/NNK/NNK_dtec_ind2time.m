function [Peaktime] = NNK_dtec_ind2time(Peak,Strwfs,Fs)

% TM = str2double(datestr(addtodate(datenum(['00/00/' num2str(NZYEAR) ' 00:00' ]), NZJDAY, 'day'),'yymmddHHMMSS')) ;
% TM = TM + (NZHOUR*10000+NZMIN*100+NZSEC+NZMSEC/1000) ;
% Strwfs{indrec,indstat,indcompo,2} = TM ;


%otherinds = [2 5 7:size(Peak,2)] ; 
Peaktime = Peak ;

for i = 1: size(Peak,1) ;
    for ii = 1 : 3
        if Peak(i,ii+8) > 0
            Tzero = Strwfs{Peak(i,7),Peak(i,8),Peak(i,ii+8),2} ;
            if ~isempty(Tzero) && Peak(i,ii) > 0
                Peaktime(i,ii) = Tzero+(Peak(i,ii)/Fs)/(24*60*60) ;
            else
                Peaktime(i,ii) = 0 ;
            end
        else
            Peaktime(i,ii) = 0 ;
        end            
    end
end
    
% for i = 1: size(Peak,1)    
%     disp([stat(Peak(i,7),:) ' P : ' datestr(Tzero,'yyyymmddHHMMSS.FFF') ' + ' num2str(Peak(i,1)/Fs) 'cs = '  datestr(Peaktime(i,1) ,'yyyymmddHHMMSS.FFF')...
%         '    S : ' datestr(Tzero,'yyyymmddHHMMSS.FFF') ' + ' num2str(Peak(i,4)/Fs) 'cs = '  datestr(Peaktime(i,2) ,'yyyymmddHHMMSS.FFF')])
% end
    

    
