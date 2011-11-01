function dendro2creation(origines,cluster)

global clust a dates1 

% % n eruptions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % local=pwd;
% % cd /Users/fredmassin/PostDoc_Utah/Datas/eruptions
% % [eruption]=Perkins_n_Nash_2002;
% % cd(local);
% % eruption = cell2mat(eruption(:,3));
% % eruption=0-eruption;
% % eruption =sort(eruption,'ascend');
% % eruption = eruption(isnan(eruption)==0);
% % eruption=eruption';
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('origines','var')==0
    % n clustered eq cumule %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if exist('clust','var')==0 ;plot_dendro_0;[clust] = clusters;end
    ids = [1:size(clust,1)];
    dates=[];
    for i=ids
        dates = [dates ; cell2mat(clust{i}(:,3))];
    end
    dates=sort(dates,'ascend');dates=dates';
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % n cluster cumule %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % if exist('clust','var')==0 ;plot_dendro_0;[clust] = clusters;end
    % % ids = [1:size(clust,1)];
    % % dates=[];
    % % for i=ids
    % %     dates = [dates cell2mat(clust{i}([1 end],3))];
    % % end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    inds1 = logical(logical(dates1 >= min(min(dates))) .* logical(dates1 <= max(max(dates)))) ;
    origines = dates1(inds1);
    cluster = dates(1,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % date origine des seismes : origines
    % date origine des seismes elt clusters : cluster
    % date des eruption : eruption
end
if exist('a','var') == 0 ; a = gca ; end

whos origines cluster eruption
creations = cluster ;
save ../tmp/clusterEQ2008dec.mat creations

eqDivmaxeq = (1:length(origines))/length(origines);
eqtimeDivmaxtime = (origines-min(origines))'/(max(origines)-min(origines));
% % diffseq = diff((1:length(origines)).^(1/3))./diff(origines)';
diffseq = diff(1:length(origines))./diff(origines)';
diffseq = diffseq(diffseq<median(diffseq)+std(diffseq)/2) ;
maxeq = max(diffseq);
[neq,diffbinseq] = hist(diffseq,[0:maxeq/70:maxeq]);
cumulnormalizedNeq = cumsum(neq./sum(neq));
nomalizedNeoeq = diffbinseq./max(diffbinseq) ;
[alpEQ,lanEQ,mugEQ,omeEQ,fittedEQ]=fitcumnomalizedcreationrate(nomalizedNeoeq,cumulnormalizedNeq);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clstDivmaxeq = (1:length(cluster))/length(cluster);
clsttimeDivmaxtime = (cluster-min(cluster))/(max(cluster)-min(cluster));
% % diffsclst = diff((1:length(cluster)).^(1/3))./diff(cluster);
diffsclst = diff(1:length(cluster))./diff(cluster);
diffsclst = diffsclst(diffsclst<median(diffsclst)+std(diffsclst)/2) ;
maxclst = max(diffsclst);
[nclst,diffbinsclst] = hist(diffsclst,[0:maxclst/70:maxclst]);
cumulnormalizedNclst = cumsum(nclst./sum(nclst));
nomalizedNeoclst = diffbinsclst./max(diffbinsclst) ;
whos nomalizedNeoclst cumulnormalizedNclst
[alpCLST,lanCLST,mugCLST,omeCLST,fittedCLST]=fitcumnomalizedcreationrate(nomalizedNeoclst,cumulnormalizedNclst);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% erupDivmaxeq = (1:length(eruption))/length(eruption);
% eruptimeDivmaxtime = (eruption-min(eruption))/(max(eruption)-min(eruption));
% diffserup = diff(1:length(eruption))./diff(eruption);
% diffserup = diffsclst(diffserup<inf);
% maxerup = max(diffserup);
% [nerup,diffbinserup] = hist(diffserup,[0:maxerup/10:maxerup]);
% cumulnormalizedNerup = cumsum(nerup./sum(nerup));
% nomalizedNeoerup = diffbinserup./max(diffbinserup) ;
% [alpERUP,lanERUP,mugERUP,omeERUP,fittedERUP]=fitcumnomalizedcreationrate(nomalizedNeoerup,cumulnormalizedNerup);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure
fortimeplot=[];
fornormcumplot=[];
timeplot = subplot(1,5,[1 2]);
hold on
fortimeplot(1)=plot(eqtimeDivmaxtime,eqDivmaxeq,'--b','linewidth',2);
fortimeplot(2)=plot(clsttimeDivmaxtime,clstDivmaxeq,'-','color',[0.7 0.7 0.7],'linewidth',2);
% fortimeplot(3)=plot(eruptimeDivmaxtime,erupDivmaxeq,'-g','linewidth',2);
hold off
box on
xlabel('Normalized time [\Deltat/\Deltatm]')
ylabel('Normalized cumulate number')
legend(fortimeplot,'Earthquakes','Clusters','location','SouthEast') %,'Eruptions'
axis image


histo(1) = subplot(3,10,[5 6]);
bar(diffbinseq,neq);
box on
% xlabel('\Deltaeq^(^1^/^3^)/\Deltat')
xlabel('\Deltaeq/\Deltat')
ylabel('n')
title('Histogram of seismicity rate')
axis tight

histo(2) = subplot(3,10,[15 16]);
bar(diffbinsclst,nclst)
box on
% xlabel('\Deltaclst^(^1^/^3^)/\Deltat')
xlabel('\Deltaclst/\Deltat')
ylabel('n')
title('Histogram of clustered seismicity rate')
axis tight

% histo(3) = subplot(3,10,[25 26]);
% bar(diffbinserup,nerup)
% box on
% % xlabel('\Deltaclst^(^1^/^3^)/\Deltat')
% xlabel('\Deltaclst/\Deltat')
% ylabel('n')
% title('Histogram of eruption rate')
% axis tight


normcumplot = subplot(1,5,[4 5]);
hold on
fornormcumplot(1)=plot(nomalizedNeoeq,cumulnormalizedNeq,'--b','linewidth',2);
fornormcumplot(2)=plot(nomalizedNeoeq,fittedEQ,'-b','linewidth',1);

fornormcumplot(3)=plot(nomalizedNeoclst,cumulnormalizedNclst,'-','color',[0.7 0.7 0.7],'linewidth',2);
fornormcumplot(4)=plot(nomalizedNeoclst,fittedCLST,'-k','linewidth',1);

% fornormcumplot(5)=plot(nomalizedNeoerup,cumulnormalizedNerup,'-g','linewidth',2);
% fornormcumplot(6)=plot(nomalizedNeoerup,fittedERUP,'-','color',[0 0.5 0],'linewidth',1);

hold off
box on
xlabel('Normalized creation rate [\tau/\taum]')
ylabel('\eta/\etamax')
set(normcumplot,'YAxisLocation','right')
test= 'Earthquakes' ; forlegend(1,1:length(test)) = test ;
test= ['Fitted with \alpha=' num2str(alpEQ) ', \lambda=' num2str(lanEQ) ', \muG=' num2str(mugEQ) ', \sigma=' num2str(omeEQ)] ; forlegend(2,1:length(test)) = test ;
test= 'Clustered eq.' ; forlegend(3,1:length(test)) = test ;
test= ['Fitted with \alpha=' num2str(alpCLST) ', \lambda=' num2str(lanCLST) ', \muG =' num2str(mugCLST) ', \sigma=' num2str(omeCLST)] ; forlegend(4,1:length(test)) = test ;
% test= 'Eruptions' ; forlegend(5,1:length(test)) = test ;
% test= ['Fitted with \alpha=' num2str(alpERUP) ', \lambda=' num2str(lanERUP) ', \muG =' num2str(mugERUP) ', \sigma=' num2str(omeERUP)] ; forlegend(6,1:length(test)) = test ;
legend(fornormcumplot,forlegend,'location','SouthEast')
axis image



figure;dimlessTempNFlux([alpEQ alpCLST],[mugEQ mugCLST ],[0 0 1 ; 0.7 0.7 0.7 ]); % alpERUP %mugERUP %; 0 1 0