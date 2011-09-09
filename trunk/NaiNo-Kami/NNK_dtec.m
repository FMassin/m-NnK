function NNK_dtec

% Detection and picking of P and S phases.
%
% Usage : NNK_dtec    to launch
%
% See :
% * M. N. Zhizhin, D. Rouland, J. Bonnin, A. D. Gvishiani and A.
% Burtsev. Rapid Estimation of Earthquake Source Parameters from Pattern
% Analysis of Waveforms Recorded at a Single Three-Component Broadband
% Station, Port Vila, Vanuatu. Bulletin of the Seismological Society of
% America; v. 96 ; no. 6; p. 2329-2347; December 2006;
% DOI: 10.1785/0120050172
%
% fred.massin@gmail.com 
% YVO University of Utah 2010.




% conn = database('fovpf','pgsql','olvssclr','org.postgresql.Driver','jdbc:postgresql://195.83.188.2') ;
% update(conn, 'acquisition',{'date_heure'},{'2010-03-08 10:00:00'},{'where num_appli = 21 and num_type = 28'}) ;
% close(conn)









%%% Set parameters
NNK_takeparams ; %
continu=1;       %
time0 = clock ;  %
%%%%%%%%%%%%%%%%%%

savefile='tmp/lastfiledone.mat';condi='0';save(savefile,'condi') ;

% DETECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load NNK_params

%%% Listing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[listefichier,lesrecord,lesstat,lescompo,indrec,indstat,indcomp]=...
    NNK_dtec_makeliste(pathtowfs,wfsextention,directformat,pathtotmp,dateposition);
save([pathtotmp '/dteclst0.mat'],'listefichier','lesrecord','lesstat','lescompo','indrec','indstat','indcomp');

if size(listefichier,1) > 0

    %%% Pre-Reading %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Strwfs] = NNK_rsac(listefichier,lesrecord,lesstat,lescompo,indrec,indstat,indcomp,0,1) ;
    save([pathtotmp '/dtecwf0.mat'],'pathtotmp','listefichier','Strwfs','lesrecord','lesstat','lescompo','indrec','indstat','indcomp');

    %%% Pre-Picking %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Peak,indsliste] = NNK_dtec_CECM(Strwfs,lesstat,lescompo,fen,ufen,seuil,maxnpts) ;
    save([pathtotmp '/dtecpk0.mat'],'pathtotmp','listefichier','indsliste','Strwfs','lesrecord','lesstat','lescompo','indrec','indstat','indcomp');

    %%% Reduce list %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    lesrecord=lesrecord(indsliste,:);
    inds=[];for i=1:length(indsliste);test=find(indsliste(i)==indrec);indrec(test)=i;if sum(test)>0;inds=[inds;test];end;end
    listefichier = listefichier(inds,:)
    indrec = indrec(inds) ;
    indstat = indstat(inds)  ;
    indcomp = indcomp(inds)  ;
    save([pathtotmp '/dteclst1.mat'],'pathtotmp','listefichier','lesrecord','lesstat','lescompo','indrec','indstat','indcomp');

    if size(listefichier,1) > 0
        %%% Reading %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [Strwfs] = NNK_rsac(listefichier,lesrecord,lesstat,lescompo,indrec,indstat,indcomp,0) ;
        save([pathtotmp '/dtecwf1.mat'],'pathtotmp','Strwfs','lesrecord','lesstat','lescompo','indrec','indstat','indcomp');

        %%% Picking %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [Peak] = NNK_dtec_CECM(Strwfs,lesstat,lescompo,fen,ufen,seuil,maxnpts) ;
        save([pathtotmp '/dtecpk1.mat'],'pathtotmp','Peak','Strwfs','lesrecord','lesstat','lescompo','indrec','indstat','indcomp');

        %%% Writing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [Peaktime] = NNK_dtec_ind2time(Peak,Strwfs,frequencedeNyquist*2) ;
        [listeout] = NNK_binder(path2dtb,Peaktime,Strwfs,maxdelay,lenreg,sacextension,seuilpickedit,formatinp,mycomputer,netcode) ;
        save([pathtotmp '/dtecWsac.mat'],'pathtotmp','Peak','Strwfs','Peaktime','listeout');
    else
        disp('NO PHASES FOUND ON YOUR MASTER STATION cf stamaitre in NNK_takeparams.m')
    end
    %%% Pretty ending %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clc ; NNK_disp_end(1,time0) ;
else
    disp('NO FILES FOUND check format of data and naming convention in NNK_takeparams.m')
end













