function plot_clust

if exist('file','var')~=1
    file='../tmp/tmp2_2.mat';
end
load(file)

test = cell2mat(links);
bins = fix(([1:(max(sum(test,2)))^0.5])^2);
hist(sum(test,2),bins)
ylabel('Number of cluster')
xlabel('Number of clustered earthquake')
box on