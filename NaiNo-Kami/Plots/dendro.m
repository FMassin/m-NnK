function [ids,ax,clust]=dendro(ax,clust)


if exist('ax','var') == 0 ; ax = gca ; end 
if exist('clust','var')==0 ;[clust] = clusters;end

axes(ax)
hold on
ids = [1:size(clust,1)];
for i=ids
    dates = cell2mat(clust{i}(:,3));
    plot(dates,repmat(i,size(clust{i},1),1),'-g','parent',ax);
    plot(dates,repmat(i,size(clust{i},1),1),'.k','parent',ax);
end
hold off
plot_gooddatetick(ax)
ylabel('Cluster ID')