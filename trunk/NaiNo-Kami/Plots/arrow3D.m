function [flch] = arrow3D(T,P,M,X,Y,Z,colored,cut,ax)

if exist('ax','var') == 1
    axes(ax) ;
else
    gca ;
end
large = 1/30 ;
enverg = 15 ;
flech = 1/2 ;
if exist('cut','var') == 0
    cut = '3D' ;
end
if exist('colored','var') == 0
    colored = 'b' ;
end
if exist('M','var') == 0
    M = ones(size(T,1),size(T,2)) ;
end
if length(T) ~= length(P) & length(T) ~= length(M)
    disp('trend et plunge n ont pas des dimensions identiques')
end
if exist('X','var') == 0
    X = 1 ;
    Y = 1 ;
    Z = 1 ;
end
P = -1*P ;

npt = 10 ;

hold on
for i = 1 : length(T)
    if strcmp(char(cut),'3D') == 1

        [xx,yy,zz] = makefleche(M(i),X(i),Y(i),Z(i),npt) ; 
        [xx,yy,zz] = rotatedata(xx,yy,zz,[1 0 0],-90+P(i),[X(i) Y(i) Z(i)]) ;       % pendage
        [xx,yy,zz] = rotatedata(xx,yy,zz,[0 0 1],-1*T(i),[X(i) Y(i) Z(i)]) ;   % azimuth

        flch(i,1) = surf(xx(4:6,:),yy(4:6,:),zz(4:6,:),'edgecolor','none','facecolor',colored);
        flch(i,2) = surf(xx(1:3,:),yy(1:3,:),zz(1:3,:),'edgecolor','none','facecolor','k');
        %flch(i,3) = (plot3(xx(5,:)',yy(5,:)',zz(5,:)','-k'))' ;


    elseif strcmp(char(cut),'map') == 1
        
        [xx,yy,zz] = makefleche(M(i),X(i),Y(i),Z(i),npt) ;
        [xx,yy,zz] = rotatedata(xx,yy,zz,[1 0 0],-90,[X(i) Y(i) Z(i)]) ;       % pendage
        [xx,yy,zz] = rotatedata(xx,yy,zz,[0 0 1],-1*T(i),[X(i) Y(i) Z(i)]) ;   % azimuth

        flch(i,1) = surf(xx(4:6,:),yy(4:6,:),zz(4:6,:),'edgecolor','none','facecolor',colored);
        flch(i,2) = surf(xx(1:3,:),yy(1:3,:),zz(1:3,:),'edgecolor','none','facecolor','k');
        flch(i,3) = (plot3(xx(5,:)',yy(5,:)',zz(5,:)','-k'))' ;
        flch(i,4:5) = (plot3(xx(:,[1 fix(npt/2)+1]),yy(:,[1 fix(npt/2)+1]),zz(:,[1 fix(npt/2)+1]),'-k'))' ;
        

    elseif strcmp(char(cut),'NS') == 1
        
        P(i) = -1*P(i) + 90 ;
        if (T(i) >= -90 && T(i) <= 90)  
            P(i) = P(i) ; 
        elseif (T(i) >= 270 && T(i) <= 450)
            P(i) = P(i) ; 
        else
            P(i) = -1*P(i) ;
        end

        [xx,yy,zz] = makefleche(M(i),X(i),Y(i),Z(i),npt) ;
        [xx,yy,zz] = rotatedata(xx,yy,zz,[1 0 0],-90,[X(i) Y(i) Z(i)]) ;       % pendage
        [xx,yy,zz] = rotatedata(xx,yy,zz,[0 0 1],270,[X(i) Y(i) Z(i)]) ;   % azimuth
        [xx,yy,zz] = rotatedata(xx,yy,zz,[0 0 1],P(i),[X(i) Y(i) Z(i)]) ;   % azimuth

        flch(i,1) = surf(xx(4:6,:),yy(4:6,:),zz(4:6,:),'edgecolor','none','facecolor',colored);
        flch(i,2) = surf(xx(1:3,:),yy(1:3,:),zz(1:3,:),'edgecolor','none','facecolor','k');
        flch(i,3) = (plot3(xx(5,:)',yy(5,:)',zz(5,:)','-k'))' ;
        flch(i,4:5) = (plot3(xx(:,[1 fix(npt/2)+1]),yy(:,[1 fix(npt/2)+1]),zz(:,[1 fix(npt/2)+1]),'-k'))' ;
        
    elseif strcmp(char(cut),'EW') == 1

        P(i) = P(i) + 90 ;
        if (T(i) >= 180 && T(i) <= 360)  
            P(i) = -1*P(i) ; 
        elseif (T(i) >= -180 && T(i) <= 0)  
            P(i) = -1*P(i) ; 
        else
            P(i) = P(i) ;
        end
        
        [xx,yy,zz] = makefleche(M(i),X(i),Y(i),Z(i),npt) ;
        [xx,yy,zz] = rotatedata(xx,yy,zz,[1 0 0],-90,[X(i) Y(i) Z(i)]) ;       % pendage
        [xx,yy,zz] = rotatedata(xx,yy,zz,[0 0 1],180,[X(i) Y(i) Z(i)]) ;   % azimuth
        [xx,yy,zz] = rotatedata(xx,yy,zz,[0 0 1],P(i),[X(i) Y(i) Z(i)]) ;   % azimuth
        
        flch(i,1) = surf(xx(4:6,:),yy(4:6,:),zz(4:6,:),'edgecolor','none','facecolor',colored);
        flch(i,2) = surf(xx(1:3,:),yy(1:3,:),zz(1:3,:),'edgecolor','none','facecolor','k');
        flch(i,3) = (plot3(xx(5,:)',yy(5,:)',zz(5,:)','-k'))' ;
        flch(i,4:5) = (plot3(xx(:,[1 fix(npt/2)+1]),yy(:,[1 fix(npt/2)+1]),zz(:,[1 fix(npt/2)+1]),'-k'))' ;
        
    end

end
end

%%
function [xx,yy,zz] = makefleche(M,X,Y,Z,npt)
h = M/2 ; 
lq = M/50 ;
lt = M/7 ;  

[xqueue(2:3,:),yqueue(2:3,:),zqueue(2:3,:)] = cylinder(lq,npt) ;
zqueue(3,:) = h ;
xqueue = xqueue + X ; yqueue = yqueue + Y ; zqueue = zqueue + Z ;
xqueue(1,:) = X ; yqueue(1,:) = Y ; zqueue(1,:) = Z ;

[xtete(2:3,:),ytete(2:3,:),ztete(2:3,:)] = cylinder(lt,npt) ;
xtete(2,:) = xtete(2,:) + X ; ytete(2,:) = ytete(2,:) + Y ; ztete(2,:) = ztete(2,:) + Z + h ;
xtete(3,:) = X ;
ytete(3,:) = Y ;
ztete(3,:) = Z+M ;
xtete(1,:) = X ; ytete(1,:) = Y ; ztete(1,:) = Z + h ;

xx = [xqueue ; xtete] ;
yy = [yqueue ; ytete] ;
zz = [zqueue ; ztete] ;
end