function [icon]=geticon(file)
icon(1:16,1:16,1:3) =0;
if exist(fullfile(pwd,'icons',[file '.gif']),'file') ~= 0
    [X,map] = imread(fullfile(pwd,'icons',[file '.gif']));
    icon = ind2rgb(X,map) ;
end
