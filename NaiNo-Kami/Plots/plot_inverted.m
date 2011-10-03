function plot_inverted

load ../tmp/plot_NNK.mat ; 
if length(param)<8
    param(8)=1;
end
param(8)=-1*param(8); 

save ../tmp/plot_NNK.mat param -append