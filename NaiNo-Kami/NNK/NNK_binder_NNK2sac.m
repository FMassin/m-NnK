function [allfilepaths] = NNK_binder_NNK2sac(event,Strwfs,pathtodtb,Csta,lenreg,sacextension,netcode)

forname = min(event(:,1)) ;

eventyear = datestr(forname,'yyyy') ;
eventmonth = datestr(forname,'mm') ;
eventday = datestr(forname,'dd') ;
eventname = [datestr(forname,'yyyymmddHHMMSS') netcode] ;
allfilepaths = [] ;

filepath = fullfile(pathtodtb,eventyear,eventmonth,eventday,eventname) ;
if exist(char(filepath),'dir') ~= 7
    mkdir(filepath) ;
end


for i = 1 : size(event,1)
    rec = event(i,Csta-1) ;
    sta = event(i,Csta) ;

    for ii = 1 : 3
        if event(i,ii) > 0

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %           1            2            3            4             5            6  7  8  9 10 11            12
            % 734206.1558  734206.1559  734206.1559  2758.495782  -87.63747087  -84.0488381  1  1  3  1  2  0.0926193262
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            cmp = event(i,Csta+ii) ;

            zero0 = Strwfs{rec,sta,cmp,2} ;
            trace0 = Strwfs{rec,sta,cmp,1} ;

            if length(trace0) > lenreg

                load(char(Strwfs{rec,sta,cmp,3})) ;
                [KNETWK,KSTNM,KCMPNM,DELTA] = lh(repmat(hdr,1,3),'KNETWK','KSTNM','KCMPNM','DELTA') ;

                Fs = 1/(round(DELTA*100)/100)  ;
                date2ind = (24*60*60*Fs) ;
                zero1 = event(i,ii)-(100/date2ind) ; % !!!!!!!!!!!!!!!!
                dt2zero1 = round((zero1-zero0)*date2ind) ;

                lenreg2 = max([lenreg real(fix(lenreg+10.^(event(i,12))*500))]) ;
                if dt2zero1+lenreg2-1 > length(trace0)
                    if size(Strwfs,1) >= rec+1
                        indtmp(1) = fix(((Strwfs{rec+1,sta,cmp,2} - Strwfs{rec,sta,cmp,2})*date2ind))+1 ;
                        indtmp(2) = fix(indtmp(1)+length(Strwfs{rec+1,sta,cmp,1})) ;
                        if indtmp(1) < 6000
                            trace0(indtmp(1):indtmp(2)) = Strwfs{rec+1,sta,cmp,1};
                        else
                            lenreg2 = lenreg ;
                        end
                    else
                        lenreg2 = lenreg ;
                    end
                end
                
                lenreg2 = min([fix(lenreg2) length(trace0-dt2zero1) 12000]) ;
                [lign,colo] = size(trace0)  ;
                
                if dt2zero1 <= length(trace0) & dt2zero1+lenreg2-1 <= length(trace0)
                    indices = 1 : lenreg2 ;
                    time = ((indices-1)/Fs)-1/Fs ;
                    trace = trace0(dt2zero1:dt2zero1+lenreg2-1);

                    sacfile(1:max(indices),1) = time ;   % !!!!!!!! max(indice) >= 306 !!!!!!!!!!!
                    sacfile(1:max(indices),2) = trace ;
                    sacfile(1:306,3) = hdr(1:306) ;
                    sacfile = sacfile(1:max(indices),1:3) ;
                    
                    KNETWK = KNETWK(isspace(KNETWK)==0) ;
                    KSTNM =  KSTNM(isspace(KSTNM)==0) ;
                    KCMPNM = KCMPNM(isspace(KCMPNM)==0) ;
                    
                    if isempty(KNETWK);KNETWK=netcode;end
                    if length(KSTNM)>3;KSTNM=KSTNM(end-2:end);end
                    if length(KCMPNM)>1;KCMPNM=KCMPNM(end:end);end
                    
                    filename = [KSTNM(isspace(KSTNM)==0) '_' KCMPNM(isspace(KCMPNM)==0) '_' KNETWK(isspace(KNETWK)==0) sacextension] ;                   
                        
                    fullfilepath = fullfile(filepath,filename) ;
                    allfilepaths = [allfilepaths ; fullfilepath] ;

                    % donnees
                    NZYEAR = str2num(datestr(zero1,'yyyy')) ;
                    NZJDAY = fix(zero1)-datenum(NZYEAR,1,1)+1 ;
                    NZHOUR = str2num(datestr(zero1,'HH')) ;
                    NZMIN = str2num(datestr(zero1,'MM')) ;
                    NZSEC = str2num(datestr(zero1,'SS')) ;
                    NZMSEC = str2num(datestr(zero1,'FFF')) ;
                    NPTS = lenreg2 ;
                    IZTYPE = 2 ;
                    E = max(time) ;
                    O = 0 ;

                    % evenement
                    KEVNM = eventname ;
                    MAG = mymagnitude('duree',(lenreg2-100)/Fs) ;
                    IMAGTYP = 5 ;

                    % phases
                    F = lenreg2 ;                 % F	 Fini or end of event time (seconds relative to reference time.)
                    KF = 'end     ';              % A	 Fini identification.

                    A = (event(i,1) - zero1)*date2ind/Fs ;  % F	 First arrival time (seconds relative to reference time.)
                    if event(i,4) > 0
                        KA = 'PC      ' ;
                    else
                        KA = 'PD      ' ;
                    end                           % K	 First arrival time identification.

                    if ii == 2
                        T1 = (event(i,2) - zero1)*date2ind/Fs ;
                        KT1 = 'SE      ' ;
                        T2 = 0 ;
                        KT2 = '        ';
                    elseif ii == 3
                        T1 = (event(i,3) - zero1)*date2ind/Fs ;
                        KT1 = 'SN      ' ;
                        T2 = 0 ;
                        KT2 = '        ';
                    elseif ii == 1
                        T2 = 0 ;
                        KT2 = '        ' ;
                        T1 = 0 ;
                        KT1 = '        ' ;
                        if event(i,2) > 0
                            T1 = (event(i,2) - zero1)*date2ind/Fs ;
                            KT1 = 'SE      ' ;
                        end
                        if event(i,3) > 0
                            T2 = (event(i,3) - zero1)*date2ind/Fs ;
                            KT2 = 'SN      ' ;
                        end
                    end

                    % instrument
                    IDEP = 4 ;                   %pour velocimetre ; =5 pour accelerometre



                    sacfile=ch(sacfile,...
                        'NZYEAR',NZYEAR,...
                        'NZJDAY',NZJDAY,...
                        'NZHOUR',NZHOUR,...
                        'NZMIN',NZMIN,...
                        'NZSEC',NZSEC,...
                        'NZMSEC',NZMSEC,...
                        'NPTS',NPTS,...
                        'IZTYPE',IZTYPE,...
                        'E',E,...
                        'O',O,...
                        'KEVNM',KEVNM,...
                        'MAG',MAG,...
                        'IMAGTYP',IMAGTYP,...
                        'F',F,...
                        'KF',KF,...
                        'A',A,...
                        'KA',KA,...
                        'T1',T1,...
                        'T2',T2,...
                        'KT1',KT1,...
                        'KT2',KT2,...
                        'IDEP',IDEP) ;

                    wsac(char(fullfilepath),sacfile);
                    %disp(['Earthquake recorded in ' char(fullfilepath)]) ;
                end
            end
        end
    end
end
disp([num2str(size(allfilepaths,1)) ' components saved in ' filepath])

