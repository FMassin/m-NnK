function map2section

global clust oldclust a dates1 dates2 cumnums clustratio uniqratio neoratio endratio fieldedit   hpp hp


[lat,lon]=ginputm(2);
[lat,ind]=sort(lat); lon=lon(ind);
[lon,ind]=sort(lon); lat=lat(ind);
[distmax,direct]= distance([lat(1) lon(1)],[lat(2) lon(2)]);

%prepare les truc a ploter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%make room
[hpp] = resizepanels(hp,hpp,1);[time,indeq,lims] = taketime ;
[clust,oldclust]=takeclust(oldclust);
[X,Y,Z,X1,X2,Y1,Y2,Ylat,Maxi,erX,erY,erZ,XX,YY,ZZ,fp,slip,fault] = filtclust(clust,indeq,lims);
[Xu,Yu,Zu,erXu,erYu,erZu,XXu,YYu,ZZu,C2u,to] = addisolate(lims);
if numel(X)==0 ; disp('There is nothing to plot !');return;end
latlim =[nanmin(nanmin(nanmin([erY erYu]))) nanmax(nanmax(nanmax([erY erYu])))] ;
lonlim =[nanmin(nanmin(nanmin([erX erXu]))) nanmax(nanmax(nanmax([erX erXu])))] ;
[loclatlab,pas]=plot_tick(latlim);
[loclonlab,pas]=plot_tick(lonlim);
%color
C2 = hsv(fix(sum(sum(1-isnan(X2(1,:))))));
C2=[C2(fix(sum(sum(1-isnan(X2(1,:))))*3/4)+1:sum(sum(1-isnan(X2(1,:)))),:) ; C2(1:fix(sum(sum(1-isnan(X2(1,:))))*3/4),:)];
inds(1:size(X2,2))=1;
inds(logical(1-isnan(X2(1,:)))) = 1:size(C2,1);
%scales
[poub,answer]=system(['./distance.pl ' num2str([ nanmean(lonlim) nanmean(latlim) nanmean(lonlim)+1 nanmean(latlim) ])]);
kmlon=abs(str2num(answer));
[poub,answer]=system(['./distance.pl ' num2str([ nanmean(lonlim) nanmean(latlim) nanmean(lonlim) nanmean(latlim)+1 ])]);
kmlat=abs(str2num(answer));
%
ax(2)=subplot(2,10,[6:10],'parent',hpp(end),'layer','top');
axes(ax(2));
ax(2)=usamap(latlim, lonlim);
states = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
geoshow(ax(2), states, 'FaceColor', 'none')
lablat = [states.LabelLat];
lablon = [states.LabelLon];
tf = ingeoquad(lablat, lablon, lims(2,:)', lims(1,:)');
textm(lat(tf), lon(tf), {states(tf).Name},'HorizontalAlignment', 'center');
setm(ax(2),'flinewidth',1,'PLabelMeridian','east','MLabelParallel','north','MLabelLocation',loclonlab,'PLabelLocation',loclatlab)
set(ax(2),'layer','top')
plot_Yell(ax(2)) % redbox a finir
% FILL axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(ax(2));hold on;
% % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot3m(YY,erX,(ZZ+nanmin(nanmin(ZZ)))./(6371),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(2));
% plot3m(erY,XX,(ZZ+nanmin(nanmin(ZZ)))./(6371),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(2));
% if numel(YYu) > 0
%     % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     plot3m(YYu,erXu,(ZZu+nanmin(nanmin(ZZu)))./(6371),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(2));
%     plot3m(erYu,XXu,(ZZu+nanmin(nanmin(ZZu)))./(6371),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(2));
% end
% for ii=1:size(Xu,2);
%     % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     plot3m(Yu(:,ii),Xu(:,ii),min(Zu(:,:)./(6371)),'o','color',C2u((ii),:),'parent',ax(2));
% end
% for i=1:size(X,3);
%     for ii=1:size(X,2);
%         % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         plot3m(Y(:,ii,i),X(:,ii,i),Z(:,ii,i)./(6371),'ok','MarkerFaceColor',C2(inds(ii),:),'parent',ax(2));
%     end
% end
plot3m(lat,lon,repmat(nanmax(nanmax(Zu)./(6371)),2,1),'r-','linewidth',2)
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
lonlim =[nanmin(nanmin(nanmin([erX erXu erY erYu]))) nanmax(nanmax(nanmax([erX erXu erY erYu])))] ;
deplim =[nanmin(nanmin(nanmin([erZ(isnan(erX)==0) ; erZu(isnan(erXu)==0)]))) 3.5] ;
%color
C2 = hsv(fix(sum(sum(1-isnan(X2(1,:))))));
C2=[C2(fix(sum(sum(1-isnan(X2(1,:))))*3/4)+1:sum(sum(1-isnan(X2(1,:)))),:) ; C2(1:fix(sum(sum(1-isnan(X2(1,:))))*3/4),:)];
inds(1:size(X2,2))=1;
inds(logical(1-isnan(X2(1,:)))) = 1:size(C2,1);
%ticks
[loclonlab,pas]=plot_tick(lonlim);
[locdeplab,pas]=plot_tick(deplim);
%scale
kmperdeg=(kmlon*abs(sind(direct))+kmlat*abs(cosd(direct)))/(abs(sind(direct))+abs(cosd(direct)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



ax(1)=subplot(1,10,[1:5],'parent',hpp(end),'layer','top','xlim',lonlim,'ylim',deplim,'xtick',loclonlab,'ytick',locdeplab);
daspect([1 kmperdeg 1]); box on ; grid on;plot_goodgeotick(ax(1),'ST',kmperdeg)

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






function [X]=map2section_1(direct,orig,X,Y,distmax)
AZ=X;
sectionAZ = repmat(direct,size(X)) ;
REFlon = repmat(orig(1),size(X)) ;
REFlat = repmat(orig(2),size(X)) ;
test = azimuth([repmat(REFlat(:,1),size(X,2),1) reshape(Y,numel(X),1)], [repmat(REFlon(:,1),size(X,2),1) reshape(X,numel(X),1)]);
AZ(1:numel(X))= test;
X= cosd( AZ-sectionAZ ) .* ( (REFlon-X).^2 + (REFlat-Y).^2 ).^0.5 ;
if exist('distmax','var')==1
    X(X>distmax)=NaN;
end

