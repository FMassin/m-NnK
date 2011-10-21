function [X,Y,Z,X1,X2,Y1,Y2,Ylat,Maxi,erX,erY,erZ,XX,YY,ZZ,fp,slip,fault,clust] = filtclust(clust,indeq,lims)

memer = 0;
erX(1:2,1:40000) = NaN; erY = erX ; erZ = erX ; XX = erX ; YY = erX ; ZZ = erX ; 
kmlon = 1 ; 
kmlat = 1 ; 
fp = [] ;
slip = [] ;
fault = [] ;
Y1 = [1:size(clust,1)];
Y1=repmat(Y1,2,1);
X(1:500,1:size(clust,1),1:length(indeq))=NaN;
Y=X;Z=X;
X1=X(1:2,:,1);X2=X(:,:,1);Y2=X(:,:,1);Ylat=X(1,:,1);
erX = [X X];erY = erX;erZ = erX;Maxi=0;


inds=[];


for i=1:size(clust,1);
    for ii=1%:length(indeq)
        if indeq(ii) >=18;dim=1000;else;dim=1;end
        for j=1:size(clust{i},1)
            clust{i}{j,indeq(ii)}(end:22) = NaN;
        end
        
        loc = cell2mat(clust{i}(:,indeq(ii)));
        %clust{i}{k,18} [ X Y Z erX erY erZ azX azY azZ dipX dipY dipZ RMS-cc numsta-cc year month day hour min sec RMS-ct numsta-ct] (num)
        loc = loc(loc(:,1)~=0,:);
        loc = loc(loc(:,2)~=0,:);
        loc(:,3) = -1*loc(:,3) ;
        loc = loc(loc(:,3)<=3.5,:);
        
        if sum(isnan(loc(:,1))) < length(loc(:,1)) & sum(isnan(loc(:,2))) < length(loc(:,1)) & sum(isnan(loc(:,3))) < length(loc(:,1))
            
            flag = 0 ;
            if sum(sum(isnan(lims)))==0
                if isnan(lims(1,1))==0 ; if nanmin(loc(:,1)) < lims(1,1) ; flag =1 ;
                    end ; end
                if isnan(lims(1,2))==0 ; if nanmax(loc(:,1)) > lims(1,2) ; flag =1 ;
                    end ; end
                if isnan(lims(2,1))==0 ; if nanmin(loc(:,2)) < lims(2,1) ; flag =1 ;
                    end ; end
                if isnan(lims(2,2))==0 ; if nanmax(loc(:,2)) > lims(2,2) ; flag =1 ;
                    end ; end
                if isnan(lims(3,1))==0 ; if nanmin(loc(:,3)) < lims(3,1) ; flag =1 ;
                    end ; end
                if isnan(lims(3,2))==0 ; if nanmax(loc(:,3)) > lims(3,2) ; flag =1 ;
                    end ; end
            end
            
            if flag == 0                
                X(1:size(loc,1),i,ii) = (loc(:,1));
                Y(1:size(loc,1),i,ii) = (loc(:,2));
                if indeq(ii)==6 | indeq(ii)==8 | indeq(ii)==10
                    Z(1:size(loc,1),i,ii) = -1*(loc(:,3));
                else
                    Z(1:size(loc,1),i,ii) = (loc(:,3));
                end
                
                if kmlon == 1
                    [poub,answer]=system(['./distance.pl ' num2str([ nanmean(loc(:,1)) nanmean(loc(:,2)) nanmean(loc(:,1))+1 nanmean(loc(:,2)) ])]);
                    kmlon=abs(str2num(answer));
                    [poub,answer]=system(['./distance.pl ' num2str([ nanmean(loc(:,1)) nanmean(loc(:,2)) nanmean(loc(:,1)) nanmean(loc(:,2))+1 ])]);
                    kmlat=abs(str2num(answer));
                end
                
                inder=memer+1:memer+size(loc,1);
                erX(1:2,inder) = [X(1:size(loc,1),i,ii)+loc(:,4)./(kmlon*dim) X(1:size(loc,1),i,ii)-loc(:,4)./(kmlon*dim)]';
                erY(1:2,inder) = [Y(1:size(loc,1),i,ii)+loc(:,5)./(kmlat*dim) Y(1:size(loc,1),i,ii)-loc(:,5)./(kmlat*dim)]';
                erZ(1:2,inder) = [Z(1:size(loc,1),i,ii)+loc(:,6)./dim Z(1:size(loc,1),i,ii)-loc(:,6)./dim]';
                XX(1:2,inder)  = [X(1:size(loc,1),i,ii) X(1:size(loc,1),i,ii)]';
                YY(1:2,inder)  = [Y(1:size(loc,1),i,ii) Y(1:size(loc,1),i,ii)]';
                ZZ(1:2,inder)  = [Z(1:size(loc,1),i,ii) Z(1:size(loc,1),i,ii)]';
                memer = size(erX,2);
                
                X1(1:2,i) = cell2mat(clust{i}([1 end],3));
                
                X2(1:size(clust{i},1),i) = cell2mat(clust{i}(:,3));
                Y2(1:size(clust{i},1),i) = repmat(i,size(clust{i},1),1);
                Ylat(1,i) = size(clust{i},1) ;
                
                if numel(loc(:,3)) > Maxi ; Maxi = numel(loc(:,3)) ; end ; 
                mem=i;
                inds=[inds i ];
            end
        end
    end
end
if exist('mem','var')==0 ; disp('There is nothing to plot !');return;end

X2=X2(1:Maxi,1:mem);
Y2=Y2(1:Maxi,1:mem);
X1=X1(1:2,1:mem);
Y1=Y1(1:2,1:mem);
X=X(1:Maxi,1:mem,:);
Y=Y(1:Maxi,1:mem,:);
Z=Z(1:Maxi,1:mem,:);
erX=erX(1:2,1:memer);
erY=erY(1:2,1:memer);
erZ=erZ(1:2,1:memer);
XX=XX(1:2,1:memer);
YY=YY(1:2,1:memer);
ZZ=ZZ(1:2,1:memer);
clust = clust(inds) ; 
if sum(sum(isnan(X)))==numel(X) ; disp('Nothing to plot') ; return;end
disp([num2str(sum(sum(1-isnan(X)))) ' earthquakes to plot from ' num2str(sum(sum(1-isnan(X2(1,:))))) ' clusters'])
