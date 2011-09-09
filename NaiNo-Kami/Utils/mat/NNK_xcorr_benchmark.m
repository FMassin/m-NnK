function NNK_xcorr_benchmark

n=1000;
count=0;
pas = fix(1+n/10);
for i=2:pas:n
    count =count+1 ;
    matrix = rand(450,i) ;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tic
    c = zeros(i,i);
    t=c;
    for ii=1:i
        for iii=1:i
            [CCCtmp,TStmp] = max(xcorr(matrix(:,ii),matrix(:,iii),'coeff'));
            c(ii,iii) = CCCtmp ;
            t(ii,iii) = (TStmp-450) ;
        end
    end
    times(3,count)=toc;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tic
    c = zeros(i,i);
    t=c;
    for ii=1:i
        for iii=1:i
            matproc = matrix(:,[ii iii]);
            [CCCtmp,TStmp] = NNK_xcorr(matproc);
            c(ii,iii) = CCCtmp(1,2) ;
            t(ii,iii) = (TStmp(1,2)-450) ;
        end
    end
    times(1,count)=toc;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tic
    c = zeros(i,i);
    t=c;
    [CCCtmp,TStmp] = NNK_xcorr(matrix);
    for ii=1:i
        c(ii,:) = CCCtmp(1,:) ;
        t(ii,:) = (TStmp(1,:)-450) ;
    end
    times(2,count)=toc;
    i
    save times.mat times
end
    
figure ; hold on
plot(times(1,:),'or')
plot(times(2,:),'og')
plot(times(3,:),'+k')
legend('1 par 1','1 par ligne')
    