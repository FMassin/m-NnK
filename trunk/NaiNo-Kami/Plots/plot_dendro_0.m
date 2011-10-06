function plot_dendro_0(flag)

global clust oldclust a dates1 dates2 cumnums clustratio uniqratio neoratio endratio
if exist('flag','var')==0; flag=0;end

if exist('../tmp/plot_NNK.mat','file')== 2;
    load ../tmp/plot_NNK.mat;
    
    if flag==0
        if exist(fullfile(pathname,'clust.mat'),'file') ~= 0 %2000
            disp(['Loading the clusters in ' fullfile(pathname,'clust.mat') ' ...'])
            load(fullfile(pathname,'clust.mat')) ;
        else
            
            system('mv clusters.m clusters.old');
            system(['ln -s ' pathname 'clusters.m  clusters.m']);
            disp(['Loading the clusters in ' pathname 'clusters.m ...'])
            [clust] = clusters ;
        end
        disp('Clusters are loaded in structure  "clust"')
    end
    
    if exist([pathname 'lst.tmp'],'file') ~= 0
        disp('Loading the cumulate seismicity ...')
        lst = char(importdata([pathname 'lst.tmp']));
        dates1=datenum(lst(:,end-15:end-2),'yyyymmddHHMMSS');
        cumnums = 1:length(dates1) ;
        disp('cumulate seismicity is loaded in arrays "dates1" and "cumnums"')
        
        disp('Loading the clustering ratios ...')
        lst = importdata([pathname 'total-vs-clustered.tmp']);
        dates2 = char(lst.textdata) ;
        dates2 = datenum(dates2(:,end-15:end-2),'yyyymmddHHMMSS');
        
        nums = lst.data ;
        for i=1:size(dates2,1)
            %inds = [max([i-500 1]) : i] ;
            inds = [1 : i] ;
            clustratio(i) = sum(nums(inds,2));%/length(inds);
            uniqratio(i) = sum(nums(inds,1));%/length(inds);
            neoratio(i) = sum(nums(inds,3));%/sum(nums(inds,2));
            endratio(i) = sum(nums(inds,4));%/sum(nums(inds,2));
        end
        flagload =0 ;
        save ../tmp/plot_NNK.mat flagload -append
        disp(['clustering ratios are loaded : ' num2str(100*clustratio(end)/(clustratio(end)+uniqratio(end))) '% of the whole seismicity is repeating'])
    else
        disp('no clustering ratio loaded (file lst.tmp and total-vs-clustered.tmp)') ;
        dates1=[]; dates2=[]; cumnums=[]; clustratio=[]; uniqratio=[]; neoratio=[]; endratio=[];
    end
    oldclust = clust;
    
end

