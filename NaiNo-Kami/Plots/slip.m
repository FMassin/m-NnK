function [T,P,Ptest] = slip(leslip,lon,lat,alt) 


x = leslip(:,:,1) ; 
y = leslip(:,:,2) ; 
z = leslip(:,:,3) ; 

count = 0 ; 
for i =  1 : size(x,1) ; 
    for ii =  1 : size(x,2) ;
        count = count + 1 ;  
        dist(count) = sqrt((lon-x(i,ii))^2 + (lat-y(i,ii))^2 + (alt-z(i,ii))^2 ) ; 
        ind1(count) = i ; 
        ind2(count) = ii ; 
    end
end
[val,ind] = min(abs(dist)) ;
X(1) = x(ind1(ind),ind2(ind)) ; 
Y(1) = y(ind1(ind),ind2(ind)) ; 
Z(1) = z(ind1(ind),ind2(ind)) ;
count = 0 ;
dist = [] ;
for i =  1 : size(x,1) ; 
    for ii =  1 : size(x,2) ;
        count = count + 1 ;  
        dist(count) = sqrt((X(1)-x(i,ii))^2 + (Y(1)-y(i,ii))^2 + (Z(1)-z(i,ii))^2 ) ; 
        ind1(count) = i ; 
        ind2(count) = ii ; 
    end
end 
[val,ind] = max(abs(dist)) ; dist(ind) = 0 ; 
[val,ind] = max(abs(dist)) ; 

X(2) = x(ind1(ind),ind2(ind)) ;
Y(2) = y(ind1(ind),ind2(ind)) ;
Z(2) = z(ind1(ind),ind2(ind))  ;

hypR = sqrt(diff(X)^2 + diff(Y)^2 + diff(Z)^2) ;
hypH = sqrt(diff(Y)^2 + diff(X)^2) ;
adjH = diff(Y) ;


T = real(acosd(adjH/hypH)) ;
P = real(acosd(hypH/hypR)) ;

hypR = sqrt((X(1)-lon)^2 + (Y(1)-lat)^2 + (Z(1)-alt)^2) ;
hypH = sqrt((X(1)-lon)^2 + (Y(1)-lat)^2) ;
Ptest = real(acosd(hypH/hypR));

if Z(1) < alt
    Ptest = abs(Ptest) ; 
else
    Ptest = -1*abs(Ptest); 
end

if Z(2) == Z(1)
    P = 0 ;
end
if X(2) == X(1)
    T = 0 ;
end
if Y(2) == Y(1)
    T = 0 ;
end
if Z(2) < Z(1)
    P = abs(P) ; 
else
    P = -1*abs(P); 
end
if X(2) < X(1)
    T = -1*abs(T) ; 
else
    T = abs(T) ; 
end

    

