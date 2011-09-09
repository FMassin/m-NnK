function [listefichier,nbmast,lesrecord,lesstat,lescompo,indrec,indstat,indcomp] = ...
    NNK_clust_makeliste(stamaitre,path2dtb,netcode,sacextension,pathtotmp,listeout)

% Initiate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('listeout','var') ~= 1 ;listeout = '' ; end
stamaitre = [stamaitre repmat(' ',size(stamaitre,1),1)] ; 
stamaitre = reshape(stamaitre',1,prod(size(stamaitre))) ; 

% List new dtec and known clusters %%%%%%%%%%%%%%%%%%%%%
comand  = ['./NNK/NNK_clust_makeliste_1.pl 0 ' netcode sacextension ' ' path2dtb ' ' stamaitre] ; 
system(comand) ;

% Importations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
listefichier = char(importdata('tmp.txt')) ; 
nbmast = (importdata('tmp0.txt')) ;
indrec = (importdata('tmp1.txt')) ;
indstat = (importdata('tmp2.txt')) ;
indcomp = (importdata('tmp3.txt')) ;
lesrecord = char(importdata('tmp4.txt')) ; 
lesstat = char(importdata('tmp5.txt')) ;
lescompo = char(importdata('tmp6.txt')) ;

movefile('tmp.txt',[pathtotmp '/tmp.txt'])
movefile('tmp0.txt',[pathtotmp '/tmp0.txt'])
movefile('tmp1.txt',[pathtotmp '/tmp1.txt'])
movefile('tmp2.txt',[pathtotmp '/tmp2.txt'])
movefile('tmp3.txt',[pathtotmp '/tmp3.txt'])
movefile('tmp4.txt',[pathtotmp '/tmp4.txt'])
movefile('tmp5.txt',[pathtotmp '/tmp5.txt'])
movefile('tmp6.txt',[pathtotmp '/tmp6.txt'])

% Outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sps(1:5,1) = ' ' ;
disp([listefichier(1:5,:) sps lesrecord(indrec(1:5),:) sps lesstat(indstat(1:5),:) sps lescompo(indcomp(1:5),:) ])

disp([num2str(size(listefichier,1)) ' sac files found'])
