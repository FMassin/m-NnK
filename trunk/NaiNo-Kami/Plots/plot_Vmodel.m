function plot_Vmodel(x0,y0,z0,Vp0,ax,Vs0)

red=2;
x0 = x0(red+2:end-red,red+1:end-red,:);
y0 = y0(red+2:end-red,red+1:end-red,:);
z0 = z0(red+2:end-red,red+1:end-red,:);
Vp0 = Vp0(red+2:end-red,red+1:end-red,:);
if exist('Vs0','var') >0 
    if numel(Vs0) > numel(Vp0)
        Vs0 = Vs0(red+2:end-red,red+1:end-red,:);
    end
end

km2deg=11;
if nanmin(nanmin(nanmin(x0))) < 0 & nanmax(nanmax(nanmax(x0))) >0
    ind = [1 2];
    km2deg = 0.1 ;
else
    ind = [3 4];
    km2deg = 11 ; 
end
 
V=Vp0;

if exist('Vs0','var') == 1
    if numel(Vs0) == 1
        iso=Vs0;
        textitle = ['Vs = ' num2str(iso) 'km/s'] ;
        disp(['case 1 iso = ' textitle])
    elseif numel(Vs0) == numel(Vp0)        
        V=Vp0./Vs0;
        m = repmat(nanmedian(nanmedian(V)),size(V,1),size(V,2)) ;
        maxi = max(max(max(m))) ;
        V=100*(V-m)./maxi;    
        test=V(isnan(V)==0); 
        iso = nanmedian(test)-std(test)*2.5;
        textitle = ['Vp/Vs-1D = ' num2str(iso) '%'] ; 
        disp(['case 2 iso = ' textitle])
    end
else    
    
    m = repmat(nanmedian(nanmedian(Vp0)),size(Vp0,1),size(Vp0,2)) ;
    maxi = max(max(max(m))) ;
    V=100*(Vp0-m)./maxi;
    test=V(isnan(V)==0);
    iso=-1.8 ;%nanmedian(test)-std(test)*2; %-2.5;%
    textitle = ['Vp-1D = ' num2str(iso) '%'] ; 
    disp(['case 3 iso = ' textitle])
end

% whos x0 y0 z0 V
if iso ~=0
    [faces,verts,colors] = isosurface(x0,y0,z0/(-1*km2deg),V,iso,Vp0);
    p = patch('Vertices', verts, 'Faces', faces, 'FaceVertexCData', colors, 'FaceColor', 'interp', 'EdgeColor', 'none');
    isonormals(x0,y0,z0/(-1*km2deg),Vp0,p);
    set(p, 'FaceColor', 'interp', 'EdgeColor', 'none');

end

sx= [] ; % min(verts(:,1));
sy= [] ; %nanmedian(verts(:,2));
sz= [ 13 7  0];%2    %[mean(mean(mean(z0)))-10 mean(mean(mean(z0)))-5  mean(mean(mean(z0))) mean(mean(mean(z0)))+3];


if exist('ax','var')==0;figure ;ax=gca;end
hold on
load /Users/fredmassin/PostDoc_Utah/Datas/cartes/kmcaldera.xyz;
load /Users/fredmassin/PostDoc_Utah/Datas/cartes/kmmallard.xyz;
load /Users/fredmassin/PostDoc_Utah/Datas/cartes/kmsourcreek.xyz;
load /Users/fredmassin/PostDoc_Utah/Datas/cartes/kmparkboundary.xyz;
plot3(kmcaldera(:,ind(1)),kmcaldera(:,ind(2)),kmcaldera(:,5)/(km2deg),'b','parent',ax);
plot3(kmcaldera(:,ind(1)),kmcaldera(:,ind(2)),kmcaldera(:,5)/(km2deg),'b','parent',ax);
plot3(kmmallard(:,ind(1)),kmmallard(:,ind(2)),kmmallard(:,5)/(km2deg),'b','parent',ax);
plot3(kmmallard(:,ind(1)),kmmallard(:,ind(2)),kmmallard(:,5)/(km2deg),'b','parent',ax);
plot3(kmsourcreek(:,ind(1)),kmsourcreek(:,ind(2)),kmsourcreek(:,5)/(km2deg),'b','parent',ax);
plot3(kmsourcreek(:,ind(1)),kmsourcreek(:,ind(2)),kmsourcreek(:,5)/(km2deg),'b','parent',ax);
plot3(kmparkboundary(:,ind(1)),kmparkboundary(:,ind(2)),kmparkboundary(:,5)/(km2deg),'k','parent',ax);
plot3(kmparkboundary(:,ind(1)),kmparkboundary(:,ind(2)),kmparkboundary(:,5)/(km2deg),'k','parent',ax);

%plot(x0(:,:,1),y0(:,:,1),'+k')
s=slice(x0,y0,z0/(-1*km2deg),Vp0,sx,sy,sz/(-1*km2deg));
set(s,'EdgeColor','none', 'DiffuseStrength',.8)
hold off
view(3); daspect([1 1 1]); axis tight
camlight;  camlight(-80,-10); lighting phong; 

%caxis([min(colors) max(colors)]) ;
% shading interp ;
% camlight('headlight') ;
% lighting phong
c=colorbar;
title(['Isosurface ' textitle])
set(get(c,'ylabel'),'String', 'Vp velocity [km.s^-^1]');
z=([-15:2.5:5]/km2deg)';
set(ax,'ztick',z,'zticklabel',num2str(z*km2deg));
axis image;
box on ;grid on
end