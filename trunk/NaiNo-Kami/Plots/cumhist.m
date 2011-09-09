function [Rx,Ry]=cumhist(X,Y,n)

X=reshape(X,numel(X),1);
Y=reshape(Y,numel(Y),1);

if numel(n) == 1
    n=n+1;
    Rx = linspace(nanmin(X),nanmax(X),n);
else
    Rx = n;
end

for i=2:numel(Rx)
    if i==2
        ind = logical(X<Rx(i));
    elseif i==numel(Rx)
        ind = logical(X>=Rx(i-1));
    else
        ind = logical(X>=Rx(i-1)).*logical(X<Rx(i));
    end
    Ry(i-1,1) = nansum(Y(logical(ind)));
end
Rx = Rx(2:end)';