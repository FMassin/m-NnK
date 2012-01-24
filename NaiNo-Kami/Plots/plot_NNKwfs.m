function [ax,ploted,hlegend]=plot_NNKwfs(data,dataless,clust,ax,in,nets,stas)


subxlims =[10 100000] ;
logtick = [10;100;1000;10000;100000];

ploted =[];
hlegend = [];
if exist('ax','var')==0;ax=gca;end
if exist('in','var')==0;in=1;end
if exist('nets','var')==0 ; nets = 1:size(data,2) ; end
if exist('stas','var')==0 ; stas = 1:size(data,3) ; end
flagexist = 0;hlegend=[];sec2day=(1/(24*60*60));cnt = 0;
[style]=getstyle(in);
pos = get(ax,'Position');
mempos=get(ax,'position');
pos=mempos;
total = 0;
for net=nets ;
    for stat=stas;
        for compo=1:size(data,4);
            for pha=1:size(data,5);
                cnt = 0 ; 
                for ev=1:size(data,1); 
                    if length(dataless{ev,net,stat,compo,pha})>=6 
                        if sum(abs(data{ev,net,stat,compo,pha})) >0 
                            cnt=cnt+1;
                        end
                    end
                end
                if cnt>0
                    total=total+1 ; 
                end;end;end;end;end
% total=size(data,5)*size(data,4)*size(data,3)*size(data,2);
pos(4)=pos(4)/total;
cnto=0;
h=[];

for net=nets ;
    for stat=stas;
        for compo=1:size(data,4);
            for pha=1:size(data,5);
                cnt = 0 ; 
                for ev=1:size(data,1); 
                    if length(dataless{ev,net,stat,compo,pha})>=6
                        if sum(abs(data{ev,net,stat,compo,pha})) >0 
                            cnt=cnt+1;
                        end
                    end
                end
                if cnt>0
                    if cnto>0
                        mempos=get(ax(cnto),'position');
                    else
                        mempos = pos;
                    end
                    cnto=cnto+1;
                    ax(cnto)=subplot('Position',[pos(1) pos(2)+((cnto-1)*pos(4)) pos(3)*3/4 pos(4)*cnt/size(data,1)]);
                    ay(1) = ax(cnto) ; 
                    mat = zeros(10000,size(data,1)*1);
                    if size(data,1) >30;mat = zeros(10000,size(data,1)*2);end
                    cnt=0;
                    leg='';
                    for ev=1:size(data,1);
                        if length(dataless{ev,net,stat,compo,pha})>=6 & sum(abs(data{ev,net,stat,compo,pha})) >0
                            cnt=cnt+1;
                            
                            %disp([num2str(ev) ' ' char(dataless{ev,net,stat,compo,pha}{12})])
                            
                            answ = [dataless{ev,net,stat,compo,pha}{2} '-' ...
                                dataless{ev,net,stat,compo,pha}{3} '-'...
                                dataless{ev,net,stat,compo,pha}{4} '-' ...
                                dataless{ev,net,stat,compo,pha}{5} ' ' ...
                                datestr(dataless{ev,net,stat,compo,pha}{6})];
                            
                            if strcmp(char(dataless{ev,net,stat,compo,pha}{12}(1:7)),'Stacked')==1;answ(:)=' ';answ(end-6:end)='Stacked';end
                            leg(cnt,1:length(answ)) = answ;
                            
                            a=data{ev,net,stat,compo,pha};
                            mat(1:size(a,1),cnt) = a(:,1) ;
                        end
                    end
                    mat = mat(1:length(a),1:cnt);
                    maximas = max(abs(mat(1:fix(size(mat,1)/2),:))) ;
                    normal = repmat(maximas,size(mat,1),1);
                    mat = mat./normal;
                    t = repmat(((0:size(mat,1)-1)/100)',1,size(mat,2));

                    if size(data,1)*total >130
                        mat = mat(1:end,end:-1:1);
                        h = imagesc(t(1:length(a),1),size(mat,2)-1:-1:0,sign(mat').*(abs(mat').^0.5),'parent',ax(cnto));
                        set(ax(cnto),'ytick',0:size(mat,2)-1,'yticklabel',leg(end:-1:1,12:end))
                    else
                        toplot=mat ; 
                        toplot=(toplot/1.5)+repmat((0:size(mat,2)-1),size(mat,1),1) ; 
                        h = plot(t,toplot,'color','m','linewidth',1.25,'parent',ax(cnto));
                        hold on 
                        toplot=mat./1.5 ; toplot(toplot<=0)=nan;
                        toplot=toplot+repmat((0:size(mat,2)-1),size(mat,1),1) ; 
                        h2 = plot(t,toplot,'color','b','linewidth',1.25,'parent',ax(cnto));
                        h=[h;h2];
                        hold off
                        set(ax(cnto),'ytick',0:size(mat,2)-1,'yticklabel',leg(:,12:end))
                    end
                    toplot=mat ;
                    toplot=(toplot/1.5)+repmat((0:size(mat,2)-1),size(mat,1),1) ;
                    ylim([min(min(toplot)) max(max(toplot))])
                    grid on
                    Ylabel(['Norm. amp. [' leg(1,1:10) ']'])
                    if cnto ==1 
                        xlabel('Times [s]')
                    elseif cnto ==total   
                        set(ax(cnto),'xaxislocation','top') ;
                        xlabel('Times [s]')
                    else
                        set(ax(cnto),'xticklabel','') ;
                    end
                    
                    
                    X=logspace(log10(min(maximas)),log10(max(maximas)),max([3 ceil(length(maximas)/5)]));
                    a = hist(maximas,X) ;
                    b=[] ;
                    x=[] ; 
                    for bin=1:length(a);
                        b=[b a(bin) a(bin) 0];%a(bin)
                        pas = (X(bin) - X(max([bin-1 1])))/2 ;
                        x=[x X(bin)-pas X(bin)-pas X(bin)-pas ];
                    end
                    b=b(1:end-2);
                    x=x(3:end);
                    x=[x(end) x(1) x x(end)];
                    b=[0 0 b 0];
                    
                    ay(2)=subplot('Position',[pos(1)+pos(3)*3/4 pos(2)+((cnto-1)*pos(4)) pos(3)*1/4 pos(4)*cnt/size(data,1)]);
                    if exist('clust','var') ==0
                        hold on
                        semilogx(x,b,'-','color',[0.7 0.7 0.7],'linewidth',2,'Parent',ay(2));
                        semilogx(maximas,0:size(mat,2)-1,'ob','linewidth',2,'Parent',ay(2))
                        hold off
                        linkaxes(ay,'y')
                        grid on
                        box on
                        if cnto==1
                            xlabel('Max amp.')
                            set(ay(2),'yaxislocation','right','xlim',subxlims,'XScale','log','xtick',logtick) ;
                        elseif cnto==total
                            set(ay(2),'yaxislocation','right','xlim',subxlims,'XScale','log','xaxislocation','top','xtick',logtick) ;
                            xlabel('Max amp.')
                        else
                            set(ay(2),'yaxislocation','right','xlim',subxlims,'XScale','log','xtick',logtick,'xticklabel','') ;
                        end
                    else
                    end
                end
end;end;end;end;
%whos ax
%colormap('hot')
% linkaxes(ax,'x')
ploted = h ;

% for i=1:length(ax)
%     pos(i,1:4) = get(ax(i),'position');
% end
% ratio = 0.95/sum([pos(:,4);pos(1,2)]) ; 
% for i=1:length(ax)
%     if i==1
%         set(ax(i),'position',[pos(i,1) pos(i,2) pos(i,3) pos(i,4)*ratio]) ; 
%     else        
%         set(ax(i),'position',[pos(i,1) pos(i-1,2)+pos(i-1,4)*ratio pos(i,3) pos(i,4)*ratio]) ; 
%     end
% end
