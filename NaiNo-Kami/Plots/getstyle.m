function [style]=getstyle(in)

if exist('in','var')==0;in=1;end
c=['b';'r';'m';'k';'c';'g'];
f=['-';':';'.';'o';'x';'+'];
cnt=0;
for i=in:length(f);for ii=1:length(c)
        cnt=cnt+1;style(cnt,1:2)=[f(i) c(ii)];
    end;end