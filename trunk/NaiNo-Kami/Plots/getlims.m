function getlims(in)

global fieldedit oldclust

if in == 1
    [time,indeq,lims] = taketime ;
    [clust]=takeclust(oldclust);
    
    
    fortitle = '';
    xlab = '' ;
    % indeq = [24] ;
    % loc1 = cell2mat(clust{i}(:,6));
    % loc2 = cell2mat(clust{i}(:,8));
    % loc3 = cell2mat(clust{i}(:,10));
    % loc4 = cell2mat(clust{i}(:,18));
    % loc5 = cell2mat(clust{i}(:,16));
    % loc6 = cell2mat(clust{i}(:,24));
    
    
    
    
    X(1:500,1:size(clust,1),1:length(indeq))=NaN;Y=X;Z=X;
    for i=1:size(clust,1);
        for ii=1%:length(indeq)
            for j=1:size(clust{i},1)
                clust{i}{j,indeq(ii)}(end:22) = NaN;
            end
            loc = cell2mat(clust{i}(:,indeq(ii)));
            %clust{i}{k,18} [ X Y Z erX erY erZ azX azY azZ dipX dipY dipZ RMS-cc numsta-cc year month day hour min sec RMS-ct numsta-ct] (num)
            loc = loc(loc(:,1)~=0,:);
            loc = loc(loc(:,2)~=0,:);
            loc = loc(loc(:,3)>=3.5,:);
            
            %if mean(loc(:,2))>=44.75 & mean(loc(:,2))<=44.8 & mean(loc(:,1))>=-111.2 & mean(loc(:,1))<=-110.75
            X(1:size(loc,1),i,ii) = loc(:,1);
            Y(1:size(loc,1),i,ii) = loc(:,2);
            Z(1:size(loc,1),i,ii) = -1*loc(:,3);
            %end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if sum(sum(isnan(X)))==numel(X) ; disp('Nothing to plot') ; return;end
    disp([num2str(sum(sum(1-isnan(X)))) ' earthquakes to plot'])
    
    latlim =[nanmin(nanmin(nanmin(Y))) nanmax(nanmax(nanmax(Y)))] ;
    lonlim =[nanmin(nanmin(nanmin(X))) nanmax(nanmax(nanmax(X)))] ;
    deplim =[nanmin(nanmin(nanmin(Z))) 3.5] ;
    
    set(fieldedit(12),'string',num2str(lonlim(1)))
    set(fieldedit(13),'string',num2str(lonlim(2)))
    
    set(fieldedit(14),'string',num2str(latlim(1)))
    set(fieldedit(15),'string',num2str(latlim(2)))
    
    set(fieldedit(16),'string',num2str(deplim(1)))
    set(fieldedit(17),'string',num2str(deplim(2)))
    
else
    
    set(fieldedit(12),'string','NaN')
    set(fieldedit(13),'string','NaN')
    
    set(fieldedit(14),'string','NaN')
    set(fieldedit(15),'string','NaN')
    
    set(fieldedit(16),'string','NaN')
    set(fieldedit(17),'string','NaN')
end