function [Strwfs] = NNK_dtec_readsac(liste,stat,compo,record,maxnpts,pathtostadtb,recal,flagfilt,B,A)

Strwfs = cell(size(record,1),size(stat,1),size(compo,1),3) ;
if recal == 0
    Strwfs = cell(size(record,1),size(stat,1),size(compo,1),4) ;
end

if exist(char(pathtostadtb),'dir') ~= 7
    mkdir(pathtostadtb) ;
end

recordlisteline = reshape(record',1,size(record,1)*size(record,2)) ;
statlisteline = reshape(stat',1,size(stat,1)*size(stat,2)) ;
compolisteline = compo' ;

maxi=size(stat,1)*size(compo,1)*size(record,1);               % (1) Set this to the total number of iterations
progress_bar_position = 0;
time_for_this_iteration = 0.01;  % (2) Provide initial time estimate for one iteration
count = 1 ;

for i = 1 : size(liste,1) ; tic;


    [pathstr] = fileparts(liste(i,:)) ;
    [pathdirect] = fileparts(pathstr) ;
    if recal == 1 ;
        recordi = liste(i,[length(pathdirect)+2:length(pathdirect)+9 length(pathdirect)+11:length(pathdirect)+16]) ;
    elseif recal == 0
        recordi = liste(i,length(pathdirect)+2:length(pathdirect)+17) ;
    end


    if exist(liste(i,:),'file') == 2
        out = rsac(liste(i,:));
    else
        out = zeros(maxnpts,3) ;  out(303,3) = 77 ; 
    end
    [KSTNM,KCMPNM,NZYEAR,NZJDAY,NZHOUR,NZMIN,NZSEC,NZMSEC,NPTS,DELTA,KNETWK] ...
        = lh(out,'KSTNM','KCMPNM','NZYEAR','NZJDAY','NZHOUR','NZMIN','NZSEC','NZMSEC','NPTS','DELTA','KNETWK') ;
    [KNETWK] = KNETWK(isspace(KNETWK)==0) ;
    [KSTNM] = KSTNM(isspace(KSTNM)==0) ;
    [KCMPNM] = KCMPNM(isspace(KCMPNM)==0) ;
    savename =  fullfile(pathtostadtb,[KNETWK '_' KSTNM '_' KCMPNM '.mat']) ;

    if recal == 0
        TS = fix(max(lh(out,'T1','T2'))*1/DELTA) ;
    elseif recal == 1
        hdr = out(:,3) ;
        save(savename,'hdr') ;
        zero0 = datenum(['20' char(liste(i,end-26:end-21)) char(liste(i,end-19:end-14)) '.00'],'yyyymmddHHMMSS.FFF') ;
    end
    tokeep = savename ;

    zero1 = str2num(datestr(addtodate(datenum(['00/00/' num2str(NZYEAR) ' 00:00' ]), NZJDAY, 'day'),'yymmddHHMMSS')) ;
    zero1 = zero1 + (NZHOUR*10000+NZMIN*100+NZSEC+NZMSEC/1000)  ;
    indrec = findstr(recordi(1:size(record,2)),recordlisteline) ;
    indrec = (indrec+(size(record,2)-1))/(size(record,2)) ;
    indstat = findstr(KSTNM(1:size(stat,2)),statlisteline) ;
    indstat = (indstat+(size(stat,2)-1))/(size(stat,2)) ;
    indcompo = findstr(KCMPNM(1:size(compo,2)),compolisteline) ;

    if isempty(indcompo) && length(KCMPNM) >= 3  ; indcompo = findstr(KCMPNM(3),compolisteline) ; end
    if ~isempty(indrec) & ~isempty(indstat) & ~isempty(indcompo)
        if indrec > 0 & indstat > 0 & indcompo > 0 & indcompo < 4


            WF = out(:,2) ;
            TM = addtodate(datenum(NZYEAR,01,01,NZHOUR,NZMIN,NZSEC+NZMSEC/1000), NZJDAY-1, 'day') ;

            if recal == 1
                dt1 = round((zero0-TM)*(24*60*60*100)) ; % si dt1 > 0 la trace commence AVANT la minute pile
                if dt1 > 0
                    WF(1:length(WF)-dt1) = WF(dt1+1:length(WF));
                elseif dt1 < 0
                    WF((-1*dt1)+1:length(WF)) = WF(1:length(WF)-(-1*dt1));
                end

                limnpts = min([maxnpts length(WF)]) ;
                WF = WF(1:limnpts);
                if limnpts < maxnpts ; WF = [WF ; zeros(maxnpts-limnpts,1)] ; end
                TM = zero0 ;
            end
            WF = WF-mean(WF) ;
            if flagfilt == 1
                WF = filtfilt(B,A,WF) ;
                WF = filtfilt(B,A,WF) ;
            end
            Strwfs{indrec,indstat,indcompo,1} = WF' ;
            Strwfs{indrec,indstat,indcompo,2} = TM ;
            Strwfs{indrec,indstat,indcompo,3} = tokeep ;
            if recal == 0 && TS > 0 ; Strwfs{indrec,indstat,indcompo,4} = WF(TS:500)' ; end

            clc ; count = count+1;
            [progress_bar_position] = textprogressbar(count,maxi,progress_bar_position,time_for_this_iteration,...
                ['Reading ' recordi(1:size(record,2)) ' ' KSTNM ' ' KCMPNM ' ']) ;
            time_for_this_iteration = toc;
        end
    end
end
