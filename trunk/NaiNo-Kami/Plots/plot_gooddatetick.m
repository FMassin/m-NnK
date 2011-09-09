function plot_gooddatetick(ax,loc,no)



if exist('ax','var') ==0;ax=gca;end
if exist('loc','var') ==0;loc='x';end
if exist('no','var') ==0;no=0;end

        
for laxe=ax
    axes(laxe);    
    [format]=datetick(laxe,loc,'keeplimits')   ;
    box on;
    grid on;
   
    title = ['{\bf Time [' format ']}'];
    if no~=0;
        title=' ';
        xticklabel=get(laxe,[loc 'ticklabel']);
        xticklabel=repmat(' ',size(xticklabel,1),1);
        set(laxe,[loc 'ticklabel'],xticklabel)
    end
    eval([loc 'label(title)']);
    set(laxe,'layer','top')
end




% 
% xticks=get(laxe,[loc 'tick']);
%     format=' yyyy-mmm-dd HH:MM:SS,FFF';
%     indtest=[5 9 12 15 18 20 24];
%     xticklabel=datestr(xticks,format);
%     
%     tmp=xticklabel;tmp2=format;
%     for i=indtest;flag=1;
%         for ii=2:size(xticklabel,1);if strcmp(xticklabel(1,1:i),xticklabel(ii,1:i))==0
%                 flag=0;end;end
%         if flag==1;tmp=xticklabel(:,i+2:end);tmp2=format(1,i+2:end);end
%     end
%     xticklabel=tmp;format=tmp2;
%     
%     tmp=xticklabel;tmp2=format;
%     for i=size(xticklabel,2):-1:2;flag=1;
%         for ii=2:size(xticklabel,1);if strcmp(xticklabel(1,i:end),xticklabel(ii,i:end))==0
%                 flag=0;end;end
%         if flag==1;tmp=xticklabel(:,1:i-1);tmp2=format(1,1:i-1);end
%     end
%     xticklabel=tmp;format=tmp2;