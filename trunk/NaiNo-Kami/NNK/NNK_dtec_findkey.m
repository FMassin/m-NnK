function [elt,nelt] = NNK_dtec_findkey(chaine)


chaineline = reshape(chaine',1,size(chaine,1)*size(chaine,2)) ; 
condi(1:length(chaineline)) = '_' ;  
ind = 0 ; 
elt = '' ; 

while strcmp(condi,chaineline) == 0 & ind < size(chaine,1)
    ind = ind+1 ;
    [a,z,e] = fileparts(chaine(ind,:))  ;
    if isempty(e) == 1
        lesind = findstr((chaine(ind,:)),(chaineline)) ;
        n = length(lesind) ;
        if isempty(lesind) == 0
            for i = 1 : size(chaine,2)-1
                lesind = [lesind lesind(1:n)+i] ;
            end
            chaineline(lesind) = '_' ;
            nelt(size(elt,1)+1) = n ; 
            elt(size(elt,1)+1,1:size(chaine,2)) = chaine(ind,:) ;
        end
    end
end