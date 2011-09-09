function [th,hp,pth]=plot_NNKtools(fh,backcolor,bar1)

set(fh,'Position',bar1)

hp(1) = uipanel('Title','Controls','Position',[0 0 1/9 99/100]);
hp(2) = uipanel('Title','Figure','Position',[1/9 0 8/9 99/100]);

% Create the toolbar
%th = findall(fh,'Type','uitoolbar');
th = uitoolbar(fh);
% Add a push tool to the toolbar
pth(1) = uipushtool(th,'CData',geticon('NNK'),'Separator','on',...
    'TooltipString','Info',...
    'HandleVisibility','off','ClickedCallback','plot_info');

% Add a push tool to the toolbar
pth(2) = uipushtool(th,'CData',geticon('path'),'Separator','on',...
    'TooltipString','set NNK results path',...
    'HandleVisibility','off','ClickedCallback','plot_path');
% Add a push tool to the toolbar
pth(7) = uipushtool(th,'CData',geticon('database'),...
    'TooltipString','Check database',...
    'HandleVisibility','off','ClickedCallback','plot_dtb');

% Add a push tool to the toolbar
pth(3) = uipushtool(th,'CData',geticon('trace'),'Separator','on',...
    'TooltipString','Check all loaded waveforms',...
    'HandleVisibility','off','ClickedCallback','plot_WFexist');
% Add a push tool to the toolbar
pth(4) = uipushtool(th,'CData',imag_CCC(backcolor),...
    'TooltipString','Check cross-correlation coefficients',...
    'HandleVisibility','off','ClickedCallback','plot_CCC');

% Add a push tool to the toolbar
pth(5) = uipushtool(th,'CData',geticon('dendo'),'Separator','on',...
    'TooltipString','Plot dendrogram',...
    'HandleVisibility','off','ClickedCallback','plot_dendro');

% Add a push tool to the toolbar
pth(6) = uipushtool(th,'CData',geticon('reloc'),...
    'TooltipString','Check relavite locations',...
    'HandleVisibility','off','ClickedCallback','plot_reloc');  %choix dun cluster et  affichage radiobuttons (trace hyp hypdd fp Mo measures etc) 

if exist('plot_NNK.mat','file')==2
    save plot_NNK.mat fh hp pth -append
else
    save plot_NNK.mat fh hp pth
end