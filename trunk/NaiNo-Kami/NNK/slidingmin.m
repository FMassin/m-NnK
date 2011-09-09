function [OUT] = slidingmin(IN,fen)

fen = fix(fen) ; 
TMP = IN;
for i = fen+1 : size(IN,1)-fen
    TMP(i,:) = min(IN(i:i+fen,:)) ;
end
OUT = TMP ;
