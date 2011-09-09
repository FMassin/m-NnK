function [hpp] = resizepanels(hp,hpp,in)


hpp = hpp(hpp~=0);
total=length(hpp)+in;
old = [0 0 1 1];
for i=1:length(hpp)
    old = get(hpp(i),'pos');
    set(hpp(i),'pos',[old(1) (i-1)/total old(3) 1/total])
    uicontrol('Parent',hpp(i),'Style','pushbutton',...
    'Units','normalized','Position',[0 0 1/30 1],...
    'String','clr','TooltipString','Clear this graph','Callback',['clearselected(' num2str(i) ');']);
end
for i=length(hpp)+1:total
    hpp(i)=uipanel('parent',hp(end),'pos',[old(1) (i-1)/total old(3) 1/total],'BackgroundColor','w');
    uicontrol('Parent',hpp(i),'Style','pushbutton',...
    'Units','normalized','Position',[0 0 1/30 1],...
    'String','clr','TooltipString','Clear this graph','Callback',['clearselected(' num2str(i) ');']);
end



