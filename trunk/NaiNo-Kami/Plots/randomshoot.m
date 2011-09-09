function [out]=randomshoot(domain)

out=zeros(length(domain),1);
libres=ones(length(domain),1);
for i=1:length(domain)
    [ind,val]=find(libres>0)    ;
    test = ceil(rand(1,1).*(length(libres>0)));
    if test==0 ; test=1;elseif test>length(ind);test=length(ind);end
    out(i)=domain(ind(test));
    libres(ind(test)) = 0;
end