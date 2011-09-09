function [Strwfs,stat,compo,records] = NNK_dtec_read(liste,pathtostadtb,recal,flagfilt,B,A,stamaitre) 

%%% Charge les parametres
NNK_dtec_takeparams ;   %
load NNK_dtec_params    %
%%%%%%%%%%%%%%%%%%%%%%%%%



if size(liste,1) > 500 ; n = 500 ; else  n = size(liste,1); end
[pathstr] = fileparts(liste(1,:)) ;
[pathdirect] = fileparts(pathstr) ;

if exist('stamaitre','var') == 0
    [stat] = NNK_dtec_findkey(liste(1:n,length(pathstr)+statnameind+1:length(pathstr)+3+statnameind)) ;
    [compo] = NNK_dtec_findkey(liste(1:n,length(pathstr)+componameind+1)) ;
else
    stat = stamaitre(:,1:3) ;
    compo = stamaitre(1,4)  ;
end
if recal == 1
    compo = ['E' ; 'N' ; 'Z']  ;
    [record] = NNK_dtec_findkey(liste(:,[length(pathdirect)+2:length(pathdirect)+9 length(pathdirect)+11:length(pathdirect)+16])) ;
elseif recal == 0
    [record] = NNK_dtec_findkey(liste(:,length(pathdirect)+2:length(pathdirect)+17)) ;
end
    
switch wfsformat
    case 'sac'
        [Strwfs] = NNK_dtec_readsac(liste,stat,compo,record,maxnpts,pathtostadtb,recal,flagfilt,B,A) ; 
    
    case 'AH'
        [Strwfs] = NNK_dtec_readah(liste,stat,compo,record,maxnpts) ; 
    
    otherwise
        disp 'No data to read'

end
[a,b,c,d] = size(Strwfs) ;  
disp([num2str(size(record,1)) ' records on ' num2str(size(stat,1)) ' stations and ' num2str(size(compo,1)) ' components found'])
disp([num2str(a) ' records on ' num2str(b) ' stations and ' num2str(c) ' components read'])

if recal == 0 
    records = NNK_dtec_findkey(liste(:,1:length(pathdirect)+17)) ; 
elseif recal == 1 
    records = record ; 
end