function [leslip,obj,T1,P1] = drawslip(diameter,lon,lat,alt,strike,dip,rake,ax,cas)


if exist('cas','var') == 0
    cas = 3 ; 
end
obj = [] ;

leslip = [] ;

T1 = [] ; 
P1 = [] ; 


%diameter = diameter/2 ;
x(1:2) = [lon-diameter lon] ;
y(1:2) = [lat-diameter/100 lat+diameter/100] ;
z(1,1:2) = [alt alt] ;
z(2,1:2) = [alt alt] ;
% 
% x(1:2) = [lon lon] ;
% y(1:2) = [lat-diameter lat+diameter] ;
% z(1:2) = [alt alt] ;

if cas == 1 | cas == 3     % plan auxiliaire 1
    obj = surf(x, y, z) ;
    switched = 0 ; 
    obj1 = rotateslip(obj,diameter*2,lon,lat,alt,strike,dip,rake,switched) ;
    leslip(1:2,1:2,1) = get(obj1,'XData')' ;
    leslip(1:2,1:2,2) = get(obj1,'YData')' ;
    leslip(1:2,1:2,3) = get(obj1,'ZData')' ;

    S1 = strike ;
    D1 = dip ;
    R1 = rake ;
    
    [T1,P1] = slip(leslip([2 1],1,1:3)) ; 
end

if cas == 2 | cas == 3          % plan auxiliaire 2
    obj = surf(x, y, z) ;
    switched = 1 ; 
    obj2 = rotateslip(obj,diameter*2,lon,lat,alt,strike,dip,rake,switched) ;
    leslip(1:2,1:2,1) = get(obj2,'XData')' ;
    leslip(1:2,1:2,2) = get(obj2,'YData')' ;
    leslip(1:2,1:2,3) = get(obj2,'ZData')' ;
        
    [T1,P1] = slip(leslip([2 1],1,1:3)) ;
end

if cas == 3
    obj = [obj1 obj2] ;
elseif cas == 1
    obj = obj1 ; 
elseif cas == 2
    obj = obj2 ; 
end


