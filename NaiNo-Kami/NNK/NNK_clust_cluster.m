function [listeclusters] = NNK_clust_cluster(links,nelt,lesrecord,nbmast)



a=length(links);
% Reduce linkage matrix %%%%%%%%%%%%%%%
% progress bar initiate %%%%%%%%%%%%%%%
progress_bar_position=0;tm=tic;count=0;
zero=false(a,1); 
for i=1:a                 % prefere linkage to ever known cluster
    knownclust(i)=isknownclust(lesrecord(i,:));
end

% links known clusters to new events %%
for i=1:a                 
    if knownclust(i)==1               % prefere linkage to known cluster     
        [fortest]=cell2col(links,i,knownclust);
        fortest2(fortest)=nelt(fortest);
        hop=0;
        if  max(fortest) > 0
            indicezone=logical(fortest2 == max(fortest2));
            [hip,hop]=max(indicezone);
            fortest(:)=0;fortest(hop)=1;
            [links]=col2cell(links,i,fortest);
        else
            [links]=col2cell(links,i,zero);
        end
        % progress bar update %%%%%%%%%%%%%%%%%
        message=['Known clustering ' num2str(i) '/' num2str(a) ' attribut to : ' num2str(hop) ' | '];
        clc;[progress_bar_position]=textprogressbar(i,a,progress_bar_position,toc(tm),message);tm=tic;
        clear fortest2
    end
end

% links new events to new events %%%%%%%
for i=1:a                      
    if knownclust(i)==0                % prefere linkage to new events
        [fortest]=cell2col(links,i);
        fortest2(fortest)=nelt(fortest);
        hop=0;
        if  max(fortest) > 0
            indicezone=logical(fortest2 == max(fortest2));
            [hip,hop]=max(indicezone);
            fortest(:)=0;fortest(hop)=1;
            [links]=col2cell(links,i,fortest);
        else
            [links]=col2cell(links,i,zero);
        end
        % progress bar update %%%%%%%%%%%%%%%%%
        message=['New clustering ' num2str(i) '/' num2str(a) ' attribut to : ' num2str(hop) ' | '];
        clc;[progress_bar_position]=textprogressbar(i,a,progress_bar_position,toc(tm),message);tm=tic;
        clear fortest2
    end
end

progress_bar_position=0;tm=tic;count=0;
for i=1:a                      
    [fortest]=find(links{i}>0);
    fortest2=[];
    for ii=1:length(fortest)
        fortest2=[fortest2  find(links{fortest(ii)}>0)];
    end
    links{i}(fortest2) = 1;
    for ii=fortest2
        if ii ~= i
            links{ii}(fortest2) = 0;
        end
    end
    % progress bar update %%%%%%%%%%%%%%%%%
    message=['Reduce clustering ' num2str(i) '/' num2str(a) ' | '];
    clc;[progress_bar_position]=textprogressbar(i,a,progress_bar_position,toc(tm),message);tm=tic;
    clear fortest2
end;
save('tmp/clstClust_tmp.mat','a','links','lesrecord') ;


% Edit cluster list %%%%%%%%%%%%%%%%%%%
clear all ; load('tmp/clstClust_tmp.mat') ;
% progress bar update %%%%%%%%%%%%%%%%%
disp(['Edit cluster list. ']);
listeclusters=cell(a,1);count=0; 
for i=1:a
    forliste=links{i};
    if sum(forliste)>1
        count=count+1;
        %forliste(i)=1;
        listeclusters{count}=lesrecord(forliste,:);
    end
end
if count==0;listeclusters=cell(0);
else listeclusters=listeclusters(1:count);
end; 