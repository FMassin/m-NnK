function [h,strike,dip,rake,axeswitch] = rotateFP(h,diameter,GLE,GLN,GLZ,strike,dip,rake,switched)



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


X = get(h,'XData') ;                               %
Y = get(h,'YData') ;                               %
Z = get(h,'ZData') ;                               %
if iscell(X) == 1 ; X = cell2mat(X) ; end
if iscell(Y) == 1 ; Y = cell2mat(Y) ; end
if iscell(Z) == 1 ; Z = cell2mat(Z) ; end
Xswitch = diff(X(1:2,1)) ;                       %
Yswitch = diff(Y(1:2,1)) ;                       %
Zswitch = diff(Z(1:2,1)) ;                       %
axeswitch = [Xswitch Yswitch Zswitch] ;            %

% inverse nodal plan %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if switched == 1                                       %
    rotate(h,axeswitch,(90)  ,ORIGIN) ;                %
    X = get(h,'XData') ;                               %
    Y = get(h,'YData') ;                               %
    Z = get(h,'ZData') ;                               %
end                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%