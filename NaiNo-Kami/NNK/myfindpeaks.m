function [peakamps,peaklocs] = myfindpeaks(IN,largmin,largmax,seuil) 

peakamps = [] ; 
peaklocs = [] ; 


lignes = find(IN>=seuil) ;
if ~isempty(lignes)
    
    ecarts = diff(lignes) ;
    seps = find(ecarts>1)  ;
    
    if ~isempty(seps)
        seps2(:,1) = [lignes(1) ; lignes(seps+1)] ;
        seps2(:,2) = [lignes(seps) ; lignes(length(lignes))] ;
    else
        seps2(1,1:2) = [lignes(1)  lignes(length(lignes))] ;
    end
        
    lastcond = -9999 ;
    lastamp = -9999 ;
    for i = 1:size(seps2,1)
        if seps2(i,2)-seps2(i,1) >= largmin

            ind = [seps2(i,1) : seps2(i,2)] ;
            [maximum,maxima] = max(IN(ind)) ;
            maxima = seps2(i,1)+maxima-1;

            if maxima-lastcond >= largmax 
                lastcond = maxima ;
                peakamps = [peakamps ; IN(maxima)] ;
                peaklocs = [peaklocs ; maxima] ;
            elseif maxima-lastcond < largmax &&  length(peakamps) > 1 && lastamp < IN(maxima)
                lastcond = maxima ;
                lastamp = IN(maxima) ;
                peakamps(length(peakamps)) = IN(maxima) ;
                peaklocs(length(peakamps)) = maxima ;
            end
        end
    end
end