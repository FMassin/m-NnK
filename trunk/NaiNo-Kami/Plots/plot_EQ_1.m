function plot_EQ_1(in)
global clust oldclust a dates1 dates2 cumnums clustratio uniqratio neoratio endratio fieldedit   hpp hp



fortitle = '';
xlab = '' ;

%prepare les truc a ploter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[time,indeq,lims] = taketime ;
[clust,oldclust]=takeclust(oldclust);
[X,Y,Z,X1,X2,Y1,Y2,Ylat,Maxi,erX,erY,erZ,XX,YY,ZZ,fp,slip,fault] = filtclust(clust,indeq,lims);
[Xu,Yu,Zu,erXu,erYu,erZu,XXu,YYu,ZZu,C2u,to] = addisolate(lims);
if numel(X)==0 ; disp('There is nothing to plot !');return;end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% PREPARE STUFF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tight lims
latlim =[nanmin(nanmin(nanmin([erY erYu]))) nanmax(nanmax(nanmax([erY erYu])))] ;
lonlim =[nanmin(nanmin(nanmin([erX erXu]))) nanmax(nanmax(nanmax([erX erXu])))] ;
deplim =[nanmin(nanmin(nanmin([erZ erZu]))) 3.5] ;
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
%ticks
[loclatlab,pas]=plot_tick(latlim);
[loclonlab,pas]=plot_tick(lonlim);
[locdeplab,pas]=plot_tick(deplim);
%make room
[hpp] = resizepanels(hp,hpp,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




if in==1 | in == 3 | in == 5
    % PRE-SET axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if in ==1 | in==3
        ax(1)=subplot(2,10,[6:10],'parent',hpp(end),'layer','top');
        ax(2)=subplot(2,10,[16:20],'parent',hpp(end),'layer','top');
        ax(3)=subplot(2,10,[1:5],'parent',hpp(end),'layer','top');
    else
        ax(1)=subplot(1,10,[6:10],'parent',hpp(end),'layer','top'); 
    end
    % SET axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    axes(ax(1));    
    ax(1)=usamap(latlim, lonlim);
    states = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
    geoshow(ax(1), states, 'FaceColor', 'none')
    lat = [states.LabelLat];
    lon = [states.LabelLon];
    tf = ingeoquad(lat, lon, latlim, lonlim);
    textm(lat(tf), lon(tf), {states(tf).Name},'HorizontalAlignment', 'center');
    if in==1 | in == 3
        setm(ax(1),'flinewidth',1,'PLabelMeridian','east','MLabelParallel','north','MLabelLocation',loclonlab,'PLabelLocation',loclatlab)
    else
        setm(ax(1),'flinewidth',1,'MLabelLocation',loclonlab,'PLabelLocation',loclatlab)
    end
    set(ax(1),'layer','top')
    plot_Yell(gca)%,[-111.2 -110.7 44.75 44.8]
    if in==1 | in == 3
        % E-W cross-section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        axes(ax(2));
        set(ax(2),'xlim',lonlim,'ylim',deplim,'xtick',loclonlab,'ytick',locdeplab,'YAxisLocation','right','layer','top')
        daspect([1 kmlon 1]); box on ; grid on;plot_goodgeotick(ax(2),'EW')
        % N-S cross-section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        axes(ax(3));
        set(ax(3),'xlim',deplim,'ylim',latlim,'xtick',locdeplab,'ytick',loclatlab,'XAxisLocation','top','layer','top')
        daspect([kmlat 1 1]); box on ; grid on;plot_goodgeotick(ax(3),'NS')
    end
end
    
    
if in == 2
    % Z-slices of density %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [data,Xval,Yval,Zval,colordata] = getdensityhypo(X(isnan(X)==0),Y(isnan(Y)==0),Z(isnan(Z)==0),diff(deplim)/9,min([diff(lonlim)/20,diff(latlim)/20]),min([diff(lonlim)/20,diff(latlim)/20]));
    for i=1:8 %size(data,3)
        ax(i)=subplot(3,3,i,'parent',hpp(end));
        %latlim = [latlim(1)-diff(latlim)/25 latlim(2)+diff(latlim)/25];
        %lonlim = [lonlim(1)-diff(lonlim)/25 lonlim(2)+diff(lonlim)/25];
        ax(i)=usamap(latlim, lonlim);
        states = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
        geoshow(ax(i), states, 'FaceColor', 'none')
        lat = [states.LabelLat];
        lon = [states.LabelLon];
        tf = ingeoquad(lat, lon, latlim, lonlim);
        textm(lat(tf), lon(tf), {states(tf).Name},'HorizontalAlignment', 'center');
        setm(ax(i),'MLabelLocation',loclonlab,'PLabelLocation',loclatlab,'flinewidth',1)
        %'PLabelMeridian','east','MLabelParallel','north',
        pcolorm(Yval, Xval, colordata(:,:,i))
        title(['{\bf Depth ' num2str(Zval(i)) 'km}'])
    end
    ax(9)=subplot(3,3,9,'parent',hpp(end));
    axis off
    t=colorbar('Location','SouthOutside');
    set(get(t,'xlabel'),'String', 'Seismic density [eq./km^3]');
    hlink = linkprop(ax,'CLim');
    caxis([min(min(min(colordata))) max(max(max(colordata)))])

    
elseif in == 3
    % FILL axes with density %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [data,Xval,Yval,Zval,colordata] = ...
        getdensityhypo(X(isnan(X)==0),Y(isnan(Y)==0),Z(isnan(Z)==0),...
        min([kmlon*diff(lonlim)/20,kmlat*diff(latlim)/20]),min([diff(lonlim)/20,diff(latlim)/20]),min([diff(lonlim)/20,diff(latlim)/20]));
    
    % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    axes(ax(1)); hold on;
    pcolorm(Yval, Xval, sum(colordata,3)./length(Zval));
    hold off;
    %shading interp
    
    % E-W cross-section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    axes(ax(2));hold on;
    s=pcolor(Xval, Zval, reshape(sum(colordata,1)./length(Yval),length(Xval),length(Zval))');
    hold off;
    set(s,'EdgeColor','none')
    %shading interp
    
    % N-S cross-section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    axes(ax(3)); hold on;
    s=pcolor(Zval, Yval, reshape(sum(colordata,2)./length(Xval),length(Zval),length(Yval))');
    hold off;
    set(s,'EdgeColor','none')
    %shading interp
    
    ax(4)=subplot(2,10,11:15,'parent',hpp(end)); axis off
    t=colorbar('Location','SouthOutside');
    set(get(t,'xlabel'),'String', 'Seismic density [eq./km^3]');
    hlink = linkprop(ax([1 2 3 4]),'CLim');

elseif in == 4
    % isosurface %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pasz=1;%min([kmlon*diff(lonlim)/10,kmlat*diff(latlim)/10]);
    pash=1/110;%min([diff(lonlim)/10,diff(latlim)/10]);
    [data,Xval,Yval,Zval,colordata] = ...
        getdensityhypo(X(isnan(X)==0),Y(isnan(Y)==0),Z(isnan(Z)==0),...
        pasz,pash,pash);
    
    Xval = repmat(reshape(Xval,1,length(Xval),1),[size(colordata,1) 1 size(colordata,3)]);
    Yval = repmat(reshape(Yval,length(Yval),1,1),[ 1 size(colordata,2) size(colordata,3)]);
    Zval = repmat(reshape(Zval,1,1,length(Zval)),[size(colordata,1) size(colordata,2) 1]);
    
    ax(1)=subplot(1,10,[1:9],'parent',hpp(end),'layer','top');  hold on; 
    %plot_Yell(ax)
    
%     sx= [] ; % min(verts(:,1));
%     sy= [] ; %nanmedian(verts(:,2));
%     sz= [ -13 -8  -3];
%     s=slice(Xval,Yval,Zval,colordata,sx,sy,sz);
%     set(s,'EdgeColor','none', 'DiffuseStrength',.8)
%     drawnow
    
    maxi =nanmean(nanmean(colordata)) ;
    m = repmat(maxi,size(colordata,1),size(colordata,2)) ;
    maxi = max(max(max(m))) ;
    V=100*(colordata-m)./maxi;
    test=V(isnan(V)==0);
    iso= nanmedian(test)+1.5*std(test); 
    textitle = ['p-1D = ' num2str(iso) '%'] ;    disp(['case 3 iso = ' textitle])
    [faces,verts,colors] = isosurface(Xval*kmlon,Yval*kmlat,Zval,V,iso,colordata);
    verts(:,1) = verts(:,1)./kmlon ; 
    verts(:,2) = verts(:,2)./kmlat ; 
    p = patch('Vertices', verts, 'Faces', faces, 'FaceVertexCData', colors, 'FaceColor', 'interp', 'EdgeColor', 'none');
%     isonormals(Xval,Yval,Zval,V,p);
    set(p, 'FaceColor', 'interp', 'EdgeColor', 'none');
    hold off; grid on;
    daspect([1/kmlon 1/kmlat  1]);
    
    
    ax(2)=subplot(1,10,10,'parent',hpp(end),'layer','top');    axis off;
    t=colorbar;
    set(get(t,'ylabel'),'String', 'Seismic density [eq./km^3]');
    hlink = linkprop(ax([1 2]),'CLim');
    
elseif in ==1 | in == 5 % earthquakes map and sections
    % FILL axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    axes(ax(1));hold on;if in==1;axes(ax(2));hold on;axes(ax(3));hold on;end

    % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot3m(YY,erX,(ZZ+nanmin(nanmin(ZZ)))./(6371),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(1));
    plot3m(erY,XX,(ZZ+nanmin(nanmin(ZZ)))./(6371),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(1));
    if in ==1
        % E-W cross-section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot3(erX,ZZ,-1*(YY+nanmax(nanmax(YY))),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(2));
        plot3(XX,erZ,-1*(YY+nanmax(nanmax(YY))),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(2));
        % N-S cross-section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot3(ZZ,erY,-1*(XX-nanmin(nanmin(XX))),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(3));
        plot3(erZ,YY,-1*(XX-nanmin(nanmin(XX))),'-','color',[0.4 0.4 0.4 ],'linewidth',2,'parent',ax(3));
    end    
    if numel(YYu) > 0
        % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot3m(YYu,erXu,(ZZu+nanmin(nanmin(ZZu)))./(6371),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(1));
        plot3m(erYu,XXu,(ZZu+nanmin(nanmin(ZZu)))./(6371),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(1));
        if in ==1
            % E-W cross-section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot3(erXu,ZZu,-1*(YYu+nanmax(nanmax(YYu))),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(2));
            plot3(XXu,erZu,-1*(YYu+nanmax(nanmax(YYu))),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(2));
            % N-S cross-section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot3(ZZu,erYu,-1*(XXu-nanmin(nanmin(XXu))),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(3));
            plot3(erZu,YYu,-1*(XXu-nanmin(nanmin(XXu))),'-','color',[0.8 0.8 0.8 ],'linewidth',2,'parent',ax(3));
        end
    end
    for ii=1:size(Xu,2);
        % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot3m(Yu(:,ii),Xu(:,ii),min(Zu(:,:)./(6371)),'o','color',C2u((ii),:),'parent',ax(1));
        if in ==1
            % E-W cross-section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot3(Xu(:,ii),Zu(:,ii),min(-1*Yu(:,:)),'o','color',C2u((ii),:),'parent',ax(2));
            % N-S cross-section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot3(Zu(:,ii),Yu(:,ii),min(-1*Xu(:,:)),'o','color',C2u((ii),:),'parent',ax(3));
        end
    end
    for i=1:size(X,3);
        for ii=1:size(X,2);
            % MAP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            plot3m(Y(:,ii,i),X(:,ii,i),Z(:,ii,i)./(6371),'ok','MarkerFaceColor',C2(inds(ii),:),'parent',ax(1));
            if in ==1
                % E-W cross-section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                plot3(X(:,ii,i),Z(:,ii,i),-1*Y(:,ii,i),'ok','MarkerFaceColor',C2(inds(ii),:),'parent',ax(2));
                % N-S cross-section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                plot3(Z(:,ii,i),Y(:,ii,i),-1*X(:,ii,i),'ok','MarkerFaceColor',C2(inds(ii),:),'parent',ax(3));
            end
        end
    end
    axes(ax(1));hold off;if in ==1;axes(ax(2));hold off;axes(ax(3));hold off;end
    % PRE-SET axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if in == 1
        ax(4)=subplot(2,10,11:14,'parent',hpp(end));
        ax(5)=subplot(2,10,15,'parent',hpp(end),'yaxislocation','right');
    else
        ax(4)=subplot(1,10,[1:4],'parent',hpp(end),'layer','top');
        ax(5)=subplot(1,10,[5],'parent',hpp(end),'layer','top');
    end
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
end
axes(ax(1))