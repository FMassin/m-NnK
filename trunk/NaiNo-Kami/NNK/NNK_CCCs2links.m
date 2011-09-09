function [links,nelt,a]= NNK_CCCs2links(pathtotmp,stamaitre,seuilcluster,ncorrel,marq)


for sta=1:size(stamaitre,1);
    name=[pathtotmp '/' marq num2str(sta) '.mat'];
    disp(['loading ' pathtotmp '/' marq num2str(sta+1) '.mat ...']);test=dir(name)
    load(name);[a,c]=size(CCC);
    
    if sta==1;nelt=zeros(a,1);links=cell(a,1);end
    % progress bar initiate %%%%%%%%%%%%%%%
    maxi=a;progress_bar_position=0;tm=tic;count=0;
    
    for k=1:a
        if sta==1;links{k}=zeros(1,a);end
        %test = CCC{k,sta};
        CCC{k,sta}(isnan(CCC{k,sta})) = 0 ;
        links{k}=links{k}+logical( CCC{k,sta} >= seuilcluster);
        links{k}(k)=links{k}(k)+true(1);
        CCC{k,sta}=[];
        
        if sta == size(stamaitre,1)
            links{k} = logical(links{k} >= ncorrel);
            nelt(k)=sum(links{k});
        end
        
        % progress bar update %%%%%%%%%%%%%%%%%
        message=['Linking ' num2str(k) '/' num2str(a) ' ' num2str(nelt(k)) ' links found (' num2str( sum(nelt(1:k))/(a*k) ) ' % of pairs)'];
        clc;count=count+1;[progress_bar_position]=textprogressbar(count,maxi,progress_bar_position,toc(tm),message);tm=tic;
    end
    clear CCC
    disp('saving temp file clstCC.mat...');
    save([pathtotmp '/clstCC.mat'],'links','nelt','a')
end
