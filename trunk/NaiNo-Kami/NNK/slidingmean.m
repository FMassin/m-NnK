function [OUT] = slidingmean(IN,fen)


a = fen ;
if fix(a/2) == fen/2 
    avt = fix(a/2-1) ;
    apr = fix(a/2) ;
else
    avt = fix(a/2) ;
    apr = fix(a/2) ;
end

tmp = zeros(size(IN,1)+avt+apr,size(IN,2)) ;
tmp(avt+1:size(IN,1)+avt,:) = IN ;
tmp(1:avt,:) = repmat(IN(1,:),avt,1) ;
tmp(size(IN,1)+avt+1:end,:) = repmat(IN(end,:),apr,1) ;

IN = tmp ;
OUT = IN ;
OUT(1:avt+1,:) = repmat(mean(IN(avt+1:avt+apr+1,:),1),avt+1,1) ;

INdivided = IN./fen ;
for i = avt+2 : size(IN,1)-apr 
    OUT(i,:) = OUT(i-1,:)-INdivided((i-1)-avt,:)+INdivided(i+apr,:) ;
end
OUT = OUT(avt+1:end-apr,:) ;

