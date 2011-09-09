function [file,pointes] = makeinp(formatinp,sacextension,event,seuil) 

file = repmat(formatinp(2,:),50,1) ; 
pointes = [] ; 
[poubelle,eventname] = fileparts(event) ; 
sec2day = 1/(24*60*60) ;
lenline = size(formatinp,2) ; 
countline = 0 ; 

leinp = dir(fullfile(event,'*.inp')) ; 
leinp = char(leinp.name) ;
if size(leinp,2) == 15 ; if strcmp(leinp(1:12),event(end-13:end-2)) == 0 ; leinp = '' ; end ; end

listesac = dir(fullfile(event,['*' sacextension])) ; 
listesac = char(listesac.name) ;

for i = 1 : size(listesac,1)
    
    sta = listesac(i,1:3) ; 
    compo = listesac(i,5) ; 
    
    if strcmp(compo,'Z') == 1
        
        out = rsac(fullfile(event,listesac(i,:)));
        [A,KA,T1,T2,KT1,KT2,NZYEAR,NZJDAY,NZHOUR,NZMIN,NZSEC,NZMSEC,T3,T4,T5,KT3,KT4,KT5] = ...
            lh(out,'A','KA','T1','T2','KT1','KT2','NZYEAR','NZJDAY','NZHOUR','NZMIN','NZSEC','NZMSEC','T3','T4','T5','KT3','KT4','KT5') ; 
 
        % First points of read datas %%%%%%%%%%
        zero1 = addtodate(datenum(['00/00/' num2str(NZYEAR) ' 00:00' ]), NZJDAY, 'day')+(NZHOUR/24)+(NZMIN/(24*60))+(NZSEC+(NZMSEC/1000))/(24*60*60)  ;
    
        if strcmp(KT3(1),'P') == 1 & str2num(KT3(5:8)) >= seuil
            A = T3 ;
        end
        if strcmp(KT4(1),'S') == 1 & str2num(KT4(5:8)) >= seuil
            T1 = T4 ; 
        end
        if strcmp(KT5(1),'S') == 1 & str2num(KT5(5:8)) >= seuil
            T2 = T5 ; 
        end
               
        A = zero1+A*sec2day;
        T1 = zero1+T1*sec2day;
        T2 = zero1+T2*sec2day;
        
        TS = [] ;
        KTS = '0S 1';
        if T1 == zero1 & T2 == zero1 
            TS = [] ; 
        elseif T1 > zero1 & T2 > zero1 
            TS = min([T1 T2]) ;
        elseif T1 > zero1 & T2 == zero1 
            TS = T1 ;
        elseif T1 == zero1 & T2 > zero1 
            TS = T2 ;
        end
                
        
        zero1 = datestr(zero1,'yymmddHHMMSS.FFF') ; 
        A = datestr(A,'yymmddHHMMSS.FFF') ; 
        T1 = datestr(T1,'yymmddHHMMSS.FFF') ; 
        T2 = datestr(T2,'yymmddHHMMSS.FFF') ; 
        TS = datestr(TS,'yymmddHHMMSS.FFF') ; if size(TS,1) == 0 ; TS(1,1:16) = ' ' ; KTS = '    ' ; end

        
%         formatinp(1,:) = ' CCC Pp1 yymmddHHMMSS.FF      0Ss.cs      S 1                                0 0.000000' ; %
        line(1:lenline) = formatinp(1,:) ; %' ' ; 
        
        loc = strfind(formatinp(1,:),'CCC') ; 
        loc = loc : loc+2 ;  
        line(loc) = sta(1:3) ; 
        
        loc = strfind(formatinp(1,:),'Pp') ; 
        loc = loc : loc+1 ;  
        line(loc) = KA(1:2) ; 

        loc = strfind(formatinp(1,:),'yymmddHHMMSS.FF') ; 
        loc = loc : loc+14 ;  
        line(loc) = A(1:15) ; 
        
        loc = strfind(formatinp(1,:),'0Ss.cs') ; 
        loc = loc : loc+5 ;  
        line(loc) = [KTS(1) TS(end-5:end-1)] ;
        
        loc = strfind(formatinp(1,:),'S 1') ; 
        loc = loc : loc+2 ;  
        line(loc) = KTS(2:4) ;
        
        countline = countline+1 ; 
        file(countline,:) = line ;
        
        %disp([ sta ' : ' num2str(zero1) ' ' KA(1:2) ' ' num2str(A) ' ' KT1(1:2) ' ' num2str(T1) ' ' KT2(1:2) ' ' num2str(T2) ])
         
        
    end
end
file = file(1:countline+1,:) ;

