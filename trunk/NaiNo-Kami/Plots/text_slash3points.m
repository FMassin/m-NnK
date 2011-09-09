function [img1]=text_slash3points(backcolor)

img1=backcolor*ones(16,16,3);

%/
deb=1;
img1([15:-1:12],[deb deb deb],1:3) = 0.3;
img1([11:-1:8],deb+([1 1 1]),1:3) = 0.3;
img1([7:-1:4],deb+([2 2 2]),1:3) = 0.3;
img1([3:-1:1],deb+([3 3 3]),1:3) = 0.3;

%...
deb=8;
img1(14,deb,1:3) = 0.3;
img1(14,deb+3,1:3) = 0.3;
img1(14,deb+6,1:3) = 0.3;
