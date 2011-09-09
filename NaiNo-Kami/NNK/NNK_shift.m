function [X]=NNK_shift(X,TS,dshift)


d=min([size(X,2) 50]);
X=X-repmat(mean(X(:,1:d)')',1,size(X,2));

d=size(X,2);
the0=zeros(size(X,1),dshift);
X=[the0 X the0];
for i=1:length(TS)
    X(i,1:d)=X(i,TS(i):TS(i)+d-1);
end
X=X(:,1:d);