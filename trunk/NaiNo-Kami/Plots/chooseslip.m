function [trend,plunge,Strike,Dip,Rake,flag,rms,largeclust,fig] = chooseslip(strike,dip,rake,X,Y,Z,scales)



trend = [] ; 
plunge = [] ;
M = sqrt((max(X)-min(X))^2 + (max(Y)-min(Y))^2 +(max(Z)-min(Z))^2) ; 
 

[verts,fig,ax] = getvolumdims(X,Y,Z) ; 
drawball(M/5,nanmean(X),nanmean(Y),nanmean(Z),strike,dip,rake,1,'b',ax,scales) ; 
% 0.002248529622398,55.715179749999997,-21.233970750000001,0.005931818181818,250,61,135,1,ax
[S1,D1,R1,S2,D2,R2,data1,data2,a] = drawplan(M,mean(X),mean(Y),mean(Z),strike,dip,rake,1,ax,scales) ; 
%close(fig);




rms1 = 0 ; 
rms2 = 0 ; 
for j = 1 : size(verts,1)
    dist1 = zeros(size(data1,1)*size(data1,2),1) ;
    dist2 = dist1 ; 
    count = 0 ; 
    for i = 1 : size(data1,1)
        for ii = 1 : size(data1,2)
            count = count  +1 ; 
            dist1(count) = (verts(j,1)-data1(i,ii,1))^2 + (verts(j,2)-data1(i,ii,1))^2 + (verts(j,3)-data1(i,ii,1))^2 ;
            dist2(count) = (verts(j,1)-data2(i,ii,1))^2 + (verts(j,2)-data2(i,ii,1))^2 + (verts(j,3)-data2(i,ii,1))^2 ;
        end
    end
    rms1 = rms1 + min(dist1) ; 
    rms2 = rms2 + min(dist2) ; 
end

if rms1 < rms2
    disp('No switch')
    rms = rms1 ; 
    [verts,fig,ax] = getvolumdims(X,Y,Z) ;
    hold on
    drawball((nanmax(X)-nanmin(X))/5,nanmean(X),nanmean(Y),nanmean(Z),strike,dip,rake,1,'b',ax) ;
    [S1,D1,R1,S2,D2,R2,data1,data2,a,trend,plunge] = drawplan((nanmax(X)-nanmin(X)),nanmean(X),nanmean(Y),nanmean(Z),strike,dip,rake,1,ax,1) ;
    Strike = S1 ; 
    Dip = D1 ; 
    Rake = R1 ; 
    flag = 1 ;
else
    disp('Switch')
    rms = rms2 ;
    [verts,fig,ax] = getvolumdims(X,Y,Z) ;
    hold on
    drawball((max(X)-min(X))/5,nanmean(X),nanmean(Y),nanmean(Z),strike,dip,rake,1,'b',ax) ;
    [S1,D1,R1,S2,D2,R2,data1,data2,a,trend,plunge ] = drawplan((nanmax(X)-nanmin(X)),nanmean(X),nanmean(Y),nanmean(Z),strike,dip,rake,1,ax,2) ;
    Strike = S2 ; 
    Dip = D2 ; 
    Rake = R2 ; 
    flag = 2 ; 
end

largeclust = ((max(verts(:,1)) - min(verts(:,1)))^2 + ...
    (max(verts(:,2)) - min(verts(:,2)))^2 + ...
    (max(verts(:,3)) - min(verts(:,3)))^2)*(size(verts,1)*size(data1,1)*size(data1,2)) ;
axes(ax)
arrow3D(trend,plunge,M,mean(X),mean(Y),mean(Z),'r','3D',ax) ; 



view(3)
axis image
grid on