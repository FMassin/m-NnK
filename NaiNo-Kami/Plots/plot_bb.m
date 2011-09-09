function [a,b] = plot_bb(diameter,lon,lat,alt,strike,dip,rake,vue,colored,ax)

% [a,b] = plot_bb(diameter,lon,lat,alt,strike,dip,rake,vue,colored,ax)


a = [] ;
dim = 8 ;
ORIGIN = [lon,lat,alt] ;  
if exist('ax','var') == 0
    ax = gca ; 
end
if exist('vue','var') == 0
    vue = 1 ; 
end
if exist('colored','var') == 0
    colored = 'b' ; 
end


[X,Y,Z] = sphere(dim)  ;
X = (X * diameter) + lon ;   
Y = (Y * diameter) + lat ;   
Z = (Z * diameter) + alt ;   

hold on 
for i = 1 : size(X,2)-1
    
    for ii = [1:fix(dim/4)]

        x = [X(i,ii) X(i+1,ii) X(i+1,ii+1) X(i,ii+1)] ;
        y = [Y(i,ii) Y(i+1,ii) Y(i+1,ii+1) Y(i,ii+1)] ;
        z = [Z(i,ii) Z(i+1,ii) Z(i+1,ii+1) Z(i,ii+1)] ;

        a(length(a)+1)= fill3(x,y,z,'w','LineStyle','none','Parent',ax) ;

    end
end

for i = 1 : size(X,2)-1
    for ii = 2*fix(dim/4)+1 : 3*fix(dim/4)

        x = [X(i,ii) X(i+1,ii) X(i+1,ii+1) X(i,ii+1)] ;
        y = [Y(i,ii) Y(i+1,ii) Y(i+1,ii+1) Y(i,ii+1)] ;
        z = [Z(i,ii) Z(i+1,ii) Z(i+1,ii+1) Z(i,ii+1)] ;

        a(length(a)+1) = fill3(x,y,z,'w','LineStyle','none','Parent',ax) ;

    end
end

for i = 1 : size(X,2)-1
    for ii = fix(dim/4)+1 : 2*fix(dim/4)

        x = [X(i,ii) X(i+1,ii) X(i+1,ii+1) X(i,ii+1)] ;
        y = [Y(i,ii) Y(i+1,ii) Y(i+1,ii+1) Y(i,ii+1)] ;
        z = [Z(i,ii) Z(i+1,ii) Z(i+1,ii+1) Z(i,ii+1)] ;

        a(length(a)+1) = fill3(x,y,z,'b','FaceColor',colored,'LineStyle','none','Parent',ax) ;

    end
end

for i = 1 : size(X,2)-1
    for ii = 3*fix(dim/4)+1 : dim

        x = [X(i,ii) X(i+1,ii) X(i+1,ii+1) X(i,ii+1)] ;
        y = [Y(i,ii) Y(i+1,ii) Y(i+1,ii+1) Y(i,ii+1)] ;
        z = [Z(i,ii) Z(i+1,ii) Z(i+1,ii+1) Z(i,ii+1)] ;

        a(length(a)+1) = fill3(x,y,z,'b','FaceColor',colored,'LineStyle','none','Parent',ax) ;

    end
end
hold off




rotate(a,[1 0 0],-90,ORIGIN) ;  
rotateFP(a,diameter,lon,lat,alt,strike,dip,rake,0) ; 
if vue == 2 % coupe N-S
    rotate(a,[0 1 0],90,ORIGIN) ;   
elseif vue == 3 % coupe E-W
    rotate(a,[1 0 0],-90,ORIGIN) ;   
end

x = 0 : 2*pi/(dim*2): 2*pi;
z(1:length(x)) = alt ; 
b = [] ; 
%b=plot3(lon+diameter*(sin(x)),lat+diameter*(cos(x)),z,'k','Parent',ax) ;
