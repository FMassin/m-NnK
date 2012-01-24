function map2section

global clust oldclust a dates1 dates2 cumnums clustratio uniqratio neoratio endratio fieldedit   hpp hp


[lat,lon]=ginputm(4);
[distmax1,direct1]= distance([lat(1) lon(1)],[lat(2) lon(2)]);
[distmax2,direct2]= distance([lat(3) lon(3)],[lat(4) lon(4)]);
if abs(direct1-90)>abs(direct2-90)
    lat = [lat(3) lat(4) lat(1) lat(2)];
    lon = [lon(3) lon(4) lon(1) lon(2)];
end


%prepare les truc a ploter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%make room
[hpp] = resizepanels(hp,hpp,1);[time,indeq,lims] = taketime ;
[clust,oldclust]=takeclust(oldclust);
[X,Y,Z,X1,X2,Y1,Y2,Ylat,Maxi,erX,erY,erZ,XX,YY,ZZ,fp,slip,fault] = filtclust(clust,indeq,lims);
[Xu,Yu,Zu,erXu,erYu,erZu,XXu,YYu,ZZu,C2u,to] = addisolate(lims);
if numel(X)==0 ; disp('There is nothing to plot !');return;end
latlim =[nanmin(nanmin(nanmin([erY erYu]))) nanmax(nanmax(nanmax([erY erYu])))] ;
lonlim =[nanmin(nanmin(nanmin([erX erXu]))) nanmax(nanmax(nanmax([erX erXu])))] ;
%scales
[poub,answer]=system(['./distance.pl ' num2str([ nanmean(lonlim) nanmean(latlim) nanmean(lonlim)+1 nanmean(latlim) ])]);
kmlon=abs(str2num(answer));
[poub,answer]=system(['./distance.pl ' num2str([ nanmean(lonlim) nanmean(latlim) nanmean(lonlim) nanmean(latlim)+1 ])]);
kmlat=abs(str2num(answer));
%
[loclatlab,pas]=plot_tick(latlim);
[loclonlab,pas]=plot_tick(lonlim);
%color
C2 = hsv(fix(sum(sum(1-isnan(X2(1,:))))));
C2=[C2(fix(sum(sum(1-isnan(X2(1,:))))*3/4)+1:sum(sum(1-isnan(X2(1,:)))),:) ; C2(1:fix(sum(sum(1-isnan(X2(1,:))))*3/4),:)];
inds(1:size(X2,2))=1;
inds(logical(1-isnan(X2(1,:)))) = 1:size(C2,1);
%
ax(2)=subplot(2,10,[6:10],'parent',hpp(end),'layer','top');
axes(ax(2));
ax(2)=usamap(latlim, lonlim);
states = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
geoshow(ax(2), states, 'FaceColor', 'none')
lablat = [states.LabelLat];
lablon = [states.LabelLon];
tf = ingeoquad(lablat, lablon, lims(2,:)', lims(1,:)');
textm(lablat(tf), lablon(tf), {states(tf).Name},'HorizontalAlignment', 'center');
setm(ax(2),'flinewidth',1,'PLabelMeridian','east','MLabelParallel','north','MLabelLocation',loclonlab,'PLabelLocation',loclatlab)
set(ax(2),'layer','top')
plot_Yell(ax(2)) % redbox a finir
% FILL axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(ax(2));hold on;
% MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot3m(YY,erX,(ZZ+nanmin(nanmin(ZZ)))./(6371),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(2));
plot3m(erY,XX,(ZZ+nanmin(nanmin(ZZ)))./(6371),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(2));
if numel(YYu) > 0
    % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot3m(YYu,erXu,(ZZu+nanmin(nanmin(ZZu)))./(6371),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(2));
    plot3m(erYu,XXu,(ZZu+nanmin(nanmin(ZZu)))./(6371),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(2));
end
for ii=1:size(Xu,2);
    % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot3m(Yu(:,ii),Xu(:,ii),min(Zu(:,:)./(6371)),'o','color',C2u((ii),:),'parent',ax(2));
end
for i=1:size(X,3);
    for ii=1:size(X,2);
        % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot3m(Y(:,ii,i),X(:,ii,i),Z(:,ii,i)./(6371),'ok','MarkerFaceColor',C2(inds(ii),:),'parent',ax(2));
    end
end
[lat(1:2),lon(1:2)]
[lat(3:4),lon(3:4)]
plot3m(lat(1:2),lon(1:2),repmat(nanmax(nanmax(Z)./(6371)),2,1),'r-','linewidth',2)
plot3m(lat(3:4),lon(3:4),repmat(nanmax(nanmax(Z)./(6371)),2,1),'g-','linewidth',2)
hold off

[ax(1)]=plot_customsection(hpp,'bottom',lat(1:2),lon(1:2),X,Y,Z,X1,X2,Y1,Y2,Ylat,Maxi,erX,erY,erZ,XX,YY,ZZ,fp,slip,fault,Xu,Yu,Zu,erXu,erYu,erZu,XXu,YYu,ZZu,C2u,to);
[ax(3)]=plot_customsection(hpp,'west',lat(3:4),lon(3:4),X,Y,Z,X1,X2,Y1,Y2,Ylat,Maxi,erX,erY,erZ,XX,YY,ZZ,fp,slip,fault,Xu,Yu,Zu,erXu,erYu,erZu,XXu,YYu,ZZu,C2u,to);


ax(4)=subplot(2,10,11:14,'parent',hpp(end));
ax(5)=subplot(2,10,15,'parent',hpp(end),'yaxislocation','right');

% dendrogram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(ax(4))
hold on;
h=plot(X1,Y1,'-','color',[0.6 0.6 0.6 ],'parent',ax(4));
for i=1:size(Y2,2)
    tmp=plot(X2(:,i),Y2(:,i),'.','color',C2(inds(i),:),'parent',ax(4));h=[h; tmp];
end
% add eruption/swarm
axis tight ; loc=pwd;cd ~/PostDoc_Utah/Datas/eruptions;Farrell_2007(ax(4),get(ax(4),'xlim'),get(ax(4),'ylim'));cd(loc)
hold off
ylabel('{\bf Cluster ID}')
if exist('limx','var')==1; set(a(end),'xlim',limx);end
plot_gooddatetick(ax(4))
% histogram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(ax(5));
h=barh(Y1(1,:),Ylat,'stack');box on; grid on;xlabel('{\bf Number of eq.}');set(ax(5),'yaxislocation','right');
linkaxes(ax(4:5),'y')
    



function [ax]=plot_customsection(hpp,position,lat,lon,X,Y,Z,X1,X2,Y1,Y2,Ylat,Maxi,erX,erY,erZ,XX,YY,ZZ,fp,slip,fault,Xu,Yu,Zu,erXu,erYu,erZu,XXu,YYu,ZZu,C2u,to)

ax=[];
latlim =[nanmin(nanmin(nanmin([erY erYu]))) nanmax(nanmax(nanmax([erY erYu])))] ;
lonlim =[nanmin(nanmin(nanmin([erX erXu]))) nanmax(nanmax(nanmax([erX erXu])))] ;
%scales
[~,answer]=system(['./distance.pl ' num2str([ nanmean(lonlim) nanmean(latlim) nanmean(lonlim)+1 nanmean(latlim) ])]);
kmlon=abs(str2num(answer));
[~,answer]=system(['./distance.pl ' num2str([ nanmean(lonlim) nanmean(latlim) nanmean(lonlim) nanmean(latlim)+1 ])]);
kmlat=abs(str2num(answer));


if strcmp(position,'bottom') ==1
    [lat(1:2),ind]=sort(lat(1:2)); lon(1:2)=lon(ind);
    [lon(1:2),ind]=sort(lon(1:2)); lat(1:2)=lat(ind);
elseif strcmp(position,'west') ==1
    [lon(1:2),ind]=sort(lon(1:2)); lat(1:2)=lat(ind);
    [lat(1:2),ind]=sort(lat(1:2)); lon(1:2)=lon(ind);
end
[distmax,direct]= distance([lat(1) lon(1)],[lat(2) lon(2)]);
%scale
kmperdeg=(kmlon/cosd(direct)) ;


[XX]=map2section_1(direct,[lon(1) lat(1)],XX,YY,distmax);
[XXu]=map2section_1(direct,[lon(1) lat(1)],XXu,YYu,distmax);
[X]=map2section_1(direct,[lon(1) lat(1)],X,Y,distmax);
[Xu]=map2section_1(direct,[lon(1) lat(1)],Xu,Yu,distmax);
[erX]=map2section_1(direct,[lon(1) lat(1)],erX,YY,distmax);
[erXu]=map2section_1(direct,[lon(1) lat(1)],erXu,YYu,distmax);
[erY]=map2section_1(direct,[lon(1) lat(1)],XX,erY,distmax);
[erYu]=map2section_1(direct,[lon(1) lat(1)],XXu,erYu,distmax);


% PREPARE STUFF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tight lims
lonlim = [ 0 map2section_1(direct,[lon(1) lat(1)],lon(2),lat(2),distmax)];
if strcmp(position,'bottom') ==1
    [lonlab]=plot_tick(min(lon)+(lonlim*sind(direct)),2);
    lonloc=(lonlab-min(lon))/sind(direct);
    hemi='W E';
    lonlab = [num2str(sign(lonlab').*lonlab') repmat('°',length(lonlab),1) hemi(2+sign(lonlab))'];
elseif strcmp(position,'west') ==1
    [lonlab]=plot_tick(min(lat)+(lonlim*cosd(direct)),2);
    lonloc=(lonlab-min(lat))/cosd(direct);
    hemi='S N';
    lonlab = [num2str(sign(lonlab').*lonlab') repmat('°',length(lonlab),1) hemi(2+sign(lonlab))'];
end

deplim =[nanmin(nanmin(nanmin([erZ(isnan(erX)==0) ; erZu(isnan(erXu)==0)]))) 3.5] ;
[locdeplab,pas]=plot_tick(deplim);
%color
C2 = hsv(fix(sum(sum(1-isnan(X2(1,:))))));
C2=[C2(fix(sum(sum(1-isnan(X2(1,:))))*3/4)+1:sum(sum(1-isnan(X2(1,:)))),:) ; C2(1:fix(sum(sum(1-isnan(X2(1,:))))*3/4),:)];
inds(1:size(X2,2))=1;
inds(logical(1-isnan(X2(1,:)))) = 1:size(C2,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if strcmp(position,'bottom') ==1

    ax=subplot(2,10,[16:20],'parent',hpp(end),'layer','top','xlim',lonlim,'ylim',deplim,'XColor','r','YAxisLocation','right','xtick',lonloc,'xticklabel',lonlab,'ytick',locdeplab);
    daspect([1 kmperdeg 1]); box on ; grid on;eval('ylabel(''{\bf Depth [km]}'')' )
    
    hold on
    plot3(erY,ZZ,-1*(YY+nanmax(nanmax(YY))),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(1));
    plot3(erX,ZZ,-1*(YY+nanmax(nanmax(YY))),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(1));
    plot3(XX,erZ,-1*(YY+nanmax(nanmax(YY))),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(1));
    
    plot3(erYu,ZZu,-1*(YYu+nanmax(nanmax(YYu))),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(1));
    plot3(erXu,ZZu,-1*(YYu+nanmax(nanmax(YYu))),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(1));
    plot3(XXu,erZu,-1*(YYu+nanmax(nanmax(YYu))),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(1));
    
    for ii=1:size(Xu,2);
        plot3(Xu(:,ii),Zu(:,ii),min(-1*Yu(:,:)),'o','color',C2u((ii),:),'parent',ax(1));
    end
    
    for i=1:size(X,3);
        for ii=1:size(X,2);
            plot3(X(:,ii,i),Z(:,ii,i),-1*Y(:,ii,i),'ok','MarkerFaceColor',C2(inds(ii),:),'parent',ax(1));
        end
    end
    hold off
elseif strcmp(position,'west') ==1
    
    ax=subplot(2,10,[1:5],'parent',hpp(end),'layer','top','ylim',lonlim,'xlim',deplim,'YColor','g','XAxisLocation','top','xtick',locdeplab,'ytick',lonloc,'yticklabel',lonlab);
    daspect([kmperdeg 1  1]); box on ; grid on;eval('xlabel(''{\bf Depth [km]}'')' )

    hold on
    plot3(ZZ,erY,-1*(YY+nanmax(nanmax(YY))),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(1));
    plot3(ZZ,erX,-1*(YY+nanmax(nanmax(YY))),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(1));
    plot3(erZ,XX,-1*(YY+nanmax(nanmax(YY))),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(1));
    
    plot3(ZZu,erYu,-1*(YYu+nanmax(nanmax(YYu))),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(1));
    plot3(ZZu,erXu,-1*(YYu+nanmax(nanmax(YYu))),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(1));
    plot3(erZu,XXu,-1*(YYu+nanmax(nanmax(YYu))),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(1));
    
    for ii=1:size(Xu,2);
        plot3(Zu(:,ii),Xu(:,ii),min(-1*Yu(:,:)),'o','color',C2u((ii),:),'parent',ax(1));
    end
    
    for i=1:size(X,3);
        for ii=1:size(X,2);
            plot3(Z(:,ii,i),X(:,ii,i),-1*Y(:,ii,i),'ok','MarkerFaceColor',C2(inds(ii),:),'parent',ax(1));
        end
    end
    hold off
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [X]=map2section_1(direct,orig,X,Y,distmax)
if numel(X)~=0
    AZ=X;
    D=X;
    sectionAZ = repmat(direct,size(X)) ;
    REFlon = repmat(orig(1),size(X)) ;
    REFlat = repmat(orig(2),size(X)) ;
    [test1,test2] = distance(repmat(REFlat(:,1),size(X,2),1), repmat(REFlon(:,1),size(X,2),1), reshape(Y,numel(X),1), reshape(X,numel(X),1));
    AZ(1:numel(X))= test2;
    D(1:numel(X))= test1;
    X= cosd( AZ-sectionAZ ) .* D ;
    if exist('distmax','var')==1
        X(abs(X)>distmax)=NaN;
    end
    X(X<0)=NaN;
end
