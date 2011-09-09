function plot_Yell(ax,redbox,lims)


if exist('lims','var') ==0 ; lims=0;end
ind = [3 4];
load /Users/fredmassin/PostDoc_Utah/Datas/cartes/kmcaldera.xyz;
load /Users/fredmassin/PostDoc_Utah/Datas/cartes/kmmallard.xyz;
load /Users/fredmassin/PostDoc_Utah/Datas/cartes/kmsourcreek.xyz;
load /Users/fredmassin/PostDoc_Utah/Datas/cartes/kmparkboundary.xyz;


limlat = minmax([kmparkboundary(:,ind(2))]');
limlon = minmax([kmparkboundary(:,ind(1))]');

if exist('redbox','var') ==1
    if numel(redbox) >= 4
        
        limlat = minmax([kmparkboundary(:,ind(2)); redbox(1,3:4)']');
        limlon = minmax([kmparkboundary(:,ind(1)); redbox(1,1:2)']');
        for i=2:size(redbox,1)
            limlat = minmax([limlat'; redbox(i,3:4)']');
            limlon = minmax([limlon'; redbox(i,1:2)']');
        end
        if lims~=1;
            subplot(2,10,[9 10 19 20]) ;            
            coast = load('coast');
            axesm('ortho','Origin',[mean(limlat) mean(limlon)])
            axis off; framem on; gridm on; mlabel on; plabel on;
            setm(gca,'MeridianLabel','off','ParallelLabel','off')
            geoshow(coast.lat,coast.long,'DisplayType','polygon')
            hold on ; plotm([limlat(1) limlat(1) limlat(2) limlat(2) limlat(1)],...
                [limlon(1) limlon(2) limlon(2) limlon(1) limlon(1)],...
                '-r','linewidth',2); hold off
        end
        
        if lims~=1;            subplot(2,10,[1:8 11:18]) ;end
        ax(1)=usamap(limlat,limlon);
        states = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [ limlon' limlat'] );
        geoshow(ax(1), states, 'FaceColor', 'none')
        lat = [states.LabelLat];
        lon = [states.LabelLon];
        tf = ingeoquad(lat, lon, limlat,limlon);
        textm(lat(tf), lon(tf), {states(tf).Name},'HorizontalAlignment', 'center');
        setm(ax(1),'flinewidth',1)
        framem on; gridm on; mlabel on; plabel on;
        
    end
end

axes(ax);hold on
plot3m(kmcaldera(:,ind(2))',kmcaldera(:,ind(1))',kmcaldera(:,5)','-k','linewidth',2,'parent',ax(1));
plot3m(kmcaldera(:,ind(2))',kmcaldera(:,ind(1))',kmcaldera(:,5)','-k','linewidth',2,'parent',ax(1));
plot3m(kmmallard(:,ind(2))',kmmallard(:,ind(1))',kmmallard(:,5)','-','color',[0.6 0.6 0.6],'linewidth',2,'parent',ax(1));
plot3m(kmmallard(:,ind(2))',kmmallard(:,ind(1))',kmmallard(:,5)','-','color',[0.6 0.6 0.6],'linewidth',2,'parent',ax(1));
plot3m(kmsourcreek(:,ind(2))',kmsourcreek(:,ind(1))',kmsourcreek(:,5)','-','color',[0.6 0.6 0.6],'linewidth',2,'parent',ax(1));
plot3m(kmsourcreek(:,ind(2))',kmsourcreek(:,ind(1))',kmsourcreek(:,5)','-','color',[0.6 0.6 0.6],'linewidth',2,'parent',ax(1));
plot3m(kmparkboundary(:,ind(2))',kmparkboundary(:,ind(1))',kmparkboundary(:,5)','-g','linewidth',2,'parent',ax(1));
plot3m(kmparkboundary(:,ind(2))',kmparkboundary(:,ind(1))',kmparkboundary(:,5)','-g','linewidth',2,'parent',ax(1));


 lake=load('~/Documents/Bibliotheque/3_scriptotheque/GMT/GMT/MAPS/yslake.map');
 plotm(lake(:,2),lake(:,1),'-b','linewidth',2,'parent',ax(1));
 lake=load('~/Documents/Bibliotheque/3_scriptotheque/GMT/GMT/MAPS/heblake.map');
 plotm(lake(:,2),lake(:,1),'-b','linewidth',2,'parent',ax(1));
 lake=load('~/Documents/Bibliotheque/3_scriptotheque/GMT/GMT/MAPS/JacksonLake.map');
 plotm(lake(:,2),lake(:,1),'-b','linewidth',2,'parent',ax(1));
 
 
 
if exist('redbox','var') ==1
    if numel(redbox) >= 4
        for i=1:size(redbox,1)
            boite = [redbox(i,3) redbox(i,3) redbox(i,4) redbox(i,4) redbox(i,3) ;...
                redbox(i,1) redbox(i,2) redbox(i,2) redbox(i,1) redbox(i,1) ; ...
                repmat(3.5,1,5)] ;
            plot3m(boite(1,:),boite(2,:),boite(3,:),'r','linewidth',2,'parent',ax(1))
        end
    end
end

lims = [getm(ax(1),'maplonlimit')  getm(ax(1),'maplatlimit')]; %[-111 -110 44 45] ;
plot_gmtfault('/Users/fredmassin/Documents/Bibliotheque/3_scriptotheque/GMT/GMT/MAPS/yellfaults.map',[limlon limlat],ax(1),1)
%lims,ax(1),maptoolbox

setm(ax(1),'Frame','on','Grid','on')

