function [S1,D1,R1,S2,D2,R2,leplan1,leplan2,obj,T,P,FP1,FP2] = drawplan(diameter,lon,lat,alt,strike,dip,rake,colored,ax,cas,noslip,coupe)


if exist('cas','var') == 0
    cas = 3 ; 
end
if exist('noslip','var') == 0
    noslip = 0 ; 
end
if exist('coupe','var') == 0
    coupe = '  ' ; 
end

axes(ax) ; 
obj = [] ;

leplan1 = [] ;
leplan2 = [] ; 

S1 = [] ; 
D1 = [] ; 
R1 = [] ; 

S2 = [] ; 
D2 = [] ; 
R2 = [] ; 

T1 = [] ;
P1 = [] ;
T2 = [] ;
P2 = [] ;
T = [] ; 
P = [] ; 


diameter = diameter/2 ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for plan
x(1:5) = [lon lon lon lon lon] ;
y(1:5) = [lat-diameter lat+diameter lat+diameter lat-diameter lat-diameter] ;
z(1:5) = [alt+diameter alt+diameter alt-diameter alt-diameter alt+diameter] ;
if strcmp(coupe,'map') == 1 | strcmp(coupe,'NS') == 1 | strcmp(coupe,'EW') == 1
    z(1:5) = alt ; 
end

c(1:2,1:2) = colored ;
C = colored ; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for slip
xs1(1:2) = [lon-diameter/4 lon-diameter/4] ;
ys1(1:2) = [lat-diameter/100 lat+diameter/100] ;
zs1(1,1:2) = [alt alt+diameter] ;
zs1(2,1:2) = [alt alt+diameter] ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xs2(1:2) = [lon+diameter/4 lon+diameter/4] ;
ys2(1:2) = [lat-diameter/100 lat+diameter/100] ;
zs2(1,1:2) = [alt-diameter alt] ;
zs2(2,1:2) = [alt-diameter alt] ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if cas == 1 | cas == 3     % plan auxiliaire 1
    %PLAN0 = surf(x, y, z, c) ;
    PLAN0 = fill3(x, y, z, C,'EdgeColor','none');
    %set(PLAN0,'Linestyle','none') ;
    switched = 0 ; 
    [FP1,pob1,pob2,pob3,axeswitch] = rotateFP(PLAN0,diameter*2,lon,lat,alt,strike,dip,rake,switched) ;
    if strcmp(coupe,'NS') == 1 
        rotate(FP1,[0 1 0],90,[lon lat alt]) ; 
    elseif strcmp(coupe,'EW') == 1 
        rotate(FP1,[1 0 0],-90,[lon lat alt]) ;
    end
        
    leplan1(1:5) = get(FP1,'XData') ;
    leplan1(1:5) = get(FP1,'YData') ;
    leplan1(1:5) = get(FP1,'ZData') ;
    

    if noslip == 0
        slip11 = surf(xs1, ys1, zs1) ;
        slip12 = surf(xs2, ys2, zs2) ;
        slip11 = rotateslip(slip11,diameter*2,lon,lat,alt,strike,dip,rake,switched,axeswitch) ;
        slip12 = rotateslip(slip12,diameter*2,lon,lat,alt,strike,dip,rake,switched,axeswitch) ;

        leslip11(1:2,1:2,1) = get(slip11,'XData')' ;
        leslip11(1:2,1:2,2) = get(slip11,'YData')' ;
        leslip11(1:2,1:2,3) = get(slip11,'ZData')' ;
        [T,P,Ptest] = slip(leslip11,lon,lat,alt) ;

        if Ptest >= 0
            disp('conjugue')
            P = -1*P ;
            if T >= 180 ; T = T -180 ; else ; T = T + 180 ; end
        end
    end
end

if cas == 2 | cas == 3          % plan auxiliaire 2
    %PLAN0 = surf(x, y, z, c./2) ;
    PLAN0 = fill3(x, y, z,C,'EdgeColor','none');
    %set(PLAN0,'Linestyle','none') ;
    switched = 1 ; 
    [FP2,pob1,pob2,pob3,axeswitch] = rotateFP(PLAN0,diameter*2,lon,lat,alt,strike,dip,rake,switched) ;
    if strcmp(coupe,'NS') == 1 
        rotate(FP2,[0 1 0],90,[lon lat alt]) ; 
    elseif strcmp(coupe,'EW') == 1 
        rotate(FP2,[1 0 0],-90,[lon lat alt]) ;
    end
    leplan2(1:5) = get(FP2,'XData') ;
    leplan2(1:5) = get(FP2,'YData') ;
    leplan2(1:5) = get(FP2,'ZData') ;
        
    if noslip == 0
        slip21 = surf(xs1, ys1, zs1) ;
        slip22 = surf(xs2, ys2, zs2) ;
        slip21 = rotateslip(slip21,diameter*2,lon,lat,alt,strike,dip,rake,switched,axeswitch) ;
        slip22 = rotateslip(slip22,diameter*2,lon,lat,alt,strike,dip,rake,switched,axeswitch) ;

        leslip21(1:2,1:2,1) = get(slip21,'XData')' ;
        leslip21(1:2,1:2,2) = get(slip21,'YData')' ;
        leslip21(1:2,1:2,3) = get(slip21,'ZData')' ;
        [T,P,Ptest] = slip(leslip21,lon,lat,alt) ;

        if Ptest >= 0
            disp('conjugue')
            P = -1*P ;
            if T >= 180 ; T = T - 180 ; else ; T = T + 180 ; end
        end
    end
end

if cas == 3
    obj = [FP1 FP2] ;
elseif cas == 1
    obj = FP1 ; 
elseif cas == 2
    obj = FP2 ; 
end


