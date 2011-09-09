function [inpfile] = NNK_writeinp(formatinp,path2clusters,sacextension,maxnpts,secutim,fenP,seuil,mycomputer)



inpfile = cell(size(path2clusters,1),1) ; 
for i = 1 : size(path2clusters,1)
    liste = path2clusters{i} ; 
    [master] = fileparts(liste(1,:)) ; 
    [master] = fileparts(master) ; 
    [file] = makeinp(formatinp,sacextension,master) ;
    %disp('master') ; disp(file) ;  disp('====================')
    [poubelle,filename] = fileparts(master) ; 
    filename = filename(3:14) ; 
    filename = fullfile(master,[filename '.inp']) ;
    dlmwrite(filename,file,'-append','delimiter','','newline','unix')
    
    for ii = 1 : size(liste,1)
        
        makedeltas(master,liste(ii,:),sacextension,maxnpts,secutim,fenP,seuil) ;
        [file] = makeinp(formatinp,sacextension,liste(ii,:),seuil) ;
        %disp('|===> slave') ; disp(file) ;  disp('====================')
        
        [poubelle,filename] = fileparts(liste(ii,:)) ; 
        filename = filename(3:14) ;
        filename = fullfile(liste(ii,:),[filename '.inp']) ;
        dlmwrite(filename,file,'-append','delimiter','','newline',mycomputer)
    end
end
        