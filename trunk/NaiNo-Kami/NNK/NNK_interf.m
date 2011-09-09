function [interf]=NNK_interf(Xref,X,d)

for i=1:size(X,1)
    corrserie = xcorr([X(i,1:d) ; Xref(:,1:d)]','Coeff');
    corrserie = reshape(corrserie,(2*d)-1,2,2);
    interf(:,i) = corrserie(:,2,1);
end