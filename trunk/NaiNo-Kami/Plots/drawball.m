function [a,b,XYXred,XYXgreen] = drawball(diameter,lon,lat,alt,strike,dip,rake,vue,colored,ax,scales)

% [a,b] = drawball(diameter,lon,lat,alt,strike,dip,rake,vue,colored,ax)

a = [] ;b = [] ;XYXred = [] ;XYXgreen = [] ;

if numel(strike) > 0
    a = [] ;
    dim = 8 ;
    ORIGIN = [lon,lat,alt] ;
    if exist('ax','var') == 0
        ax = gca ;
    end
    if exist('scales','var') == 0
        scales = [1 1 1];
    end
    if exist('colored','var') == 0 ; colored= ['bw']';end
    if size(colored,2) == 1
        if size(colored,1) == 1
            colored(2,1)='w';
        end
    elseif size(colored,2) == 3
        if size(colored,1) == 1
            colored(2,1:3)= [0 0 0];
        end
    end
    if strcmp(colored,'none') ==1
        colored(2,:)='none';
    end
    axes(ax);hold on
    
    [X,Y,Z] = sphere(dim)  ;
    X = (X * diameter) + lon ;
    Y = (Y * diameter) + lat ;
    Z = (Z * diameter) + alt ;
    
    % Faces tensions
    for i = 1 : size(X,2)-1
        for ii = [1:fix(dim/4)]
            
            x = [X(i,ii) X(i+1,ii) X(i+1,ii+1) X(i,ii+1)] ;
            y = [Y(i,ii) Y(i+1,ii) Y(i+1,ii+1) Y(i,ii+1)] ;
            z = [Z(i,ii) Z(i+1,ii) Z(i+1,ii+1) Z(i,ii+1)] ;
            
            a(length(a)+1)= fill3(x,y,z,'k','FaceColor',colored(2,:),'LineStyle','none','Parent',ax) ;
            
        end
    end
    
    for i = 1 : size(X,2)-1
        for ii = 2*fix(dim/4)+1 : 3*fix(dim/4)
            
            x = [X(i,ii) X(i+1,ii) X(i+1,ii+1) X(i,ii+1)] ;
            y = [Y(i,ii) Y(i+1,ii) Y(i+1,ii+1) Y(i,ii+1)] ;
            z = [Z(i,ii) Z(i+1,ii) Z(i+1,ii+1) Z(i,ii+1)] ;
            
            a(length(a)+1) = fill3(x,y,z,'k','FaceColor',colored(2,:),'LineStyle','none','Parent',ax) ;
            
        end
    end
    
    % Faces compressions
    for i = 1 : size(X,2)-1
        for ii = fix(dim/4)+1 : 2*fix(dim/4)
            
            x = [X(i,ii) X(i+1,ii) X(i+1,ii+1) X(i,ii+1)] ;
            y = [Y(i,ii) Y(i+1,ii) Y(i+1,ii+1) Y(i,ii+1)] ;
            z = [Z(i,ii) Z(i+1,ii) Z(i+1,ii+1) Z(i,ii+1)] ;
            
            a(length(a)+1) = fill3(x,y,z,'k','FaceColor',colored(1,:),'LineStyle','none','Parent',ax) ;
            
        end
    end
    
    for i = 1 : size(X,2)-1
        for ii = 3*fix(dim/4)+1 : dim
            
            x = [X(i,ii) X(i+1,ii) X(i+1,ii+1) X(i,ii+1)] ;
            y = [Y(i,ii) Y(i+1,ii) Y(i+1,ii+1) Y(i,ii+1)] ;
            z = [Z(i,ii) Z(i+1,ii) Z(i+1,ii+1) Z(i,ii+1)] ;
            
            a(length(a)+1) = fill3(x,y,z,'k','FaceColor',colored(1,:),'LineStyle','none','Parent',ax) ;
            
        end
    end
    
    
    
    
    
    x = 0 : 2*pi/(dim*2): 2*pi;
    xx= x(1:fix(end/2)+1) ;
    xy= x(fix(end/2)+1:end) ;
    z(1:length(x)) = alt ;
    b = [] ;
    b(1)=fill3(lon+diameter*(sin(xx)),repmat(lat,1,length(xx)),alt+diameter*(cos(xx)),'k','Parent',ax,'linewidth',2,'FaceColor','r') ;
    b(2)=fill3(repmat(lon,1,length(x)),lat+diameter*(cos(x)),z+diameter*(sin(x)),'k','Parent',ax,'linewidth',2,'FaceColor','g') ;
    b(4)=fill3(lon+diameter*(sin(xy)),repmat(lat,1,length(xy)),alt+diameter*(cos(xy)),'k','Parent',ax,'linewidth',2,'FaceColor','r') ;
    
    
    
    
    
    
    b(3)=plot3(lon+diameter*(sin(x)),lat+diameter*(cos(x)),z,'k','Parent',ax) ;
    
    
    % if vue == 2 % coupe N-S
    % elseif vue == 3 % coupe E-W
    % end
    
    rotate(a,[1 0 0],-90,ORIGIN) ;
    rotate(b(1),[1 0 0],-90,ORIGIN) ;
    rotate(b(2),[1 0 0],-90,ORIGIN) ;
    rotate(b(4),[1 0 0],-90,ORIGIN) ;
    
    rotateFP(a,diameter,lon,lat,alt,strike,dip,rake,0) ;
    rotateFP(b(1),diameter,lon,lat,alt,strike,dip,rake,0) ;
    rotateFP(b(2),diameter,lon,lat,alt,strike,dip,rake,0) ;
    rotateFP(b(4),diameter,lon,lat,alt,strike,dip,rake,0) ;
    
    if vue == 2 % coupe N-S
        rotate(a,[0 1 0],90,ORIGIN) ;
        rotate(b(2),[0 1 0],90,ORIGIN) ;
        rotate(b(1),[0 1 0],90,ORIGIN) ;
        rotate(b(4),[0 1 0],90,ORIGIN) ;
    elseif vue == 3 % coupe E-W
        rotate(a,[1 0 0],-90,ORIGIN) ;
        rotate(b(1),[1 0 0],-90,ORIGIN) ;
        rotate(b(2),[1 0 0],-90,ORIGIN) ;
        rotate(b(4),[1 0 0],-90,ORIGIN) ;
    end
    
    
    stretch(a,scales,ORIGIN);
    stretch(b,scales,ORIGIN);
    
    XYXred = [cell2mat(get(b([1 4]),'XData'))  cell2mat(get(b([1 4]),'YData')) cell2mat(get(b([1 4]),'ZData'))];
    XYXred = [XYXred(1:8,:) ; XYXred(10:end,:)];
    XYXgreen = [(get(b(2),'XData'))  (get(b(2),'YData')) (get(b(2),'ZData'))] ;
    
end

