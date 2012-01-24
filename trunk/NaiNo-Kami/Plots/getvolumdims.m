function [verts,fig,ax3d,p,hyps,strike] = getvolumdims(londegdecSVD,latdegdecSVD,profaslkmSVD,isoval,scales)

dists=((nanmedian(londegdecSVD)-londegdecSVD).^2+(nanmedian(latdegdecSVD)-latdegdecSVD).^2+(nanmedian(110*profaslkmSVD)-110*profaslkmSVD).^2).^0.5;
ind=find(dists<=(nanmean(dists)+0.1*nanstd(dists)));%nanmean(dists)+0.5*
londegdecSVD=londegdecSVD(ind) ;
latdegdecSVD=latdegdecSVD(ind) ;
profaslkmSVD=profaslkmSVD(ind) ;

%strike,dip,bigdiam,smalldiam,volums
strike     = [] ;
dip        = [] ;
bigdiam     = [] ;
smalldiam   = [] ;
volums      = [] ;
leshyps = [londegdecSVD latdegdecSVD profaslkmSVD];
if exist('isoval','var')==1; if numel(isoval) ==0 ; clear isoval;end ; end
if exist('scales','var')==1
    ORIGIN = [nanmean(londegdecSVD) nanmean(latdegdecSVD) nanmean(profaslkmSVD)];
    newx = ORIGIN(1)+((londegdecSVD-ORIGIN(1)).*scales(1));
    newy = ORIGIN(2)+((latdegdecSVD-ORIGIN(2)).*scales(2));
    newz = ORIGIN(3)+((profaslkmSVD-ORIGIN(3)).*scales(3));
end
%plot3(londegdecSVD,latdegdecSVD,profaslkmSVD,'.b')
%axis tight
%for i=90:-1:30;view(0,i);drawnow;end ; for i=1:360;view(i,10-(i*10/360));drawnow;end

% n = length(londegdecSVD) ;
% num = 3 ; %fix(20*sqrt(1/(n^2))) ;
% if num < 2 ; num = 2 ; end
% for  i = 1 : n
%     for  ii = 1 : n
%         if i ~= ii
%             niii = length(londegdecSVD)+1;
%             pasx = (londegdecSVD(ii)-londegdecSVD(i))/(num) ;
%             pasy = (latdegdecSVD(ii)-latdegdecSVD(i))/(num) ;
%             pasz = (profaslkmSVD(ii)-profaslkmSVD(i))/(num) ;
%             if pasx ~= 0 && pasy ~= 0 && pasz ~= 0
%                 answx = londegdecSVD(i)+pasx : pasx : londegdecSVD(ii)-pasx ;
%                 answy = latdegdecSVD(i)+pasy : pasy : latdegdecSVD(ii)-pasy ;
%                 answz = profaslkmSVD(i)+pasz : pasz : profaslkmSVD(ii)-pasz ;
%                 if length(answx) > 0 && length(answy) > 0 && length(answz) > 0
%                     if length(answx) == 1 ; len = 1 ; else ; len = length(answx)-1 ; end
%                     londegdecSVD(niii:niii+len) = answx ;
%                     if length(answx) == 1 ; len = 1 ; else ; len = length(answy)-1 ; end
%                     latdegdecSVD(niii:niii+len) = answy ;
%                     if length(answx) == 1 ; len = 1 ; else ; len = length(answz)-1 ; end
%                     profaslkmSVD(niii:niii+len) = answz ;
%                 end
%             end
%         end
%     end
% end

n = length(londegdecSVD) ;
if n < 100 %num = 10 ;
    num = fix(20*sqrt(1/(n^2))) ;
    if num < 2 ; num = 2 ; end
    for  i = 1 : n
        for  ii = 1 : n
            if i ~= ii
                niii = length(londegdecSVD)+1 ;
                pasx = (londegdecSVD(ii)-londegdecSVD(i))/(num) ;
                pasy = (latdegdecSVD(ii)-latdegdecSVD(i))/(num) ;
                pasz = (profaslkmSVD(ii)-profaslkmSVD(i))/(num) ;
                if pasx ~= 0 && pasy ~= 0 && pasz ~= 0
                    answx = londegdecSVD(i)+pasx : pasx : londegdecSVD(ii)-pasx ;
                    answy = latdegdecSVD(i)+pasy : pasy : latdegdecSVD(ii)-pasy ;
                    answz = profaslkmSVD(i)+pasz : pasz : profaslkmSVD(ii)-pasz ;
                    if length(answx) > 0 && length(answy) > 0 && length(answz) > 0
                        if length(answx) == 1 ; len = 1 ; else ; len = length(answx)-1 ; end
                        londegdecSVD(niii:niii+len) = answx ;
                        if length(answx) == 1 ; len = 1 ; else ; len = length(answy)-1 ; end
                        latdegdecSVD(niii:niii+len) = answy ;
                        if length(answx) == 1 ; len = 1 ; else ; len = length(answz)-1 ; end
                        profaslkmSVD(niii:niii+len) = answz ;
                    end
                end
            end
        end
    end
end

 fig = gcf ;
 ax3d = gca ;
 hold on
%[hyps] = plot3(londegdecSVD,latdegdecSVD,profaslkmSVD,'.b') ; 















% if exist('method','var') == 0
%     method = 1 ;
% end

seuilnb = 40 ;
xmaille = (nanmax(londegdecSVD)-nanmin(londegdecSVD))/6 ;
ymaille = (nanmax(latdegdecSVD)-nanmin(latdegdecSVD))/6 ;
tranche = (nanmax(profaslkmSVD)-nanmin(profaslkmSVD))/6 ;

Xval = min(londegdecSVD)-10*xmaille/2 : xmaille : max(londegdecSVD)+10*xmaille/2 ;
Yval = min(latdegdecSVD)-10*ymaille/2 : ymaille : max(latdegdecSVD)+10*ymaille/2 ;
Zval = min(profaslkmSVD)-10*tranche/2 : tranche : max(profaslkmSVD)+10*tranche/2 ;
if length(Zval) < 3
    Zval = [mean(profaslkmSVD)-tranche/2  mean(profaslkmSVD) mean(profaslkmSVD)+tranche/2] ;
end

densite = zeros(length(Yval),length(Xval),length(Zval))*0.00000000000001 ;
colordata = densite ;
volumed = ((tranche)*(xmaille*110)*(ymaille*110)) ;

for z = 1 : length(Zval)
    counteq = 0 ;
    counteqtotal = histc(profaslkmSVD,[Zval(z)-tranche/2 Zval(z)+tranche/2],2) ;
    counteqtotal = counteqtotal(1:length(counteqtotal)-1) ;

    %if counteqtotal >= seuilnb
    for x = 1 : length(Xval)
        for y = 1 : length(Yval)

            counteq = 0.001 ;
            for eq = 1 : length(latdegdecSVD)
                if londegdecSVD(eq) >= Xval(x)-xmaille/2 & londegdecSVD(eq) < Xval(x)+xmaille/2 & ...
                        latdegdecSVD(eq) >= Yval(y)-ymaille/2 & latdegdecSVD(eq) < Yval(y)+ymaille/2 & ...
                        profaslkmSVD(eq) >= Zval(z)-tranche/2 & profaslkmSVD(eq) < Zval(z)+tranche/2
                    counteq = counteq+1 ;
                end
            end
            if counteq > 0 ; colordata(y,x,z) = counteq ; end
        end
    end
    %end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    colordata(:,:,z) = (colordata(:,:,z)*100000000)/volumed ; % densite eq.km^-3
    densite(:,:,z) = log10(colordata(:,:,z)) ;    % /max(max(colordata(:,:,z))) ; %log10
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

disp(['    |     Mesh X: ' num2str(xmaille) '¡ ; Y: ' num2str(ymaille) '¡ ; Z:'  num2str(tranche)  ' km']) ;
disp(['    |     Volume : ' num2str(volumed) ' km^3']) ;






if exist('isoval','var') == 0
    disp(['Max of density : ' num2str(max(max(max(densite))))])
    isoval = max(max(max(densite)))*0.8 ;
    %isoval = (max(max(max(densite)))-min(min(min(densite))))/5+min(min(min(densite)));
    disp(['Automatic setting of the isodensity surface to ' num2str(isoval)])
end
[x,y,z] = size(densite) ;
Zval = repmat(reshape(Zval,[1 1 z]),[x y 1]) ;
Xval = repmat(reshape(Xval,[1 y 1]),[x 1 z]) ;
Yval = repmat(reshape(Yval,[x 1 1]),[1 y z]) ;
[faces,verts,colors] = isosurface(Xval,Yval,Zval,densite,isoval,colordata) ;

%axes(ax3d) ; hold on
p=[];
p = patch('Vertices', verts, 'Faces', faces,'FaceVertexCData', colors,'FaceColor','interp','EdgeColor','none') ;
alpha(p,0.5) ;
save p.mat p
%axis equal
%axis tight
%for i=30:-1:10;view(0,i);drawnow;end ; for i=1:360;view(i,10-(i*10/360));drawnow;end

