function [LAT, LON, DEP, IND]=ginputm(N)

[LAT, LON] = inputm(N);
DEP(1:length(LAT)) = 0 ;
IND(1:length(LAT)) = NaN ;

if numel(LAT)==0
    disp('You didn t choose a map axe, it s OK, I just need you to re-click the same spot please...')
    [X]=ginput(N);
    cond1 = get(gca,'XAxisLocation');
    cond2 = get(gca,'YAxisLocation');
    if strcmp(cond1,'top')& strcmp(cond2,'left') 
        LAT = X(:,2)  ;
        DEP = X(:,1) ;
        LON(1:length(LAT)) = nanmin(get(gca,'zlim')) ;
    elseif strcmp(cond1,'bottom')& strcmp(cond2,'right') 
        LON = X(:,1);
        DEP = X(:,2);
        LAT(1:length(LON)) = nanmmin(get(gca,'zlim')) ;
    elseif strcmp(cond1,'bottom')& strcmp(cond2,'left') 
        IND = round(X(:,2)) ;
        LON(1:length(IND)) = -110 ;
        DEP(1:length(IND)) = 0 ;
        LAT(1:length(IND)) = 44 ;
    end
end