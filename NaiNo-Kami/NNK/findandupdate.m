function [ind,in]=findandupdate(in,marq)

lim = max([size(in,2) size(marq,2)]);
in(1:end,end+1:lim)=' ';
marq(1,end+1:lim)=' ';
test=findstr(reshape(in',1,numel(in)),marq) ;

if numel(test)== 0
    ind = size(in,1)+1;
    in=[in ; marq] ;
else
    ind = (test+size(in,2)-1)/size(in,2);
end
