function plot_dendro_2(in)
global clust oldclust a dates1 dates2 cumnums clustratio uniqratio neoratio endratio fieldedit


[time] = taketime ;
[clust,oldclust]=takeclust(oldclust);
% for i=1:length(a)
%     cla(a(i),'reset') ;
% end

if size(clust,1)>0
    dates=[];
    axes(a(1))
    ids = [1:size(clust,1)];
    for i=ids
        dates = [dates cell2mat(clust{i}([1 end],3))];
    end
    inds1 = logical(logical(dates1 >= min(min(dates))) .* logical(dates1 <= max(max(dates)))) ;
    inds2 = logical(logical(dates2 >= min(min(dates))) .* logical(dates2 <= max(max(dates)))) ;

    if in == 1
        [AX,H1,H2] = plotyy(dates,repmat(ids,2,1),dates1(inds1),cumnums(inds1)-min(cumnums(inds1)),'plot','plot','parent',get(a,'Parent'));

        axes(AX(1)) ; hold on ; H4 = plot(dates,repmat(ids,2,1),'.','parent',AX(1)); H1=[H1;H4]; hold off;
        axes(AX(2)) ; Ylabel('Cumulate number of eq.')

    end

    if in == 2
        [AX,H1,H2] = plotyy(dates,repmat(ids,2,1),dates2(inds2),neoratio(inds2),'plot','plot','parent',get(a,'Parent'));

        axes(AX(1)) ; hold on ; H4 = plot(dates,repmat(ids,2,1),'.','parent',AX(1)); H1=[H1;H4]; hold off;
        axes(AX(2)) ; Ylabel('Ratio of new cluster [500 eq. av.]')
    end

    if in == 3
        [AX,H1,H2] = plotyy(dates,repmat(ids,2,1),dates2(inds2),endratio(inds2),'plot','plot','parent',get(a,'Parent'));

        axes(AX(1)) ; hold on ; H4 = plot(dates,repmat(ids,2,1),'.','parent',AX(1)); H1=[H1;H4]; hold off;
        axes(AX(2)) ; hold on ; H3 = plot(dates2(inds2),neoratio(inds2),'-c','parent',AX(2)); H2=[H2;H3]; hold off;
        Ylabel('Ratios [500 eq. av.]')
        legend(H2([2 1]),'New clusters','Ending clusters','Location','NorthWest')
    end
    
    
    if in == 4
        [AX,H1,H2] = plotyy(dates,repmat(ids,2,1),dates2(inds2),clustratio(inds2),'plot','plot','parent',get(a,'Parent'));

        axes(AX(1)) ; hold on ; H4 = plot(dates,repmat(ids,2,1),'.','parent',AX(1)); H1=[H1;H4]; hold off;
        axes(AX(2)) ; hold on ; H3 = plot(dates2(inds2),uniqratio(inds2),'-c','parent',AX(2)); H2=[H2;H3]; hold off;
        Ylabel('Ratios [500 eq. av.]')
        legend(H2([2 1]),'Unique eq.','Clustered eq.','Location','NorthWest')
    end
    
    if in == 5
        [AX,H1,H2] = plotyy(dates,repmat(ids,2,1),dates2(inds2),clustratio(inds2),'plot','plot','parent',get(a,'Parent'));

        axes(AX(1)) ; hold on ; H4 = plot(dates,repmat(ids,2,1),'.','parent',AX(1)); H1=[H1;H4]; hold off;
        axes(AX(2)) ; hold on ; H3 = plot(dates2(inds2),neoratio(inds2),'-c','parent',AX(2)); 
                                H5 = plot(dates2(inds2),endratio(inds2),'-r','parent',AX(2)); H2=[H2;H3;H5]; hold off;
        Ylabel('Ratios [500 eq. av.]')
        legend(H2([2 3 1]),'New clusters','Ending clusters','Clustered eq.','Location','NorthWest')
    end
    
    if in == 6
        [AX,H1,H2] = plotyy(dates,repmat(ids,2,1),dates2(inds2),uniqratio(inds2),'plot','plot','parent',get(a,'Parent'));

        axes(AX(1)) ; hold on ; H4 = plot(dates,repmat(ids,2,1),'.','parent',AX(1)); H1=[H1;H4]; hold off;
        axes(AX(2)) ; hold on ; H3 = plot(dates2(inds2),neoratio(inds2),'-c','parent',AX(2)); 
                                H5 = plot(dates2(inds2),endratio(inds2),'-r','parent',AX(2)); H2=[H2;H3;H5]; hold off;
        Ylabel('Ratios [500 eq. av.]')
        legend(H2([2 3 1]),'New clusters','Ending clusters','Unique eq.','Location','NorthWest')
    end
    

    set(H1,'color',[0.7 0.7 0.7])
    axes(AX(1)) ;
    ylim([ids(1) ids(end)]);
    Ylabel('Clusters ID');
    plot_gooddatetick(AX(1),'x',0)
    if length(AX)> 1 ;
        plot_gooddatetick(AX(2),'x',1) ;
        if length(H2)> 1
            set(H2(1),'linewidth',2,'color','c'); set(H2(2),'linewidth',1,'color','b')
        else
            set(H2,'linewidth',2)
        end
        axes(AX(2)) ; axis tight;
    end
    linkaxes(AX,'x')
    xlim([min(min(dates))-(max(max(dates))-min(min(dates)))/50  max(max(dates))+(max(max(dates))-min(min(dates)))/50])
end

a=AX;
end
