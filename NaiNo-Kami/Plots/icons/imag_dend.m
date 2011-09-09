function [img1]=imag_dend(backcolor)

img1=backcolor*ones(16,16,3);
lines=round(1+rand(8,16))-1;
img1(1:2:16,:,1)=lines;
img1(1:2:16,:,2)=1-lines;
img1(1:2:16,:,3)=lines;