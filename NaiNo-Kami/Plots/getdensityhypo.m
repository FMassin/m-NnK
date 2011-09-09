function [densite,Xval,Yval,Zval,colordata] = getdensityhypo(londegdecSVD,latdegdecSVD,profaslkmSVD,tranche,xmaille,ymaille,method)

%[data,Xval,Yval,Zval] = getdensityhypo(latdegdecSVD,londegdecSVD,profaslkmSVD,tranche,xmaille,ymaille) ;
% |    |     |    |
% |  xlab   ylab  zlabel pour chaque cellule de data
% densite


method = 2 ; 
seuilnb = 40 ; 

Xval = min(londegdecSVD)+xmaille/2 : xmaille : max(londegdecSVD)-xmaille/2 ;
Yval = min(latdegdecSVD)+ymaille/2 : ymaille : max(latdegdecSVD)-ymaille/2 ;
Zval = min(profaslkmSVD)+tranche/2 : tranche : max(profaslkmSVD)-tranche/2 ;
if length(Zval) < 3
    Zval = [mean(profaslkmSVD)-tranche/2  mean(profaslkmSVD) mean(profaslkmSVD)+tranche/2] ;
end

densite = zeros(length(Yval),length(Xval),length(Zval))*0.00000000000001 ;
colordata = densite ;
volumed = ((tranche)*(xmaille*90)*(ymaille*110)) ;

for z = 1 : length(Zval)
    counteq = 0 ;
    counteqtotal = histc(profaslkmSVD,[Zval(z)-tranche/2 Zval(z)+tranche/2],2) ;
    counteqtotal = counteqtotal(1:length(counteqtotal)-1) ;
    
    %if counteqtotal >= seuilnb
        for x = 1 : length(Xval)
            for y = 1 : length(Yval)

                counteq = 0.001 ;
                for eq = 1 : length(latdegdecSVD)
                    if londegdecSVD(eq) >= Xval(x)-xmaille/2 & londegdecSVD(eq) <= Xval(x)+xmaille/2 & ...
                            latdegdecSVD(eq) >= Yval(y)-ymaille/2 & latdegdecSVD(eq) <= Yval(y)+ymaille/2 & ...
                            profaslkmSVD(eq) >= Zval(z)-tranche/2 & profaslkmSVD(eq) <= Zval(z)+tranche/2
                        counteq = counteq+1 
                    end
                end
                if counteq > 0.001 ; colordata(y,x,z) = counteq ; end
            end
        end
    %end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    colordata(:,:,z) = (colordata(:,:,z))./volumed ; % densite eq.km^-3
    if method == 1
        %if max(max(max(colordata(:,:,z)))) > 10
            densite(:,:,z) = colordata(:,:,z)/max(max(max(colordata(:,:,z)))) ;
        %end
    elseif method == 2
        densite(:,:,z) = log10(colordata(:,:,z)) ;    % /max(max(colordata(:,:,z))) ; %log10
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
meaned = mean(mean(mean(colordata))) ; 

disp(['    |     Mesh X: ' num2str(xmaille) '° ; Y: ' num2str(ymaille) '° ; Z:'  num2str(tranche)  ' km']) ;
disp(['    |     Volume : ' num2str(volumed) ' km^3']) ;
disp(['    |     mean density : ' num2str(meaned) ' km^3']) ;