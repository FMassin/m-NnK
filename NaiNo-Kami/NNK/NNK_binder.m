function [listeout] = NNK_binder(pathtodtb,Peaktime,Strwfs,maxdelay,lenreg,sacextension,seuil,formatinp,mycomputer,netcode)

pathtodtb=[pathtodtb '/dtec'];
if exist(char(pathtodtb),'dir') ~= 7
    mkdir(pathtodtb) ;
end

maxdelay = maxdelay/(100*60*60*24);
Csta = 8 ; 
listeout = '' ; 

for i = 1 : size(Peaktime,1)                                   % essai de bind sur chq pick
    nonzeroelt = find(Peaktime(:,1)>0) ;                         %
    if ~isempty(nonzeroelt)

        [pickref,indpickref] = min(Peaktime(nonzeroelt,1)) ;        % dans l'ordre chronologique
        indpickref = nonzeroelt(indpickref) ;                       %
        
        indotherstatproches = logical(abs(Peaktime(:,1)-Peaktime(indpickref,1)) < maxdelay & Peaktime(:,Csta)~=Peaktime(indpickref,Csta)) ;
        indotherstatproches(indpickref) = 1 ;
        
        event = Peaktime(indotherstatproches,:) ;
        [indotherstatproches] = NNK_binder_onestation(event,indotherstatproches,Csta);
        event = Peaktime(indotherstatproches,:) ;
        
        if size(event,1) >= seuil(2)
            [filepaths] = NNK_binder_NNK2sac(event,Strwfs,pathtodtb,Csta,lenreg,sacextension,netcode) ;
            if size(filepaths,1)>=1
                [pathfile,poubelle] = fileparts(filepaths(1,:)) ;
                [poubelle,filename] = fileparts(pathfile) ;
                [file] = makeinp(formatinp,sacextension,pathfile,seuil(1)) ;
                filename = filename(3:14) ;
                filename = fullfile(pathfile,[filename '.inp']) ;
                dlmwrite(filename,file,'-append','delimiter','','newline',mycomputer)
                
                listeout = [listeout ; filepaths];
            end
        end
        Peaktime(indotherstatproches,:) = 0 ;
    end
    if sum(Peaktime(:,1)) == 0 ; break ; end
end        
        
