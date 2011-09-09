function [listefichier,lesrecord,lesstat,lescompo,indrec,indstat,indcomp] = ...
    NNK_dtec_makeliste(pathtowfs,wfsextention,directformat,pathtotmp,dateposition,demande)

% Initiate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('listeout','var') ~= 1 ;demande = '' ; end

savefile = fullfile(pathtotmp,'lastfiledone.mat') ;
if exist(savefile,'file') == 2 ; load(savefile);disp('loaded!') ; else condi = '00000000_000000_9999' ; end

% List new dtec and known clusters %%%%%%%%%%%%%%%%%%%%%
comand  = [dateposition ' ' condi ' ' wfsextention(1,:) ' ' pathtowfs ' ' directformat(1,:) ] ;
system(comand) ;

% Importations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[a,b] = system('ls -l tmp.txt | grep " 0 "');
if numel(b) == 0
    listefichier = char(importdata('tmp.txt')) ;
    indrec = (importdata('tmp1.txt')) ;
    indstat = (importdata('tmp2.txt')) ;
    indcomp = (importdata('tmp3.txt')) ;
    lesrecord = char(textread('tmp4.txt','%s')) ;
    lesstat = char(textread('tmp5.txt','%s')) ;
    lescompo = char(textread('tmp6.txt','%s')) ;
    condi = lesrecord(end,end-size(directformat,2)+1:end) ;
    save(savefile,'condi') ;
else
    listefichier = '' ;
    indrec = [] ;
    indstat = [] ;
    indcomp = [] ;
    lesrecord = '' ;
    lesstat = '' ;
    lescompo ='';
end

movefile('tmp.txt',[pathtotmp '/tmp.txt'])
movefile('tmp1.txt',[pathtotmp '/tmp1.txt'])
movefile('tmp2.txt',[pathtotmp '/tmp2.txt'])
movefile('tmp3.txt',[pathtotmp '/tmp3.txt'])
movefile('tmp4.txt',[pathtotmp '/tmp4.txt'])
movefile('tmp5.txt',[pathtotmp '/tmp5.txt'])
movefile('tmp6.txt',[pathtotmp '/tmp6.txt'])

% Outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inddisp=min([5 size(listefichier,1)]);
sps(1:inddisp,1) = ' ' ;
disp([listefichier(1:inddisp,:) sps lesrecord(indrec(1:inddisp),:) sps lesstat(indstat(1:inddisp),:) sps lescompo(indcomp(1:inddisp),:) ])

disp([num2str(size(listefichier,1)) ' sac files found'])


    