function [col] = cell2col(lacell,lacol,lim)

col =[];
comm='';
a=size(lacell,1);
for i=1:a;
    comm=[comm ';lacell{' num2str(i) '}(' num2str(lacol) ')'];
end;
comm=['col=[' comm(2:end) '];'];
eval(comm);
if exist('lim','var')==1;col(lim+1:a)=0;end