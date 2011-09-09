function [Yout,Xtmp]=diffhist(Y,X,YY)


if exist('YY','var') ==0
    Yout=zeros(1,numel(X));
    for i=1:size(Y,2)
        for ii=1:size(Y,1)
            [Ytmp,Xtmp]=hist(abs(Y(ii,i)-Y([1:ii-1 ii+1:size(Y,1)],i)),X);
            Yout = Yout+Ytmp;
        end
    end
elseif exist('YY','var') ==1
    Yout=zeros(1,numel(X)-1);
    for i=1:size(Y,2)
        for ii=1:size(Y,1)
            ind = [1:5:ii-1 ii+1:5:size(Y,1)];
            [Xtmp,Ytmp]=cumhist(abs(Y(ii,i)-Y(ind,i)),YY(ind,i),X);
            Yout = Yout+Ytmp';
            
        end
    end
end



