function makedeltas(master,slave,sacextension,maxnpts,secutim,fenP,seuil)

Fs = 100 ;

listemaster = dir(fullfile(master,['*' sacextension]));
listemaster = char(listemaster.name);
listemaster = [repmat([master '/'],size(listemaster,1),1) listemaster] ;


listeslave = dir(fullfile(slave,['*' sacextension]));
listeslave = char(listeslave.name);
listeslave = [repmat([slave '/'],size(listeslave,1),1) listeslave] ;

CCC(1:size(listeslave,1),1:8) = ' ' ;
TS = zeros(size(listeslave,1),1) ;
compomem(1:size(listeslave,1),1:5) = ' ' ; 
    
outmast = zeros(maxnpts,3);
outslave = outmast ;  

PhasetmS = 0 ; 
PhasetmM = PhasetmS ; 
 

for i=1:size(listemaster,1)
    
    nmast = 0 ; 
    nslav = 0 ;
    PhasetmS = 0 ;
    PhasetmM = 0 ; 
    CCC(i,1:8) = ' ' ;
    TS(i) = 0 ;
    
    [poubelle,compomaster] = fileparts(listemaster(i,:)) ;
    compomaster = compomaster(1:5) ;
    compomem(i,1:5) = compomaster ; 
    
    outmast = rsac(listemaster(i,:));
    nmast = size(outmast,1) ; 
    
    if strcmp(compomaster(5),'Z') == 1
        [PhasetmM,infoM] = lh(outmast,'A','KA') ;
    elseif strcmp(compomaster(5),'E') == 1
        [PhasetmM,infoM] = lh(outmast,'T1','KT1') ;
    elseif strcmp(compomaster(5),'N') == 1
        [PhasetmM,infoM] = lh(outmast,'T1','KT1') ;
    end
    
    
    for ii=1:size(listeslave,1)
        

        [poubelle,composlave] = fileparts(listeslave(ii,:)) ;
        composlave = composlave(1:5) ;
        
        if strcmp(composlave,compomaster) == 1
            
            memnamesalve = listeslave(ii,:) ;
            outslave = rsac(listeslave(ii,:)); 
            [A,KA,T1,KT1,T2,KT2,T6,T7,KT6,KT7,nslav,NZYEAR,NZJDAY,NZHOUR,NZMIN,NZSEC,NZMSEC] = ...
                lh(outslave,'A','KA','T1','KT1','T2','KT2','T6','T7','KT6','KT7','NPTS','NZYEAR','NZJDAY','NZHOUR','NZMIN','NZSEC','NZMSEC') ;
            zero1 = str2num(datestr(addtodate(datenum(['00/00/' num2str(NZYEAR) ' 00:00' ]), NZJDAY, 'day'),'yymmddHHMMSS')) ;
            zero1 = zero1 + (NZHOUR*10000+NZMIN*100+NZSEC+NZMSEC/1000)  ;
            zero1 = datenum(num2str(zero1),'yymmddHHMMSS.FFF') ;
            
            if strcmp(compomaster(5),'Z') == 1
                PhasetmS = A ; 
                infoS = KA ; 
                if strcmp(KT6(1),'P') == 1
                    PhasetmS = T6 ; 
                    infoS = KT6 ;
                end
            elseif strcmp(compomaster(5),'E') == 1
                PhasetmS = T1 ; 
                infoS = KT1 ;
                if strcmp(KT7(1),'S') == 1
                    PhasetmS = T7 ; 
                    infoS = KT7 ;
                end
            elseif strcmp(compomaster(5),'N') == 1
                PhasetmS = T1 ;  
                infoS = KT1 ;
                if strcmp(KT7(1),'S') == 1
                    PhasetmS = T7 ; 
                    infoS = KT7 ;
                end
            end
            
            break
        end
    end
    
    
    
    if PhasetmM > 0.01 && PhasetmS > 0.01
        
        lim(1,1:2) = [fix(PhasetmM*Fs)-secutim fix(PhasetmS*Fs)-secutim] ;
        lim(2,1:2) = lim(1,1:2)+fenP ;
        wf = [outmast(lim(1,1):lim(2,1),2)  outslave(lim(1,2):lim(2,2),2)] ;
        [CCCtmp,TStmp] = NNK_xcorr(wf) ;
        CCCtmp = num2str(CCCtmp(1,2),'%1.2f') ;
        CCC(i,1:8) = infoS ;
        CCC(i,5:8) = CCCtmp ;
        TS(i) = zero1 + ((PhasetmS*Fs + (TStmp(1,2)-size(wf,1)))/Fs)/(60*60*24) ;

        T3 = 0 ; T4 = 0 ; T5 = 0 ;
        KT3(1,1:8) = ' ' ; KT4(1,1:8) = ' ' ; KT5(1,1:8) = ' ' ;
        if strcmp(compomaster(5),'Z') == 1
            T3 = (TS(i)-zero1)*(60*60*24) ;
            KT3(1,1:8) = CCC(i,1:8) ;
            for ii = 1 : size(compomem,1)
                if strcmp(compomem(ii,1:3),compomaster(1:3)) == 1
                    if strcmp(compomem(ii,5),'E') == 1 && TS(ii) > 0
                        T4 = (TS(ii)-zero1)*(60*60*24) ;
                        KT4(1,1:8) = CCC(ii,1:8) ;
                    elseif strcmp(compomem(ii,5),'N') == 1 && TS(ii) > 0
                        T5 = (TS(ii)-zero1)*(60*60*24) ;
                        KT5(1,1:8) = CCC(ii,1:8) ;
                    end
                end
            end
            outslave=ch(outslave,'T3',T3,'T4',T4,'T5',T5,'KT3',KT3,'KT4',KT4,'KT5',KT5) ;

        elseif strcmp(compomaster(5),'E') == 1
            T4 = (TS(i)-zero1)*(60*60*24) ;
            KT4(1,1:8) = CCC(i,1:8) ;
            outslave=ch(outslave,'T4',T4,'KT4',KT4) ;

        elseif strcmp(compomaster(5),'N') == 1
            T4 = (TS(i)-zero1)*(60*60*24) ;
            KT4(1,1:8) = CCC(i,1:8) ;
            outslave=ch(outslave,'T4',T4,'KT4',KT4) ;
        end

%         disp(['====================================' composlave ' ' compomaster '====================================='])
%         disp([num2str(zero1) ' ' num2str(TS(i))])
%         disp([KA ' ' num2str(A) '     // ' KT1 ' ' num2str(T1) '     // ' KT2 ' ' num2str(T2) ])
%         disp([KT3 ' ' num2str(T3) '     // ' KT4 ' ' num2str(T4) '     // ' KT5 ' ' num2str(T5) ])
        wsac(memnamesalve,outslave);

    end
end

% figure ; hold on
% for i=1:size(listemaster,1)
%     plot(i+outmast(:,2,i)/(2*abs(max(outmast(:,2,i)))),'r')
%     plot(i+0.5+outslave(:,2,i)/(2*abs(max(outslave(:,2,i)))))    
% end





