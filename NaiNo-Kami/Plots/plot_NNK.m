function plot_NNK

mypaths

%names
 record = 'tmp4.txt';
   stat = 'tmp5.txt';
  compo = 'tmp6.txt';
    WFS = 'tmp0.mat';
   CCCs = 'tmp1_0.mat' ;
clstevt = 'tmp9.txt';
clstind = 'tmp8.txt';
clstpth = 'tmp7.txt'; 
Clustered = 'clstCC.mat';
param = [-1 -1 -1];

% interface graph %%%%%%%%%%%%%%%%%%%%%%%%%%
monitor = get(0,'MonitorPosition');
bar1 = [1 monitor(4) monitor(3) 1];
bar2 = [1 monitor(4) monitor(3) fix(19*monitor(4)/20)];
fh = figure('Name','NNK !',...
	'NumberTitle','off', ...
	'PaperUnits','Normalized', ...
	'Position',bar1, ...
	'Tag','Fig99');

colordef(gcf,'white')
backcolor=0.93;
[th,hp,pth]=plot_NNKtools(fh,backcolor,bar1);


if exist('../tmp/plot_NNK.mat','file')==2
    save ../tmp/plot_NNK.mat backcolor param bar2 bar1 fh th hp  pth record stat compo CCCs WFS clstind clstevt clstpth Clustered -append
else
    save ../tmp/plot_NNK.mat backcolor param bar2 bar1 fh th  hp pth record stat compo CCCs WFS clstind clstevt clstpth Clustered
end






if nargout > 0, fig = h0; end


please
