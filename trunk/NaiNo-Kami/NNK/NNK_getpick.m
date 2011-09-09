function [P,S,C,E]=NNK_getpick(out,pickimportcomand,file,sta,zero1,DELTA)


P = [] ; S = [] ; C = []; E = [];
if exist('DELTA','var')~=1;[DELTA]=lh(out,'DELTA');end
if exist('zero1','var')~=1
    [NZYEAR,NZJDAY,NZHOUR,NZMIN,NZSEC,NZMSEC] = lh(out,'NZYEAR','NZJDAY','NZHOUR','NZMIN','NZSEC','NZMSEC') ;
    zero1 = addtodate(datenum(['00/00/' num2str(NZYEAR) ' 00:00' ]), NZJDAY, 'day')+(NZHOUR/24)+(NZMIN/(24*60))+(NZSEC+(NZMSEC/1000))/(24*60*60);
end
    
    
indtoday=(24*60*60*1/DELTA);
% First points of ... NNK_dtec picks %%  (NOT-USED IF MANUAL PICK AVAILABLE *1)
aS = fix(max(lh(out,'T1','T2'))*1/DELTA) ;
aP = fix(lh(out,'A')*1/DELTA) ;
aC = [];
if aS>0;S=aS;end
if aP>0;P=aP;end
if aC>0;C=aC;end

if exist('pickimportcomand','var')==1 & exist('file','var')==1 & exist('sta','var')==1
    % First points of ... manual picks %%%%  (*1-PREFERED)
    [mP,mS,mC,mE] = NNK_getmanualpick(pickimportcomand,file,sta) ;
    if mP>0;P=fix((mP-zero1)*(indtoday));end
    if mS>0;S=fix((mS-zero1)*(indtoday));end
    if mC>0;C=fix((mC-zero1)*(indtoday));end
    if mE>0;E=fix((mE-zero1)*(indtoday));end    
end

if numel(C)==0 & P>0
    [poub,C]=max(abs(out(max([P S]):min([end P+(S-P)*4 P+3000]),2)));
    C=C+max([P S]);
end
if numel(E)==0 & P>0
    [E]=min([size(out,1) P+6400]);
end
