function [listeclusters] = NNK_clust_cluster(links,nelt,lesrecord)



a=length(links);zero=false(a,1);knownclust=zeros(a,1);

% TASK 1: Grab known clusters %%%%%%%%%%%%%%%%%%%%%%
progress_bar_position=0;tm=tic;count=0; % progress bar initiate
for i=1:a               
    knownclust(i)=isknownclust(lesrecord(i,:));
    if knownclust(i)==1
        % progress bar update %%%%%%%%%%%%%%
        message=['Task 1/5. Cluster ' lesrecord(i,:) ' is ' num2str(knownclust(i)) '.known'];
        clc;[progress_bar_position]=textprogressbar(i,a,progress_bar_position,toc(tm),message);tm=tic;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% TASK 2: update known clusters eq. numbers %%
progress_bar_position=0;tm=tic;count=0;
for i=1:a                 
    if knownclust(i)==1 
        count=count+1;
        [~,neltclst]=system(['ls -dl ' lesrecord(i,:) '/events/* | wc -l'] );
        message=['Task 2/5. N eq. of cluster ' num2str(i) ' was ' num2str(nelt(i)) ' become ' neltclst(1:end-1) '. I mean cluster ' lesrecord(i,:)];
        
        nelt(i)=str2num(neltclst);
        % progress bar update %%%%%%%%%%%%%%%%%
        clc;[progress_bar_position]=textprogressbar(count,sum(knownclust),progress_bar_position,toc(tm),message);tm=tic;
    end
end
clear knownclust
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% TASK 3: reduce link of each event to one familly %%%%%%%
progress_bar_position=0;tm=tic;count=0;
for i=1:a
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
    message=['Task 3/5. Event ' num2str(i) '/' num2str(a) ' linked best to familly ' num2str(hop) '. ' lesrecord(i,:) ' => ' lesrecord(hop,:)];
    clc;[progress_bar_position]=textprogressbar(i,a,progress_bar_position,toc(tm),message);tm=tic;
    clear fortest2
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TASK 4: reduce link of each event to one familly %%%%%%%
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
    message=['Task 4/5. Reduce clustering ' num2str(i) '/' num2str(a)];
    clc; [progress_bar_position]=textprogressbar(i,a,progress_bar_position,toc(tm),message);tm=tic;
    clear fortest2
end;
save('tmp/clstClust_tmp.mat','a','links','lesrecord') ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Edit cluster list %%%%%%%%%%%%%%%%%%%
clear all ; load('tmp/clstClust_tmp.mat') ;
% progress bar update %%%%%%%%%%%%%%%%%
clc;disp(['Task 5/5. Edit cluster list. ']);
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
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
















%save('tmp/tmp2_3.mat','listeclusters','nbmast') ;


% % Edit isolate list %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % progress bar update %%%%%%%%%%%%%%%%%
% message=['Edit isolate list. '];
% clc;[progress_bar_position]=textprogressbar(count,maxi,progress_bar_position,toc(tm),message);tm=tic;
% listenoclusters(1,1:size(lesrecord,2))=' ';countno=0; 
% for i=nbmast+1:a
%     forliste=logical(cell2col(links,i)); 
%     if sum(forliste)==0;countno=countno+1;listenoclusters(countno,:)=lesrecord(i,:); end
% end
% if countno>0;listenoclusters=listenoclusters(1:countno,:);
% else listenoclusters='';
% end;save('tmp/tmp2_4.mat','*') ;
%,listenoclusters


% Tout ceci dessous etait au debut
% % [a,c] = size(CCC) ;
% % links = cell(a,1) ; 
% % nelt = zeros(a,1) ; 
% % 
% % % make all linkages matrix %%%%%%%%%%%% 
% % % progress bar initiate %%%%%%%%%%%%%%%
% % maxi=a;progress_bar_position=0;tm=tic;count=0;
% % for k=1:a                             %chaque seisme
% %     correls=zeros(1,a);
% %     for i=1:c                         %chaque station
% %         if length(cell2mat(CCC(k,i)))==size(CCC,1)        
% %             test=cell2mat(CCC(k,i));            % extrait les CCC de l'ev k avec tout les autre
% %             test=logical(test >= seuilcluster); % remplace les CCC > seuilcluster (0.85(cf NNK_clst_takparams.m)) par 1 et les < par 0
% %             correls=correls+test;               % addition des 0 et 1 sur toute les stations masters pour le clustering (cf NNK_clst_takparams.m)
% %             % => obtient le nb de station bien correlees pour chaque paire d'ev av l'ev k
% %         else disp('You ve got a problem in the dims of your CCC cell !')
% %         end
% %     end
% %     correls=logical(correls >= ncorrel);   % remplace les nombre de station bien correles par 1 si > ncorrel (2 (cf NNK_clst_takparams.m)) ou 0 
% %     correls(k)=true(1);
% %     links{k}=correls;
% %     nelt(k)=sum(correls);
% %     % progress bar update %%%%%%%%%%%%%%%%%
% %     message=['Linking ' num2str(k) '/' num2str(a) ' ' num2str(nelt(k)) ' links found '];
% %     clc;count=count+1;[progress_bar_position]=textprogressbar(count,maxi,progress_bar_position,toc(tm),message);tm=tic;
% % end
% % save('tmp/tmp2_0.mat','nelt','a','links','lesrecord','nbmast') ;
end


