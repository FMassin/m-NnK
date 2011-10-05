function [knownclust]=isknownclust(record)
knownclust=0;
for j=1:length(record)-3
    if strcmp(record(j:j+3),'clst')==1
        knownclust=1;
        break
    end
end