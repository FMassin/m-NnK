function [indotherstatproches] = NNK_binder_onestation(event,indotherstatproches,Csta)


for ii = 1 : size(event,1)
    currentsta = event(ii,Csta) ;
    repelt = find(event(:,Csta)==currentsta) ;
    if length(repelt) > 1
        [val,choice]=min(abs(event(1,1)-event(repelt,1))) ;
        choice = repelt(choice);
        nochoice = repelt(logical(repelt~=choice)) ;
        indotherstatproches(nochoice) = 0 ;
    end
end
