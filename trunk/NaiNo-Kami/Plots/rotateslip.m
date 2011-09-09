function [h,strike,dip,rake] = rotateslip(h,diameter,GLE,GLN,GLZ,strike,dip,rake,switched,axeswitch)



% OUTPUT FROM FPFIT :
%  84- 86 F3.0, 1X  Dip direction (downdip azimuth in degrees,clockwise from north)
%  88- 89 F2.0      Dip angle in degrees down from horizontal
%  90- 93 F4.0, 2X  Rake in degrees:    0     => left lateral
%                                       90    => reverse, 
%                                       +-180 => right lateral, 
%                                       - 90  => normal
%                   
% FPFIT use the Aki & Richards definition of Strike, Dip, and Rake
% (adapted from page 106 of Aki & Richards (1980), Quantitative Seismology - Vol 1)
% 
% Strike - the fault-trace direction in decimal degrees (0 to 360, relative to North), 
% defined so that the fault dips to the right side of the trace.  That is, the fault 
% always dips to the right when moving along the trace in the strike direction (from 
% one point to the next).  This means that the hanging-wall block is always to the 
% right.  This is important because rake (which gives the slip direction) is defined 
% as the movement of the hanging wall relative to the footwall.  For a vertical, 
% strike slip fault (for which "hanging wall" has no physical meaning) we still call 
% the right-side block the hanging wall to distinguish between right lateral and left 
% lateral motion.
% 
% Dip - the angle of the fault in decimal degrees (0 to 90, relative to horizontal).
% 
% Rake - the direction the hanging wall moves during rupture, measured relative to 
% the fault strike (between -180 and 180 decimal degrees). Rake=0 means the hanging 
% wall, or the right side of a vertical fault, moved in the strike direction (left 
% lateral motion); Rake = +/-180 means the hanging wall moved in the opposite direction 
% (right lateral motion).  Rake>0 means the hanging wall moved up (thrust or reverse
% fault).  Rake<0 means the hanging wall moved down (normal fault).
% 
% Basic Examples:
% 
% Dip = 90 & Rake = 0   -----> left lateral strike slip
% Dip = 90 & Rake = 180 -----> right lateral strike slip
% Dip = 45 & Rake = 90  -----> reverse fault
% Dip = 45 & Rake = -90 -----> normal fault




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transformations %%%%%%%%%%%%%%%%
strike  = (strike - 90);         %
rake = 90 - (-1 * rake);         %
                                 %  
Xdip = diameter * sind(strike) ; %
Ydip = diameter * cosd(strike) ; %
Xrak = Ydip ;                    %
Yrak = -1 * Xdip ;               %
Zrak = diameter * sind(90-dip);  %
                                 %
ORIGIN = [GLE,GLN,GLZ] ;         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% orientation of focal mecanism %%%%%%%%%%%%%%%%%%%%%
rotate(h,[0 0 1]         ,(-1*(strike)),ORIGIN) ;   % strike from north
rotate(h,[Xdip Ydip 0]   ,(dip)        ,ORIGIN) ;   % dip from horiz
rotate(h,[Xrak Yrak Zrak],(rake)  ,ORIGIN) ;        % rake from horiz      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% for slip %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if switched == 0                                       %
    
    x = get(h,'XData') ;                               %
    y = get(h,'YData') ;                               %
    z = get(h,'ZData') ;                               %
    if iscell(x) == 1 ; x = cell2mat(x) ; end
    if iscell(y) == 1 ; y = cell2mat(y) ; end
    if iscell(z) == 1 ; z = cell2mat(z) ; end
    count = 0 ; 
    lon = GLE ; 
    lat = GLN ; 
    alt = GLZ ; 
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
            dist(count) = sqrt((x(1)-x(i,ii))^2 + (Y(1)-y(i,ii))^2 + (Z(1)-z(i,ii))^2 ) ;
            ind1(count) = i ;
            ind2(count) = ii ;
        end
    end
    [val,ind] = max(abs(dist)) ; dist(ind) = 0 ;
    [val,ind] = max(abs(dist)) ;
    
    X(2) = x(ind1(ind),ind2(ind)) ;
    Y(2) = y(ind1(ind),ind2(ind)) ;
    Z(2) = z(ind1(ind),ind2(ind))  ;

    Xswitch = diff(X) ;                       %
    Yswitch = diff(Y) ;                       %
    Zswitch = diff(Z) ;                       %
    axeswitch = [Xswitch Yswitch Zswitch] ;            %
    
    rotate(h,axeswitch,(180)  ,ORIGIN) ;               %   
    X = get(h,'XData') ;                               %
    Y = get(h,'YData') ;                               %
    Z = get(h,'ZData') ;                               %
end                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% inverse nodal plan %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if switched == 1                                       %
    rotate(h,axeswitch,(90)  ,ORIGIN) ;                %   
    X = get(h,'XData') ;                               %
    Y = get(h,'YData') ;                               %
    Z = get(h,'ZData') ;                               %
end                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%













% X = get(h,'XData') ;                               % 
%     Y = get(h,'YData') ;                               %  
%     Z = get(h,'ZData') ;                               %
%     
%     x = X ;
%     y = Y ;
%     z = Z ;
%     lon = GLE ;
%     lat = GLN ; 
%     alt = GLZ ;
%     clear X Y Z
%     
%     count = 0 ;
%     for i =  1 : size(x,1) ;
%         for ii =  1 : size(x,2) ;
%             count = count + 1 ;
%             dist(count) = sqrt((lon-x(i,ii))^2 + (lat-y(i,ii))^2 + (alt-z(i,ii))^2 ) ;
%             ind1(count) = i ;
%             ind2(count) = ii ;
%         end
%     end
%     [val,ind] = min(abs(dist)) ;
%     X(1) = x(ind1(ind),ind2(ind)) ;
%     Y(1) = y(ind1(ind),ind2(ind)) ;
%     Z(1) = z(ind1(ind),ind2(ind)) ;
%     valmem = [ind1(ind) ind2(ind)] ; 
%     count = 0 ; 
%     dist = [] ; 
%     for i =  1 : size(x,1) ;
%         for ii =  1 : size(x,2) ;
%             if abs(sqrt((X(1)-x(i,ii))^2 + (Y(1)-y(i,ii))^2 + (Z(1)-z(i,ii))^2 )) > 0
%                 count = count + 1 ;
%                 dist(count) = sqrt((X(1)-x(i,ii))^2 + (Y(1)-y(i,ii))^2 + (Z(1)-z(i,ii))^2 ) ;
%                 ind1(count) = i ;
%                 ind2(count) = ii ;
%             end
%         end
%     end
%     [val,ind] = min(abs(dist)) ;
%     X(2) = x(ind1(ind),ind2(ind)) ;
%     Y(2) = y(ind1(ind),ind2(ind)) ;
%     Z(2) = z(ind1(ind),ind2(ind)) ;
%     Xswitch = diff(X) ;                       % 
%     Yswitch = diff(Y) ;                       % 
%     Zswitch = diff(Z) ; 
% 
% 
% %     Xswitch = diff(X([1 2],1))                        % 
% %     Yswitch = diff(Y([1 2],1))                        % 
% %     Zswitch = diff(Z([1 2],1))                        %