function [out]=split(sep,in)

if size(in,2) == 1 ; in=in'; end
if in(1,end) == sep ; in=in(1,1:end-1); end
if in(1,1) ~= sep ; in(1,1:end+1)=[sep in(1,:)]; end

ind = find(in==sep);
ind=[ind(ind<size(in,2))  size(in,2)+1 ];
num=0;
for i=1:length(ind)-1
    num=num+1;
    out(num,1:ind(i+1)-ind(i)-1) = in(ind(i)+1:ind(i+1)-1) ;
end
    
