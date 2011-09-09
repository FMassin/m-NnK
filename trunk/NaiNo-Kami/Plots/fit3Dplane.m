function [strike,dip,XYZyellow,X1,Y1,Z1] = fit3Dplane(X,ploted,ax,scales,diameter)

if exist('ax','var') ==0;ax=gca;end
if exist('ploted','var') ==0;ploted=0;end
if exist('scales','var') ==0;scales=[1 1 1];end
scales = scales';
oldX = X ; 
if ploted==1
    axes(ax);hold on
    %plot3(X(:,1),X(:,2),X(:,3),'.k','parent',ax)
end
[X] = getvolumdims(X(:,1),X(:,2),X(:,3),[]);

[coeff,score,roots] = princomp(X);
basis = coeff(:,1:2);
normal = coeff(:,3) ;
norm = (sum((normal.*scales).^2))^0.5;
hnorm = (sum((normal(1:2).*scales(1:2)).^2))^0.5;

strike = rad2deg(acos((normal(2)*scales(2))/hnorm))-90;
if normal(1)<0 ;strike=-1*strike;end
if strike<0;strike=strike+180;end

dip = 90-rad2deg(acos((hnorm)/norm));


pctExplained = roots' ./ sum(roots);
[n,p] = size(X);
meanX = mean(X,1);
Xfit = repmat(meanX,n,1) + score(:,1:2)*coeff(:,1:2)';
residuals = X - Xfit;
error = abs((X - repmat(meanX,n,1))*normal);
sse = sum(error.^2) ;

[xgrid,ygrid] = meshgrid(linspace(min(X(:,1)),max(X(:,1)),5),linspace(min(X(:,2)),max(X(:,2)),5));
zgrid = (1/normal(3)) .* (meanX*normal - (xgrid.*normal(1) + ygrid.*normal(2)));



if ploted==1
    hold on
    %zgrid(zgrid>max(X(:,3))) = NaN
    %h = mesh(xgrid,ygrid,zgrid,'EdgeColor',[0 0 0],'FaceAlpha',0,'parent',ax);
end

if ploted==1
    hold on
end
above = (X-repmat(meanX,n,1))*normal > 0;
below = ~above;
nabove = sum(above);
X1 = [X(above,1) Xfit(above,1) nan*ones(nabove,1)];
X2 = [X(above,2) Xfit(above,2) nan*ones(nabove,1)];
X3 = [X(above,3) Xfit(above,3) nan*ones(nabove,1)];
if ploted==1
    plot3(X1',X2',X3','-', X(above,1),X(above,2),X(above,3),'.','markersize',16,'Color','m','parent',ax);
end
nbelow = sum(below);
X1 = [X(below,1) Xfit(below,1) nan*ones(nbelow,1)];
X2 = [X(below,2) Xfit(below,2) nan*ones(nbelow,1)];
X3 = [X(below,3) Xfit(below,3) nan*ones(nbelow,1)];
if ploted==1
    plot3(X1',X2',X3','-', X(below,1),X(below,2),X(below,3),'.','markersize',16,'Color','k','parent',ax);
end

maxlim = max(oldX);
minlim = min(oldX);
[val,ind] = max((maxlim-minlim));
limits = mean([maxlim ; minlim]);
limits = [ limits(1)-(val/1.5) limits(1)+(val/1.5)  limits(2)-(val/1.5) limits(2)+(val/1.5) limits(3)-(val/1.5) limits(3)+(val/1.5)];

X1=nanmean(X(:,1));
Y1=nanmean(X(:,2));
Z1=nanmean(X(:,3));
if ploted==1
    if exist('diameter','var')==0
        diameter = max([diff(minmax(X(:,1)'))  diff(minmax(X(:,2)')) diff(minmax(X(:,3)'))/110])*110;
    end
    [~,~,~,~,~,~,XYZyellow]=drawplan(diameter,X1,Y1,Z1,strike,dip,0,'y',ax,1,1,'  ',scales);
    
    %quiver3(X1,Y1,Z1,normal(1),normal(2),normal(3),'parent',ax)
    %quiver3(limits(1),limits(3),limits(5),0,val,0,'-k','linewidth',2,'parent',ax)
    %axis equal
    %axis(limits);
    %grid on
    %view(-23.5,5);
end
hold off
    