function rose3D(T,P,M,D,X,Y,Z,cut,colored,patate)

if exist('cut','var') == 0
    cut = 'map' ;
end
if exist('colored','var') == 0
    colored = 'b' ;
end
if exist('M','var') == 0
    M = ones(size(T,1),size(T,2)) ;
end
if exist('P','var') == 0
    P = zeros(size(T,1),size(T,2)) ;
end
if length(T) ~= length(P) & length(T) ~= length(M) 
    disp('trend et plunge n ont pas des dimensions identiques')
end
if exist('D','var') == 0
    D = 1 ; 
end
if exist('X','var') == 0
    X = 1 ; 
    Y = 1 ;
    Z = 1 ;
end
nAnglesH=36 ;
nAnglesV=18 ;
shift = 0.1*D ; 

sectH = linspace(0,360,nAnglesH+1) ;
sectV = linspace(-90,90,nAnglesV+1); 
deltH = (sectH(2)-sectH(1)) /2 ; 
deltV = (sectV(2)-sectV(1)) /2 ;
magnitude = zeros(length(sectH),length(sectV)) ; 
numberofevent = zeros(length(sectH),length(sectV)) ; 
Xsector = zeros(4,length(sectH),length(sectV)) * X ; 
Ysector = zeros(4,length(sectH),length(sectV)) * Y ; 
Zsector = zeros(4,length(sectH),length(sectV)) * Z ; 
disp(['Number of raw event : ' num2str(length(T)) ])
for i = 1:length(T)
    flag = 0 ;
    for j = 1:length(sectH)
        if (T(i) >= sectH(j)-deltH & T(i) <= sectH(j)+deltH) | (T(i)-360 >= sectH(j)-deltH & T(i)-360 <= sectH(j)+deltH) | (T(i)+360 >= sectH(j)-deltH & T(i)+360 <= sectH(j)+deltH)
    
            for k = 1:length(sectV)
                if P(i) >= sectV(k)-deltV & P(i) <= sectV(k)+deltV
                    
                    magnitude(j,k) =  magnitude(j,k) + M(i) ;
                    numberofevent(j,k) = numberofevent(j,k) + 1 ; 
                    flag = 1 ;
                    break
                end
            end
        end
        if flag == 1
            break
        end
    end
end
disp(['Number of drawn event : ' num2str(sum(sum(numberofevent))) ])
[valeur,colonne] = max(max(magnitude)) ; 
[valeur,ligne] = max(magnitude(:,colonne)) ; 
magnitude = D*magnitude./max(max(magnitude)) ; 


for i = 1:length(sectH)
    for j = 1:length(sectV)
        if magnitude(i,j) > 0
            if sectV(j)-deltV >= 0 & sectV(j)+deltV > 0 
                coeff1 = -1 ;
                coeff2 = -1 ;
            elseif sectV(j)-deltV < 0 & sectV(j)+deltV >= 0 
                coeff1 = -1 ;
                coeff2 = 1 ;
            elseif sectV(j)-deltV <= 0 & sectV(j)+deltV < 0 
                coeff1 = 1 ;
                coeff2 = 1 ;
            end
            r = magnitude(i,j) ; 
            rprojete1 = magnitude(i,j)*cosd(sectV(j)-deltV) ;
            rprojete2 = magnitude(i,j)*cosd(sectV(j)+deltV) ;

            n = 1 ;
            Xsector(n,i,j) = X ; Ysector(n,i,j) = Y ; Zsector(n,i,j) = Z ;
            
            n = 2 ;
            Xsector(n,i,j) = X+ cosd(sectH(i)-deltH-90) * rprojete1;
            Ysector(n,i,j) = Y+ (-1*sind(sectH(i)-deltH-90) * rprojete1) ;
            %Zsector(n,i,j) = Z+ (-1*tand(sectV(j)-coeff*deltV) * rprojete1) ;
            Zsector(n,i,j) = Z+ coeff1* ((r^2) - (rprojete1^2))^0.5 ;
            n = 3 ;
            Xsector(n,i,j) = X+ cosd(sectH(i)+deltH-90) * rprojete1 ;
            Ysector(n,i,j) = Y+ (-1*sind(sectH(i)+deltH-90) * rprojete1) ;
            %Zsector(n,i,j) = Z+ (-1*tand(sectV(j)-coeff*deltV) * rprojete1) ;
            Zsector(n,i,j) = Z+ coeff1* ((r^2) - (rprojete1^2))^0.5 ;
            
            n = 4 ;
            Xsector(n,i,j) = X+ cosd(sectH(i)+deltH-90) * rprojete2 ;
            Ysector(n,i,j) = Y+ (-1*sind(sectH(i)+deltH-90) * rprojete2) ;
            %Zsector(n,i,j) = Z+ (-1*sind(sectV(j)+coeff*deltV) * rprojete2) ;
            Zsector(n,i,j) = Z+ coeff2* ((r^2) - (rprojete2^2))^0.5 ;
            
            n = 5 ;
            Xsector(n,i,j) = X+ cosd(sectH(i)-deltH-90) * rprojete2;
            Ysector(n,i,j) = Y+ (-1*sind(sectH(i)-deltH-90) * rprojete2) ;
            %Zsector(n,i,j) = Z+ (-1*sind(sectV(j)+coeff*deltV) * rprojete2) ;
            Zsector(n,i,j) = Z+ coeff2* ((r^2) - (rprojete2^2))^0.5 ;
            
            if i == ligne & j == colonne
                if sectV(j) <= 0 & sectH(i) < 90  % dessus NE
                    coeff3 = 1 ;
                    coeff4 = 1 ; 
                    coeff5 = 1 ; 
                    coeff6 = 0 ; 
                    
                elseif sectV(j) <= 0 & sectH(i) >= 90 & sectH(i) < 180  % dessus SE
                    coeff3 = 1 ;
                    coeff4 = -1 ; 
                    coeff5 = 1 ; 
                    coeff6 = 0 ; 
                    
                elseif sectV(j) <= 0 & sectH(i) >= 180 & sectH(i) < 270  % dessus SW
                    coeff3 = -1 ;
                    coeff4 = -1 ; 
                    coeff5 = 1 ;
                    coeff6 = -0.45 ; 
                    
                elseif sectV(j) <= 0 & sectH(i) >= 270  % dessus NW
                    coeff3 = -1 ;
                    coeff4 = 1 ; 
                    coeff5 = 1 ;
                    coeff6 = -0.45 ; 
                    
                elseif sectV(j) > 0 &  sectH(i) < 90  % dessous NE
                    coeff3 = 1 ;
                    coeff4 = 1 ; 
                    coeff5 = -1 ; 
                    coeff6 = 0 ; 
                    
                elseif sectV(j) > 0 & sectH(i) >= 90 & sectH(i) < 180  % dessous SE
                    coeff3 = 1 ;
                    coeff4 = -1 ; 
                    coeff5 = -1 ; 
                    coeff6 = 0 ; 
                    
                elseif sectV(j) > 0 & sectH(i) >= 180 & sectH(i) < 270  % dessous SW
                    coeff3 = -1 ;
                    coeff4 = -1 ; 
                    coeff5 = -1 ;
                    coeff6 = -0.45 ; 
                    
                elseif sectV(j) > 0 & sectH(i) >= 270  % dessous NW
                    coeff3 = -1 ;
                    coeff4 = 1 ; 
                    coeff5 = -1 ;
                    coeff6 = -0.45 ; 
                    
                end
                Xline = [ mean(Xsector(2:5,i,j)) mean(Xsector(2:5,i,j))+coeff3*shift ] ;
                Yline = [ mean(Ysector(2:5,i,j)) mean(Ysector(2:5,i,j))+coeff4*shift ] ;  
                Zline = [ mean(Zsector(2:5,i,j)) mean(Zsector(2:5,i,j))+coeff5*shift ] ;
            end
            
        end
    end
end


hold on
for i = 1:length(sectH)
    for j = 1:length(sectV)
        if magnitude(i,j) > 0
            ind = [1 2 3 1] ;
            fill3(Xsector(ind,i,j),Ysector(ind,i,j),Zsector(ind,i,j),char(colored))
            ind = [1 2 5 1] ;
            fill3(Xsector(ind,i,j),Ysector(ind,i,j),Zsector(ind,i,j),char(colored))
            ind = [1 3 4 1] ;
            fill3(Xsector(ind,i,j),Ysector(ind,i,j),Zsector(ind,i,j),char(colored))
            ind = [1 5 4 1] ;
            fill3(Xsector(ind,i,j),Ysector(ind,i,j),Zsector(ind,i,j),char(colored))
            ind = [2 3 4 5 2] ;
            fill3(Xsector(ind,i,j),Ysector(ind,i,j),Zsector(ind,i,j),char(colored))
        end
    end
end
line(Xline,Yline,Zline,'color','k')
text(Xline(2)+coeff6*D,Yline(2),Zline(2),[num2str(numberofevent(ligne,colonne)) ' ' patate])
t0=[0:360];


% graduations mineures horizon 
symb(1:length(sectH),1) = ':' ; symb(1:length(sectH),2) = 'k' ;
%symb(1:fix((nAnglesH/2)*(90/180)):length(sectH),1) = '-' ; symb(1:fix((nAnglesH/2)*(90/180)):length(sectH),2) = 'k' ;

for i= 1:length(sectH)
    
    z(1:length(t0)) = Z-D ;
    x(1:length(t0)) = X ;
    y(1:length(t0)) = linspace(Y-D,Y+D,length(t0));
    c(i+1) = plot3(x,y,z,':','Color',[0.8 0.8 0.8]) ;
    rotate(c(i+1),[0 90],sectH(i)-deltH,[X Y Z]);
    
    if strcmp(char(cut),'map') == 1
        if (sectH(i)) > 180
            coef = -1*D*1.4/10 ;
        elseif (sectH(i)) <= 180 & (sectH(i)) > 0
            coef = D*0/10 ;
        elseif (sectH(i)) == 0 | (sectH(i)) == 180
            coef = 0 ;
        end

        text(X+coef+D*1.05*cosd(sectH(i)-deltH-90),Y+(-1)*D*1.05*sind(sectH(i)-deltH-90),Z,[num2str(sectH(i)-deltH) '°'])
    end
    if strcmp(char(cut),'dip') == 1
        
        if (sectH(i)) > 90
            coef = -1*D*0.2/10 ;
        elseif (sectH(i)) <= 90 & (sectH(i)) >= 0
            coef = D*0/10 ;
        elseif (sectH(i)) == 270 | (sectH(i)) == 90
            coef = 0 ;
        end

        if sectH(i) >270 & sectH(i) <360
            text(X+coef+D*1.04*cosd(sectH(i)-deltH-90),Y+(-1)*D*1.05*sind(sectH(i)-deltH-90),Z,[num2str(sectH(i)-deltH-360) '°'])
        elseif sectH(i) >=0 & sectH(i) <=90
            text(X+coef+D*1.05*cosd(sectH(i)-deltH-90),Y+(-1)*D*1.05*sind(sectH(i)-deltH-90),Z,[num2str(sectH(i)-deltH) '°'])
        end
    end
end

% cercles et graduations majeures vertical 

for i = 0 : 3
    z(1:length(t0)) = Z ;
    x = X + D*cosd(t0);
    y = Y + D*sind(t0);
    c(i+1) = plot3(x,y,z,'k') ;
    rotate(c(i+1),[-90 0],90,[X Y Z])
    rotate(c(i+1),[0 90],90*i,[X Y Z])
    if (90*i) > 180
        coef = -1*D*1.4/10 ; 
    elseif (90*i) < 180 & (90*i) > 0
        coef = D*0/10 ; 
    elseif (90*i) == 0 | (90*i) == 180
        coef = 0 ; 
    end
    if strcmp(char(cut),'map') == 1
        dirs='NESW';
        text(X+coef+D*1.15*cosd(90*i-90),Y+(-1)*D*1.15*sind(90*i-90),Z,[num2str(dirs(1+i))])
    end
    if strcmp(char(cut),'dip') == 1
        dirs='hnhz';
        text(X+coef+D*1.15*cosd(90*i-90),Y+(-1)*D*1.15*sind(90*i-90),Z,[num2str(dirs(1+i))])
    end
end
coef = -1*D*1.4/10 ; 
% if strcmp(char(cut),'map') == 1
%     text(X+coef+D*1.05*cosd(270-90),Y+(-1)*D*1.05*sind(270-90),Z,[num2str(270) '°'])
% end

maximum = max(max(numberofevent));
for i=1:maximum-1
    z(1:length(t0)) = Z-D ;
    x = X + D*cosd(t0)*i/maximum;
    y = Y + D*sind(t0)*i/maximum;
    c(length(c)+1)=plot3(x,y,z,':','Color',[0.8 0.8 0.8]);
end

if strcmp(char(cut),'map') == 1 | strcmp(char(cut),'dip') == 1
    z(1:length(t0)) = Z-D ;
    x = X + D*cosd(t0);
    y = Y + D*sind(t0);
elseif strcmp(char(cut),'NS') == 1
    z(1:length(t0)) = Z ;
    x = X+D + D*cosd(t0);
    y = Y + D*sind(t0);
elseif strcmp(char(cut),'EW') == 1
    z(1:length(t0)) = Z-D ;
    x = X + D*cosd(t0);
    y = Y-D + D*sind(t0);
end

c(length(c)+1) = fill3(x,y,z,'w') ;
%alpha(c(length(c)),0.7) ; 

if strcmp(char(cut),'NS') == 1 
    rotate(c(length(c)),[-90 0],90,[X+D Y Z])
elseif strcmp(char(cut),'EW') == 1 
    rotate(c(length(c)),[0 0],90,[X Y-D Z])
elseif strcmp(char(cut),'dip') == 1 
    view(90,90)
end


axis equal
axis tight
axis off
 