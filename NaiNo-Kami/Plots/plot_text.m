function [h]=plot_text(texte,w)

%monitor = get(0,'MonitorPosition');
%,'position',[monitor(3)/2-(monitor(3)/2.5) monitor(4)/2-(monitor(4)/5) monitor(3)/5 monitor(4)/10],'
h = msgbox(texte,'NNK speack to you','help') ;

if w==0;
    pause(1.5)
    if any(ishghandle(h,'figure'))==1 ;     close(h)    ;end
end

