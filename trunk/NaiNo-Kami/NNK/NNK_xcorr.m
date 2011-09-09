function [corrcoef,trashift] = NNK_xcorr(x,message)

if exist('message','var')==0;message='NNK_corr ';end;
[M,N] = size(x);

if N>500 % progress bar initiate %%%%%%%%%%%%%%%
maxi=N ;progress_bar_position=0;tic;count =0;end

for i = 1 : N   
    
    if N>500 % progress bar update %%%%%%%%%%%%%%%%%
        clc;count=count+1;[progress_bar_position] = textprogressbar(count,maxi,progress_bar_position,toc,message);tic ;end
    
    x(:,i) = x(:,i) - mean(x(:,i)) ; 
end
maxlag = size(x,1)-1 ; 

% Cross-correlations %%%%%%%%%%%%%%%
X = fft(x,2^nextpow2(2*M-1));
clear x
Xc = conj(X);
[MX,NX] = size(X);
C = zeros(2,NX*NX);

if N>500 % progress bar initiate %%%%%%%%%%%%%%%
maxi=N ;progress_bar_position=0;tic;count =0;end

for n =1:N,     
    if N>500 % progress bar update %%%%%%%%%%%%%%%%%
    clc;count=count+1;[progress_bar_position] = textprogressbar(count,maxi,progress_bar_position,toc,message);tic;end
               
    temp = real(ifft(repmat(X(:,n),1,n).*Xc(:,1:n)));
    %temp = real(ifft(repmat(X(:,n),1,N).*Xc));%(:,1:n)
    temp = [temp(end-maxlag+1:end,:);temp(1:maxlag+1,:)];
    [val,ind] = max(temp) ;
    lim1 = ((n-1)*N)+1 ;
    lim2 = lim1+length(val)-1 ; 
    C(1,lim1:lim2) = val ;
    C(2,lim1:lim2) = ind ;
end
clear Xc X temp ind val lim2 lim1 MX NX

% Normalization %%%%%%%%%%%%%%%%%%%%
jkl = reshape(1:size(C,2),sqrt(size(C,2)),sqrt(size(C,2)))';
tmp = sqrt(C(1,diag(jkl)));
tmp = tmp(:)*tmp;
cdiv = reshape(tmp,1,N*N) ;
C(1,:) = C(1,:) ./ cdiv;
clear cdiv tmp jkl 

% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%
corrcoef = reshape(C(1,:),N,N)' ; 
trashift = (reshape(C(2,:),N,N)-1)' ;
shift = (maxlag * 2) ; 
clear C maxlag


if N>500 % progress bar initiate %%%%%%%%%%%%%%%
maxi=N ;progress_bar_position=0;tic;count =0;end

for i = 1 : N
    if N>500 % progress bar update %%%%%%%%%%%%%%%%%
    clc;count=count+1;[progress_bar_position] = textprogressbar(count,maxi,progress_bar_position,toc,message);tic;end
    
    corrcoef(1:i,i) = corrcoef(i,1:i)' ;
    trashift(1:i,i) = shift - trashift(i,1:i)' ;       
end
trashift = trashift+1;








