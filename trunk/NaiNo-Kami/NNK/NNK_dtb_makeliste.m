function [listefichier,lesrecord,lesstat,lescompo,indrec,indstat,indcomp] = ...
    NNK_dtb_makeliste(path2clst,netcode,sacextension,pathtotmp)

if exist('path2clst','var') ~= 1 ;path2clst = '' ; end

% List new dtec and known clusters %%%%%%%%%%%%%%%%%%%%%
comand  = ['./NNK/NNK_dtb_makeliste.pl 0 ' netcode sacextension ' ' path2clst ] ; 
system(comand) ;

% Importations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
listefichier = char(importdata('tmp10.txt')) ; 
indrec = (importdata('tmp11.txt')) ;
indstat = (importdata('tmp12.txt')) ;
indcomp = (importdata('tmp13.txt')) ;
lesrecord = char(importdata('tmp14.txt')) ; 
lesstat = char(importdata('tmp15.txt')) ;
lescompo = char(importdata('tmp16.txt')) ;

movefile('tmp10.txt',[pathtotmp '/tmp10.txt'])
movefile('tmp11.txt',[pathtotmp '/tmp11.txt'])
movefile('tmp12.txt',[pathtotmp '/tmp12.txt'])
movefile('tmp13.txt',[pathtotmp '/tmp13.txt'])
movefile('tmp14.txt',[pathtotmp '/tmp14.txt'])
movefile('tmp15.txt',[pathtotmp '/tmp15.txt'])
movefile('tmp16.txt',[pathtotmp '/tmp16.txt'])

% Outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sps(1:min([5 size(listefichier,1)]),1) = ' ' ;
disp([listefichier(1:min([5 size(listefichier,1)]),:) sps ...
    lesrecord(indrec(1:min([5 size(listefichier,1)])),:) sps ...
    lesstat(indstat(1:min([5 size(listefichier,1)])),:) sps ...
    lescompo(indcomp(1:min([5 size(listefichier,1)])),:) ])

disp([num2str(size(listefichier,1)) ' sac files found'])
