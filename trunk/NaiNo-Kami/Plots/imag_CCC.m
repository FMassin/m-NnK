function [img1]=imag_CCC(backcolor)

img1=backcolor*ones(16,16,3);
img1(:,:,1)=rand(16,16);
img1(:,:,2)=rand(16,16);
img1(:,:,3)=rand(16,16);
for i=1:16
    for ii=1:16
        img1(i,ii,1)=img1(ii,i,1);
        img1(i,ii,2)=img1(ii,i,2);
        img1(i,ii,3)=img1(ii,i,3);
    end
    img1(i,i,1:3)=1;
end