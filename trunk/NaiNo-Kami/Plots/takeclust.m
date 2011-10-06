function [clust,oldclust,limx,ind]=takeclust(oldclust)

if exist('../tmp/plot_NNK.mat','file')== 2;    load ../tmp/plot_NNK.mat ;end
ind = [];
started = [] ;
ended = [] ;
ids = [1:size(oldclust,1)];
investigated = [];
excluded = [];
if exist('investigationperiods.m','file') ==2
    [investigated]=investigationperiods;
    investigated=[datenum(investigated(:,3),investigated(:,1),investigated(:,2)) datenum(investigated(:,6),investigated(:,4),investigated(:,5))];
    %investigated(:,1)=investigated(:,1)-1;investigated(:,2)=investigated(:,2)+1;
end
if exist('excludeperiods.m','file') ==2
    [excluded]=excludeperiods;
    excluded=[datenum(excluded(:,3),excluded(:,1),excluded(:,2)) datenum(excluded(:,6),excluded(:,4),excluded(:,5))];
    %excluded(:,1)=excluded(:,1)-1;excluded(:,2)=excluded(:,2)+1;
end

for i=ids
    if size(oldclust{i},2) >= 24
        flagOK = 1;
        for ii = 1:size(oldclust{i},1)
            for iii=[6 8 10 18 16 24]
                for iiii=length(oldclust{i}{ii,iii})+1:22
                    oldclust{i}{ii,iii}(iiii) = NaN;
                end
            end
        end        
        if size(investigated,1) >= 1
            flagOK = 0;
            dates = cell2mat(oldclust{i}([1 end],3));
            if isempty(find(dates(1)>=investigated(:,1) & dates(2)<=investigated(:,2))) == 0
                flagOK = 1;
            end
        end
        if flagOK == 1
            if size(excluded,1) >= 1
                flagOK = 0;
                dates = cell2mat(oldclust{i}([1 end],3));
                if isempty(find(dates(1)>=excluded(:,1) & dates(2)<=excluded(:,2))) == 1
                    flagOK = 1;
                end
            end
        end
        
        if flagOK == 1
            if param(1) == -1 & param(2) == -1 & param(3) == -1
                
                dates = cell2mat(oldclust{i}(:,3));
                
                for ii =1:length(dates)
                    if dates(ii)>= param(4) & dates(ii)<= param(5)
                        ind = [ind ; i] ;
                        started=[started ; min(dates)];
                        ended = [ended ; max(dates)];
                        break
                    end
                end
            end
            
            if param(1) == 1
                
                dates = cell2mat(oldclust{i}([1 end],3));
                
                if dates(1)>= param(4) & dates(1)<= param(5) & dates(2)>= param(4) & dates(2)<= param(5)
                    ind = [ind ; i] ;
                    started=[started ; min(dates)];
                    ended = [ended ; max(dates)];
                end
            end
            
            if param(2) == 1
                
                dates = cell2mat(oldclust{i}(:,3));
                
                for ii =1:length(dates)
                    for iii =1:length(dates)
                        if (dates(ii)>= param(4) & dates(ii)<= param(5)) & (dates(iii)>= param(6) & dates(iii)<= param(7))
                            ind = [ind ; i] ;
                            started=[started ; min(dates)];
                            ended = [ended ; max(dates)];
                            break
                        end
                    end
                    if length(ind)>0;if ind(end)==i ; break ;end;end
                end
            end
            
            if param(3) == 1
                
                dates = cell2mat(oldclust{i}(:,3));
                
                for ii =1:length(dates)
                    for iii =1:length(dates)
                        if (dates(ii)>= param(4) & dates(ii)<= param(5)) & (dates(iii)< param(4) | dates(iii)> param(5))
                            ind = [ind ; i] ;
                            started=[started ; min(dates)];
                            ended = [ended ; max(dates)];
                            break
                        end
                    end
                    if length(ind)>0;if ind(end)==i ; break ;end;end
                end
            end
        end
    end
end
disp([num2str(length(ind)) ' clusters selected'])
if length(ind)==0; disp('FIX: Enlarge time window');end

order = 1:length(ind);
if length(param) >= 8
    if param(8) == 1
        [val,order]=sort(started,'ascend');
    elseif param(8) == -1
        [val,order]=sort(ended,'ascend');
    end
end
ind=ind(order);
clust= oldclust(ind);


fortest = [1:size(clust,1)];
if param(3) == 1 | param(2) == 1 | param(1) == 1
    limx=[999999999999 0];
    for i=fortest;
        limx = [min([ limx(1) min(cell2mat(clust{i}([1 end],3)))])  max([limx(2) max(cell2mat(clust{i}([1 end],3)))])];
    end
elseif param(1) == -1 & param(2) == -1 & param(3) == -1
    limx = param(4:5);
    %     limx=[999999999999 0];
    %     for i=fortest;
    %         limx = [max([ limx(1) min(cell2mat(clust{i}([1 end],3)))])  limx(2)];
    %     end
end

