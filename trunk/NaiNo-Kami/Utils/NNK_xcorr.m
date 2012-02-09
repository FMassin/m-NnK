function [corrcoef,trashift] = NNK_xcorr(x)


[M,N] = size(x);
for i = 1 : N    
    x(:,i) = x(:,i) - mean(x(:,i)) ; 
end
maxlag = size(x,1)-1 ; 


% Cross-correlations %%%%%%%%%%%%%%%
X = fft(x,2^nextpow2(2*M-1));
clear x
Xc = conj(X);
[MX,NX] = size(X);
C = zeros(2,NX*NX);
maxite = sum([1:N]) ;
frac = 0 ; 
for n =1:N, 
    frac = sum([1:n])/maxite ; 
    
    temp = real(ifft(repmat(X(:,n),1,n).*Xc(:,1:n)));
    %temp = real(ifft(repmat(X(:,n),1,N).*Xc));%(:,1:n)
    temp = [temp(end-maxlag+1:end,:);temp(1:maxlag+1,:)];
    [val,ind] = max(temp) ;
    lim1 = ((n-1)*N)+1 ;
    lim2 = lim1+length(val)-1 ; 
    C(1,lim1:lim2) = val ;
    C(2,lim1:lim2) = ind ;
end
clear Xc X temp ind val



% Normalization %%%%%%%%%%%%%%%%%%%%
[mc,nc] = size(C);
jkl = reshape(1:nc,sqrt(nc),sqrt(nc))';
tmp = sqrt(C(1,diag(jkl)));
tmp = tmp(:)*tmp;
cdiv = reshape(tmp,1,N*N) ;
C(1,:) = C(1,:) ./ cdiv;
clear cdiv tmp jkl 



% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%
val = C(1,:) ;
ind = C(2,:) ;
corrcoef = zeros(N,N) ; 
trashift = corrcoef ; 
count = 0 ;
for  i = 1 : N : nc
    count = count  +1 ; 
    corrcoef(count,i-(i-1):i+N-1-(i-1)) = val(i:i+N-1) ; 
    trashift(count,i-(i-1):i+N-1-(i-1)) = ind(i:i+N-1)-1 ;     
end
clear C val ind 


dim = size(corrcoef,1) ; 
dim2 = dim^2 ; 
shift = (maxlag * 2) ; 
for i = 1 : dim
    corrcoef(1:i,i) = corrcoef(i,1:i)' ;
    trashift(1:i,i) = shift - trashift(i,1:i)' ;       
end
trashift = trashift+1;








