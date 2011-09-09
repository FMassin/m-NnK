function plot_lims(in)
global clust oldclust a dates1 dates2 cumnums clustratio uniqratio neoratio endratio fieldedit   hpp hp


lims = [str2num(get(fieldedit(12),'string')) str2num(get(fieldedit(13),'string')) ...
    str2num(get(fieldedit(14),'string')) str2num(get(fieldedit(15),'string')) ...
    str2num(get(fieldedit(16),'string')) str2num(get(fieldedit(17),'string'))];

[hpp] = resizepanels(hp,hpp,1);
ax(1)=subplot(1,1,1,'parent',hpp(end),'layer','top');

plot_Yell(ax(1),lims(1:4)) ; %[-111.2 -110.7 44.75 44.8])