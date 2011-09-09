function [img1]=imag_signal(backcolor)

img1=backcolor*ones(16,16,3);
color=[0 0 1];

%-
deb=1;
n=4;
img1([8 8 8 8],[deb:deb+3],1:3) = repmat(reshape([color],1,1,3),n,n);

%\
deb=4;
n=2;
img1([8:9],deb+([1 1]),1:3) = repmat(reshape([color],1,1,3),n,n);
img1([10:11],deb+([2 2]),1:3) = repmat(reshape([color],1,1,3),n,n);
img1([12:13],deb+([3 3]),1:3) = repmat(reshape([color],1,1,3),n,n);
img1([14:15],deb+([4 4]),1:3) = repmat(reshape([color],1,1,3),n,n);

%/
deb=8;
n=4;
img1([15:-1:12],deb+([1 1 1 1]),1:3) = repmat(reshape([color],1,1,3),n,n);
img1([11:-1:8],deb+([2 2 2 2]),1:3) = repmat(reshape([color],1,1,3),n,n);
img1([7:-1:4],deb+([3 3 3 3]),1:3) = repmat(reshape([color],1,1,3),n,n);
n=3;
img1([3:-1:1],deb+([4 4 4]),1:3) = repmat(reshape([color],1,1,3),n,n);

%\
deb=12;
n=2;
img1([1:2],deb+([1 1]),1:3) = repmat(reshape([color],1,1,3),n,n);
img1([3:4],deb+([2 2]),1:3) = repmat(reshape([color],1,1,3),n,n);
img1([5:6],deb+([3 3]),1:3) = repmat(reshape([color],1,1,3),n,n);
img1([7:8],deb+([4 4]),1:3) = repmat(reshape([color],1,1,3),n,n);


