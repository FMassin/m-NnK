function [OUT] = slidingsum(IN,fen)


IN=[IN(1:fen) IN];

tmp = zeros(size(IN,1)+(fen-1),size(IN,2));
hop = 1:size(tmp,1)-fen+1;
tmp(hop,:) = IN(1:length(hop)) ;

tmp(size(tmp,1)-fen+1:size(tmp,1),:) = repmat(IN(size(IN,1),:),fen,1) ;
IN = tmp ;
OUT = IN ;
OUT(1,:) = sum(IN(1:fen,:)) ;
for i = 2 : size(IN,1)-fen+1
    OUT(i,:) = OUT(i-1,:)-IN(i-1,:)+IN(i+fen-1,:) ;
end
OUT = OUT(1:end-fen+1,:) ;

OUT = OUT(fen+1:end);

