function [img1]=imag_tclust(backcolor)

img1=backcolor*ones(16,16,3);
img1(:,:,1)=rand(16,16);
img1(:,:,2)=rand(16,16);
img1(:,:,3)=rand(16,16);
for i=1:16
    img1(i,:,1)=img1(1,:,1);
    img1(i,:,2)=0;
    img1(i,:,3)=img1(1,:,3);
end

n=30;
l=fix(rand(1,n)*15)+1;c=fix(rand(1,n)*15)+1;s=fix(rand(1,n)*2)+1;col=rand(1,n);
for i=1:n
    img1(l(i),c(i),s(i))=col(i);
end

