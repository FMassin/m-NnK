function plotpickstat

for i = 1 :2
    figure
    
    one = importdata(['/home/fred/Documents/scripts/NaiNoKami/NaiNoKami_2/Utils/backedup_tmp' num2str(i) '.txt']) ;
    
    picks = one.data ; 
    stat = one.textdata ; 
    [poubelle,I] = sort(picks(:,1)) ;
    picks = picks(I,:);
    statP = stat(I,:) ;
    
    bar(picks,'stack') ;
    set(gca,'XTick',1:1:size(statP,1)) ;
    set(gca,'XTickLabel',statP) ;
    legend('P','S','Coda') ;
    if i == 1 ; title 'UUSS names' ; end
    if i == 2 ; title 'NNK names' ; end
    axis tight
    ax(i) = gca ;
end