function [X,Strwfs,cnt0]=cell2mat2(Strwfs,indices,i2,i3,i4,i5,d,faster)

maxd=0;
for j=indices
    maxd=max([maxd size(Strwfs{j,i2,i3,i4,i5},1)]);
end

for j=indices
    if size(Strwfs{j,i2,i3,i4,i5},1) < maxd   
        Strwfs{j,i2,i3,i4,i5}(d:maxd,1) = 0;
    end
end
X = cell2mat(Strwfs(indices,i2,i3,i4,i5)) ;
X = reshape(X,maxd,length(indices))';
cnt0=size(X,1);
if cnt0 ~= length(indices)
    X=faster;cnt=0;cnt0=0;
    for j=indices
        cnt=cnt+1;
        if length(Strwfs{j,i2,i3,i4,i5}) >= d
            cnt0=cnt;
            x=Strwfs{j,i2,i3,i4,i5} ;
            X(cnt,1:d)= x(1:d) ;
        else
            %disp(['Slave warning length of ' num2str(j) ' is ' num2str(length(Strwfs{j,i2,i3,i4})) '/' num2str(d) ])
            Strwfs{j,i2,i3,i4,i5}=faster(1,1:d)';
        end
    end
end


