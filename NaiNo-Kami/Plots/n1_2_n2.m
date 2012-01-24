function [strike2,dip2,rake2]=n1_2_n2(strike1,dip1,rake1)

strike1 = strike1+90;
strike2=[];dip2=[];rake2=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dip2 = acosd(sind(dip1)*sind(rake1)) ; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rake2]=rigthquadrant( -1*cosd(rake1)*sind(dip1)/sind(dip2) , cosd(dip1)/sind(dip2) ) ; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[diffstrike]=rigthquadrant( -1/(tand(dip1)*tand(dip2)) , cosd(rake1)/sind(dip2) ) ; 
strike2 = -1*(diffstrike-strike1);

if dip2 > 90
    dip2=180-dip2;
    rake2=360-rake2;
    if strike2<180
        strike2=strike2+180;
    elseif strike2>=180
        strike2=strike2-180;
    end
end

if strike2<=0
    strike2=strike2+360;
elseif strike2>=360
    strike2=strike2-360;
end

strike2 = strike2-90;

 






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [degrees]=rigthquadrant(thecosd,thesind)

if sign(thesind)>=0 & sign(thecosd)>=0
    degrees = acosd(thecosd);
    %   | X
    %---|---
    %   |
elseif sign(thesind)==-1 & sign(thecosd)>=0
    degrees = 360-acosd(thecosd);
    %   | 
    %---|---
    %   | X
elseif sign(thesind)==-1 & sign(thecosd)==-1
    degrees = 360-acosd(thecosd);
    %   | 
    %---|---
    % X |
elseif sign(thesind)>=0 & sign(thecosd)==-1
    degrees = acosd(thecosd);
    % X | 
    %---|---
    %   |
end
