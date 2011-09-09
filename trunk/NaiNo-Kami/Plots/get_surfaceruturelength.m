function [D,RL,RW,RA,Dis,cas]= get_surfaceruturelength(Mcum,D,R)

% see:
% D.L. Wells and K.J. Coppersmith, 
% New empirical relationships among magnitude, rupture length, rupture 
% width, rupture area, and surface displacement, 
% Bulletin of the Seismological Society of America 84 (1994), 
% no. 4, 974?1002.


if (R>=45 & R<=135) | (R>=225 & R<=315) % TRUST fault
    a1=-0.74;    b1=0.8;
    a2=-1.61;    b2=0.41;
    a3=-3.99;    b3=0.98;
    a4=-2.86;    b4=0.63;
    cas='trust';
elseif ((R>-45 & R<45) | (R>135 & R<225)) & (D>=45 & D<=135)  % STRIKE SLIP
    a1=-6.32;    b1=0.9;
    a2=-0.76;    b2=0.2;
    a3=-3.42;    b3=0.90;
    a4=-3.55;    b4=0.74;
    cas='strike slip';
else % NORMAL fault
    a1=-4.45;    b1=0.63;
    a2=-1.14;    b2=0.35;
    a3=-2.87;    b3=0.82;
    a4=-2.01;    b4=0.50;
    cas='normal';
end
    
Dis= 10.^(a1+b1*Mcum) ;

RW = 10.^(3+(a2+b2*Mcum)) ;

RA = 10.^(3+(a3+b3*Mcum)) ;

RL = 10.^(3+(a4+b4*Mcum)) ;

D = 2*(RA/(pi)).^0.5;

    