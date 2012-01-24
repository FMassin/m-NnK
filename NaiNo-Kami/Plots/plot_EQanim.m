function plot_EQanim(in)
global clust oldclust a dates1 dates2 cumnums clustratio uniqratio neoratio endratio fieldedit   hpp hp handles limt RE RU xx yy zz tt ploted pourcentag



if in==1
    
    [time,indeq,lims] = taketime ;
    [clust,oldclust]=takeclust(oldclust);
    [Xu,Yu,Zu,~,~,~,~,~,~,~,tu] = addisolate(lims);
    [X,Y,Z,~,tr] = filtclust(clust,indeq,lims);
    if numel(X)==0 ; disp('There is nothing to plot !');return;end
    X=reshape(X,1,numel(X));
    Y=reshape(Y,1,numel(X));
    Z=reshape(Z,1,numel(X));
    tr=reshape(tr,1,numel(X));
    tu = tu' ;
    test=logical(1-isnan(X));      X=X(test);    Y=Y(test);    Z=Z(test);    tr=tr(test);
    test=logical(1-isnan(tr));     X=X(test);    Y=Y(test);    Z=Z(test);    tr=tr(test);
    
    test=logical(1-isnan(Xu));     Xu=Xu(test);    Yu=Yu(test);    Zu=Zu(test);    tu=tu(test);
    test=logical(1-isnan(tu));     Xu=Xu(test);    Yu=Yu(test);    Zu=Zu(test);    tu=tu(test);
    pasx = diff(minmax([X Xu]))/30;
    pasy = diff(minmax([Y Yu]))/30;
    pasz = diff(minmax([Z Zu])); %/30
    past = diff(minmax([tr tu])); %/30
    tt = nanmin([tr tu]) : past : nanmax([tr tu]);
    xx = nanmin([X Xu]) : pasx : nanmax([X Xu])-pasx ;
    yy = nanmin([Y Yu]) : pasy : nanmax([Y Yu])-pasy ;
    zz = nanmin([Z Zu]) : pasz : nanmax([Z Zu])-pasz ;
    
    RE=cell(length(yy),length(xx),length(zz));
    UE=cell(length(yy),length(xx),length(zz));
    ix=0;
    for x=xx
        ix=ix+1;iy=0;
        for y=yy
            iy=iy+1;iz=0;
            for z=zz
                iz=iz+1;
                if numel(X)~=0
                    test = (X>=x).*(X<x+pasx).*(Y>=y).*(Y<y+pasy).*(Z>=z).*(Z<z+pasz);
                    RE{iy,ix,iz} = tr(logical(test));
                    test=logical(1-test); X=X(test); Y=Y(test); Z=Z(test); tr=tr(test);
                end
                if numel(Xu)~=0
                    test = (Xu>=x).*(Xu<x+pasx).*(Yu>=y).*(Yu<y+pasy).*(Zu>=z).*(Zu<z+pasz);
                    RU{iy,ix,iz} = tu(logical(test));
                    test=logical(1-test); Xu=Xu(test); Yu=Yu(test); Zu=Zu(test); tu=tu(test);
                end
            end
        end
    end
    limt=tt;
    [handles,hpp] =  plot_EQanim_1(tt,hpp,hp);
    [ploted,pourcentag,tt]=plot_EQanim_4(handles,RE,RU,xx,yy,zz,limt);
    
elseif in==2 % change up-small cursor posistion
    plot_EQanim_2(handles,limt);
    [ploted,pourcentag,tt]=plot_EQanim_5(handles,ploted,RE,RU,xx,yy,zz,limt,tt);
    caxis([-100,100])
elseif in==3 % change up-small edit field value
    plot_EQanim_3(handles,limt);
    [ploted,pourcentag,tt]=plot_EQanim_5(handles,ploted,RE,RU,xx,yy,zz,limt,tt);
    caxis([-100,100])
elseif in==4 % change bottom-big cursor position
    plot_EQanim_3(handles,limt);
    [ploted]=plot_EQanim_6(handles,ploted,pourcentag,tt);
    caxis([-100,100])
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pourcentag,tt] = plot_EQanim_10(RE,RU,xx,yy,zz,limt,past)
tt=limt(1):diff(limt)/100:limt(2) ; 
NR=zeros(length(yy),length(xx),length(tt),length(zz));
NU=NR;
for t=1:length(tt)
    for x=1:length(xx)
        for y=1:length(yy)
            for z=1:length(zz)
                testr = (RE{y,x,z}>=tt(t)).*(RE{y,x,z}<tt(t)+past) ;
                testu = (RU{y,x,z}>=tt(t)).*(RU{y,x,z}<tt(t)+past) ;
                testu =sum(testu) ; testr =sum(testr);
                if testu==[] ; testu = 0; end
                if testr==[] ; testr = 0; end
%                 if t==1
                    NR(y,x,t,z) = testr ;
                    NU(y,x,t,z) = testu ;
%                 else
%                     NR(y,x,t,z) = nansum([NR(y,x,t-1,z) testr]) ;
%                     NU(y,x,t,z) = nansum([NU(y,x,t-1,z) testu]) ;
%                 end
            end
        end
    end
end
pourcentag = 110.*NR./(NU+NR) ;
globporcentag = repmat(  (110.*sum(NR,3)./(sum(NU,3)+sum(NR,3)))  ,[1 1 length(tt) 1]) ;
pourcentag=globporcentag-pourcentag;
disp('reloaded')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ploted]=plot_EQanim_6(handles,ploted,pourcentag,tt)
[~,time] = min(abs(tt-get(handles(11),'value'))) ;
if numel(time)==0;time=1;end
set(ploted,'CData',pourcentag(:,:,time(1)));%shading interp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ploted,pourcentag,tt]=plot_EQanim_5(handles,ploted,RE,RU,xx,yy,zz,limt,tt)
past = 0.99*str2double(get(handles(14),'string'));
[~,time] = min(abs(tt-get(handles(11),'value'))) ;
if numel(time)==0;time=1;end
[pourcentag,tt] = plot_EQanim_10(RE,RU,xx,yy,zz,limt,past);
set(ploted,'CData',pourcentag(:,:,time(1))); %shading interp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ploted,pourcentag,tt]=plot_EQanim_4(handles,RE,RU,xx,yy,zz,limt)
past = 0.99*str2double(get(handles(14),'string'));
[pourcentag,tt] = plot_EQanim_10(RE,RU,xx,yy,zz,limt,past);

lonlim = minmax(xx); latlim=minmax(yy);
[loclatlab,pas]=plot_tick(latlim);
[loclonlab,pas]=plot_tick(lonlim);
ax=usamap(latlim,lonlim);
states = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
geoshow(ax, states, 'FaceColor', 'none')
lat = [states.LabelLat];
lon = [states.LabelLon];
tf = ingeoquad(lat, lon, latlim, lonlim);
textm(lat(tf), lon(tf), {states(tf).Name},'HorizontalAlignment', 'center');
setm(ax,'MLabelLocation',loclonlab,'PLabelLocation',loclatlab,'flinewidth',1)
set(ax,'layer','top')
plot_Yell(ax)%,[-111.2 -110.7 44.75 44.8],
hold on
ploted=pcolorm(yy,xx,pourcentag(:,:,end));%shading interp
hold off
colorbar ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_EQanim_3(handles,limt)
set(handles(10),'value',str2num(get(handles(14),'string')))
set(handles(14),'string',num2str(get(handles(10),'value')))
set(handles(11),'SliderStep',[1/10 1/100])
set(handles(11),'Min',limt(1),'Max',limt(2))
title(['Clustering % changes from ' ...
    datestr(get(handles(11),'value')) ' to ' ...
    datestr(get(handles(11),'value')+get(handles(10),'value')) ]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_EQanim_2(handles,limt)
set(handles(11),'SliderStep',[1/10 1/100])
set(handles(14),'string',num2str(get(handles(10),'value')))
set(handles(11),'Min',limt(1),'Max',limt(2))
axes(handles(1));
title(['Clustering % changes from ' ...
    datestr(get(handles(11),'value')) ' to ' ...
    datestr(get(handles(11),'value')+get(handles(10),'value')) ]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% SET plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [handles,hpp] =  plot_EQanim_1(limt,hpp,hp)
[hpp] = resizepanels(hp,hpp,1);
handles(1) = subplot(10,3,sort([1:3:24 2:3:24]),'parent',hpp(end));

handles(10)=uicontrol('Parent',hpp(end),'Style','slider',...
    'Max',diff(limt),'Min',1/50,'Value',diff(limt),...
    'SliderStep',[1/100 1/10],'Units','normalized','Position',[2/3 1/10 1/3 1/10],...
    'TooltipString','Time window length','Callback','plot_EQanim(2)');

handles(14) = uicontrol('Parent',hpp(end), ...
    'Units','normalized','BackgroundColor',[1 1 1],'FontSize',11,'ListboxTop',0, ...
    'Position',[2/3 2/10 1/3 1/10], ...
    'String',num2str(num2str(get(handles(10),'value'))),'TooltipString','This is the value of time window length cursor below',...
    'ForegroundColor','b','Style','edit','Callback','plot_EQanim(3)') ;

handles(11)=uicontrol('Parent',hpp(end),'Style','slider',...
    'Max',limt(2),'Min',limt(1),'Value',limt(2)-get(handles(10),'Value')/2,...
    'SliderStep',[1/100 1/10],'Units','normalized','Position',[1/30 0 29/30 1/10],...
    'TooltipString','Time','Callback','plot_EQanim(4)');

handles(12)=uicontrol('Parent',hpp(end),'Style','pushbutton',...
    'Units','normalized','Position',[2.5/3 5/6 1/6 1/6],...
    'String','Play','TooltipString','Play time evolution','Callback','');

handles(13)=uicontrol('Parent',hpp(end),'Style','checkbox',...
    'Units','normalized','Position',[2.5/3 4/6 1/6 1/6],...
    'String','Movie','TooltipString','Record movie while playin','Callback','');

axes(handles(1));
title(['Clustering % changes from ' ...
    datestr(get(handles(11),'value')-get(handles(10),'value')/2) ' to ' ...
    datestr(get(handles(11),'value')+get(handles(10),'value')/2) ]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



