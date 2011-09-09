function [lacell] = col2cell(lacell,lacol,col)

a=size(lacell,1);
for i=1:a;
    lacell{i}(lacol)=col(i);
end