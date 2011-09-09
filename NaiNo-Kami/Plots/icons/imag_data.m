function [icon]=imag_data(backcolor)

[X,map] = imread(fullfile(pwd,'icons','database.gif'));icon = ind2rgb(X,map) ;

