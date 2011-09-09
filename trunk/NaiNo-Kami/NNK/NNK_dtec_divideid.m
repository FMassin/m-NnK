function [indice] = NNK_dtec_divideid(pas,Strwfs)

nbite = ceil(Strwfs/pas) ; 
indice = ones(2,nbite) ; 
deb = 1 ; 
for i = 1 : nbite
    fin = deb-1+min([pas Strwfs-deb+1]) ; 
    
    indice(1:2,i) = [deb fin] ;
    
    deb = fin+1 ;     
end
