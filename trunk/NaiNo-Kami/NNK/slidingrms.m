function [OUT] = slidingrms(IN,fen)



tmp = zeros(size(IN,1)+(fen-1),size(IN,2));
tmp(fen:end,:) = IN ;
tmp(1:fen,:) = repmat(IN(1,:),fen,1) ;
IN = tmp ;
OUT = IN ;
INsquare = IN.^2 ;
OUT(fen,:) = sum(INsquare(1:fen,:)) ;
for i = fen+1 : size(INsquare,1)
    OUT(i,:) = OUT(i-1,:)-INsquare(i-fen,:)+INsquare(i,:) ;
end
OUT = OUT(fen:end,:) ;

