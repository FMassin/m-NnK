function plot_path

start_path=[pwd '/'];
if exist('../tmp/plot_NNK.mat','file')== 2
    load ../tmp/plot_NNK.mat ; 
    if ischar(pathname) == 1
        start_path=pathname ;
    end
end

[filename, pathname] = uigetfile(start_path,'Pick any file in NNK results directory you want') ; 
pathname = char(pathname);
if exist('../tmp/plot_NNK.mat','file')==2
    save ../tmp/plot_NNK.mat pathname -append
else
    save ../tmp/plot_NNK.mat pathname
end
