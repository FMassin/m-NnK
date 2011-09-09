function plot_dendro_1(in)
global clust oldclust a dates1 dates2 cumnums clustratio uniqratio neoratio endratio fieldedit   hpp hp


%prend les bons clusters
[time,indeq,lims] = taketime ;
[clust,oldclust,limx]=takeclust(oldclust);
if numel(indeq)>0
    [~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,clust] = filtclust(clust,indeq,lims);
    [~,~,~,~,~,~,~,~,~,~,dates2] = addisolate(lims);
    dates2=sort(dates2);
end


%prepare les truc a ploter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if in == 1                 % pour un dendrogram
    plotingsdtyle = 1;
    Y1 = [1:size(clust,1)];X1 =[];
    for i=Y1;X1 = [X1 cell2mat(clust{i}([1 end],3))];end
    X2 =[];Y2=[];
    for i=Y1;
        X2 = [X2 ;  cell2mat(clust{i}(:,3))];
        Y2 = [Y2 ; repmat(i,size(clust{i},1),1)];
        Ylat(i,1) = size(clust{i},1) ;
    end
    Y1=repmat(Y1,2,1);
    ylab = 'Cluster ID';
    styl={'-k' ; '.g'};
    colored = [0.6 0.6 0.6 ; 0 0 0 ];
    width=2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif in ==2              % pour une courbe cumulee de cluster
    plotingsdtyle = 1;
    Y1 = [1:size(clust,1)];
    Y2 = [1:size(clust,1)]; 
    X1 =[];
    X2 =[];
    
    for i=Y1;
        X2 = [X2 min(cell2mat(clust{i}([1 end],3)))];
        X1 = [X1 max(cell2mat(clust{i}([1 end],3)))];
    end
    ylab = 'N^{clst}';
    forlegend = ['Beginnings' ; ...
                 'Endinds   '];
    styl={'-k' ; '-g'};
    width=2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif in ==7              % pour les ratio clst/T et Uniq/T
    plotingsdtyle = 2;
    fortest = [1:size(clust,1)];
    originclust=[];
    limx=[999999999999 0];
    for i=fortest;
        limx = [min([ limx(1) min(cell2mat(clust{i}([1 end],3)))])  max([limx(2) max(cell2mat(clust{i}([1 end],3)))])];        
        originclust = [originclust ; cell2mat(clust{i}(:,3))];
    end
    originclust=sort(originclust,'ascend');
    clustnum = 1:length(originclust);    
    aver=diff(limx)/100;
    limx(2)=limx(2)+aver*5;limx(1)=limx(1)-aver*5;
%     dates1 = sort([dates2 ; originclust]) ;  cumnums = 1:length(dates1);

    
    inds1 = logical(logical(dates1 >= limx(1)) .* logical(dates1 <= limx(2))) ;
    Xt = dates1(inds1) ; 
    Yt = cumnums(inds1)-min(cumnums(inds1)) ;  
    inds2 = logical(logical(originclust >= limx(1)) .* logical(originclust <= limx(2))) ;
    X1 = originclust(inds2) ; 
    Y1 = clustnum(inds2) ; 
    inds2 = logical(logical(dates2 >= limx(1)) .* logical(dates2 <= limx(2))) ;
    X2 = dates2(inds2) ; 
    Y2 = uniqratio(inds2)-min(uniqratio(inds2)) ; 
    
    limx(2)=limx(2)-aver*5;limx(1)=limx(1)+aver*5;
    [Y1,X1,Y2,X2,Yt,Xt] = myresample(limx,Y1,X1',Y2,X2',Yt,Xt');
    ind=[1:min([length(X1) length(X2) length(Xt)])];
    Y1=Y1(ind);X1=X1(ind);
    Y2=Y2(ind);X2=X2(ind);
    Yt=Yt(ind);Xt=Xt(ind);
    average = fix(aver/mean(diff(X1)));
    ref=slidingsum(Yt',average);
    Y1=slidingsum(Y1',average)./ref;
    Y2=slidingsum(Y2',average)./ref;
    
    YY1 = (Y1./Y2)';
    XX1=X1;
    
%     YY1(:,2)=YY1(:,1); YY1(YY1(:,2)<=1,2) = NaN; % partie > 0 en couleur differente
%     YY2=diff(YY1(:,1))./diff(XX1(:,1)); % derive
%     XX2=XX1(2:end,1);
%     whos YY2 XX2
    
    ylab = ['Ratios N^{eq}./N^{total} [' num2str(aver) ' days av.]'];
    yylab = 'N^{clst}/N^{Uniq}';
    styl={'-g';'-r'};
    styyl={'-b';'-k'};
    forlegend=['Clustered';'Unique   '];
    width=2;
    ylims=[0 1];
    axy = 'plot';
    axyy = 'plot';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif in ==5              % pour une courbe cumulee de cluster
    plotingsdtyle = 2;
    Y1 = [1:size(clust,1)];
    Y2 = [1:size(clust,1)]; 
    X1 =[];
    X2 =[];
    load plot_NNK.mat
    for i=Y1;
        X1 = [X1 min(cell2mat(clust{i}([1 end],3)))];
        X2 = [X2 max(cell2mat(clust{i}([1 end],3)))];
    end
    [X2,inds]=sort(X2,'ascend');
    [X1,inds]=sort(X1,'ascend');    
    [tmpY1,tmpX1,tmpY2,tmpX2] = myresample([min([X1 X2]) max([X1 X2])],Y1 , X1, Y2 , X2 );
    ind=[1:min([length(tmpX1) length(tmpX2)])];
    XX1=tmpX1(ind);
    YY1=(tmpY1(ind)-tmpY2(ind));
    
    ylab = 'N^{clst}';
    styl={'-g' ; '-k' };
    axy = 'plot';
    
    yylab = 'diff(N^{clst})';
    styyl={'-b'};
    axyy = 'plot';
    
    forlegend = ['Beginnings' ; ...
                 'Endinds   ' ; ...
                 'Difference' ];
    width=2;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif in ==6              % pour une courbe cumulee de cluster
    plotingsdtyle = 2;
    YY1 = [1:size(clust,1)];
    YY2 = [1:size(clust,1)]; 
    XX1 =[];
    XX2 =[];
    load plot_NNK.mat
    for i=1:size(clust,1);
        XX1 = [XX1  min(cell2mat(clust{i}([1 end],3)))];
        XX2 = [XX2  max(cell2mat(clust{i}([1 end],3)))];
    end
    [XX2,inds]=sort(XX2,'ascend');
    [XX1,inds]=sort(XX1,'ascend');

    wiidth=1;
    styyl={'--g';'--k'};
    yylab = 'N^{clst}';
    forlegend = ['d(beginnings)/dt' ; ...
        'd(Endinds)/dt   ' ; ...
        'Beginnings      ' ; ...
        'Endinds         '];
    
    
     
    inds = logical(logical(XX1 >= limx(1)) .* logical(XX1 <= limx(2))) ;
    X1=XX1(inds);
    inds = find(diff(X1)>0);
    X1 = X1(inds+1) ;
    [tmpY1 , tmpX1] = myresample([min(X1) max(X1)],YY1(inds) , X1);
    Y1=diff(tmpY1)./(diff(tmpX1)) ;
    X1=tmpX1(2:end);
    %Y1=diff(YY1(inds))./(diff(X1)) ;
    %X1=X1(2:end);
     
    
    inds = logical(logical(XX2 >= limx(1)) .* logical(XX2 <= limx(2))) ;
    X2=XX2(inds);
    inds = find(diff(X2)>0);
    X2 = X2(inds+1) ; 
    [tmpY2 , tmpX2] = myresample([min(X2) max(X2)],YY2(inds) , X2);
    Y2=diff(tmpY2)./(diff(tmpX2)) ;
    X2=tmpX2(2:end);
    %Y2=diff(YY2(inds))./(diff(X2)) ;
    %X2=X2(2:end);
    
    yylims=[min([min(YY1) min(YY2)]) max([max(YY1) max(YY2)])];

    ylab = 'd(N^{clst}) [clst/day]';
    styl={'-g';'-k'};
    axy = 'plot';
    axyy = 'plot';
    width=2;
    ylims=[0 max([max(Y1) max(Y2)])];
    %limx =[min([XX1  XX2  X1  X2]) max([XX1  XX2  X1 X2]) ] ;    
    %[Y1 , X1, Y2 , X2 ] = myresample(limx,Y1 , X1, Y2 , X2 );
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif in ==3              % pour une courbe sismicite cumulee
    plotingsdtyle = 1;
    fortest = [1:size(clust,1)];
    originclust=[];
    limx=[999999999999 0];
    for i=fortest;
        limx = [min([ limx(1) min(cell2mat(clust{i}([1 end],3)))])  max([limx(2) max(cell2mat(clust{i}([1 end],3)))])];        
        originclust = [originclust ; cell2mat(clust{i}(:,3))];
    end
    originclust=sort(originclust,'ascend');
%     dates1 = sort([dates2 ; originclust]) ;  cumnums = 1:length(dates1);
    
    inds1 = logical(logical(dates1 >= limx(1)) .* logical(dates1 <= limx(2))) ;
    X1 = dates1(inds1) ; 
    Y1 = cumnums(inds1)-min(cumnums(inds1)) ;     
    inds2 = logical(logical(originclust >= limx(1)) .* logical(originclust <= limx(2))) ;
    X2 = originclust(inds2) ; 
    Y2 = 1:length(X2) ; 
    inds2 = logical(logical(dates2 >= limx(1)) .* logical(dates2 <= limx(2))) ;
    X3 = dates2(inds2) ; 
    Y3 = uniqratio(inds2)-min(uniqratio(inds2)) ; 
    
    ylab = 'N^{eq}';
    styl={'-b';'-g';'-r'};
    forlegend=['Total    ';'Clustered';'Unique   '];
    width=2;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif in ==4              % pour une derivee de courbe sismicite cumulee
    plotingsdtyle = 2;
    fortest = [1:size(clust,1)];
    originclust=[];
    %limx=[999999999999 0];
    for i=fortest;
        %limx = [min([ limx(1) min(cell2mat(clust{i}([1 end],3)))])  max([limx(2) max(cell2mat(clust{i}([1 end],3)))])];        
        originclust = [originclust ; cell2mat(clust{i}(:,3))];
    end
    originclust=sort(originclust,'ascend');
%     dates1 = sort([dates2 ; originclust]) ; cumnums = 1:length(dates1);
    
    inds1 = logical(logical(dates1 >= limx(1)) .* logical(dates1 <= limx(2))) ;
    XX1 = dates1(inds1)' ; 
    YY1 =  cumnums(inds1)-min(cumnums(inds1)) ;     
    inds2 = logical(logical(originclust >= limx(1)) .* logical(originclust <= limx(2))) ;
    XX2 = originclust(inds2)' ; 
    YY2 = 1:length(XX2) ; 
    inds2 = logical(logical(dates2 >= limx(1)) .* logical(dates2 <= limx(2))) ;
    XX3 = dates2(inds2)' ; 
    YY3 = uniqratio(inds2)-min(uniqratio(inds2)) ; 
    
    yylims=[min([min(YY1) min(YY2) min(YY3)]) max([max(YY1) max(YY2) max(YY3)])];
    styyl={'--b';'--g';'--r'} ; 
    yylab = 'N^{eq}';
    wiidth = 1;
    forlegend=['d(Total)/dt    ';'d(Clustered)/dt';'d(Unique)/dt   ';...
               'Total          ';'Clustered      ';'Unique         '];
    
           
    inds = find(diff(XX1)>0);
    X1=XX1(inds+1); 
    [tmpY1 , tmpX1] = myresample([min(X1) max(X1)],YY1(inds) , X1);
    Y1=diff(tmpY1)./(diff(tmpX1)) ;
    X1=tmpX1(2:end);
    %Y1=diff(YY1(inds))./(diff(X1)) ;
    %X1=X1(2:end);
    
    inds = find(diff(XX2)>0);
    X2=XX2(inds+1); 
    [tmpY2 , tmpX2] = myresample([min(X2) max(X2)],YY2(inds) , X2);
    Y2=diff(tmpY2)./(diff(tmpX2)) ;
    X2=tmpX2(2:end);
    %Y2=diff(YY2(inds))./(diff(X2)) ;
    %X2=X2(2:end);
    
    inds = find(diff(XX3)>0);
    X3=XX3(inds+1); 
    [tmpY3 , tmpX3] = myresample([min(X3) max(X3)],YY3(inds) , X3);
    Y3=diff(tmpY3)./(diff(tmpX3)) ;
    X3=tmpX3(2:end);
    %Y3=diff(YY3(inds))./(diff(X3)) ;
    %X3=X3(2:end);
    
    ylab = 'd(N^{eq}) [eq/day]';
    styl={'-b';'-g';'-r'};
    width=2;
    axy = 'plot';
    axyy = 'plot';
    ylims=[0 max([max(Y1) max(Y2) max(Y3)])];
    %limx =[min([XX1  XX2  X1  X2]) max([XX1  XX2  X1 X2]) ] ;
    %[Y1 , X1, Y2 , X2 ,Y3 , X3 ] = myresample(limx,Y1 , X1, Y2 , X2 ,Y3 , X3 );
    
end








%fait la place :
if plotingsdtyle ==1 
    [hpp] = resizepanels(hp,hpp,1);
    h=[];
    
    %plot 1:
    a(length(a)+1) = subplot(1,10,1:9,'parent',hpp(end));
    if exist('Y1','var')==1 & exist('YY1','var')==0;
        if numel(Y1)==numel(X1);
            if exist('colored','var') ==0
                h=plot(X1,Y1,styl{1},'parent',a(end));
            elseif exist('colored','var') ==1
                h=plot(X1,Y1,styl{1}(1),'parent',a(end),'color',colored(1,:));
            end
        end
    elseif exist('Y1','var')==1 & exist('YY1','var')==1;
        if numel(Y1)==numel(X1) & numel(YY1)==numel(XX1);
            [AX,h(1,1)]=plotyy(X1,Y1,XX1,YY1,'plot','plot',styl{1},styyl{1},'parent',a(end));
            a(end)=AX(1);            
        end;
    end
    % add eruption/swarm
    if exist('ylims','var')==1;set(a(end),'ylim',[0 ylims(2)]);drawnow;end %ylims(1)

    axis tight ; loc=pwd;cd ~/PostDoc_Utah/Datas/eruptions;Farrell_2007(a(end),limx,get(a(end),'ylim'));cd(loc)
    
    if exist('Y2','var')==1;if numel(Y2)==numel(X2);    hold on;tmp=plot(X2,Y2,styl{2},'parent',a(end));h=[h; tmp];hold off;end;end
    if exist('Y3','var')==1;if numel(Y3)==numel(X3);    hold on;tmp=plot(X3,Y3,styl{3},'parent',a(end));h=[h; tmp];hold off;end;end
    
    axes(a(end));
    if exist('width','var')==1;set(h,'linewidth',width);end
    if exist('forlegend','var')==1;legend(h,forlegend,'location','northwest');end
    if exist('ylab','var')==1;ylabel(['{\bf ' ylab '}']);if strcmp(ylab(1:4),'Deri')==1;ylim([0 1]);end;end
    if exist('yylab','var')==1 & exist('AX','var')==1;axes(AX(2));ylabel(['{\bf ' yylab '}']);if strcmp(yylab(1:4),'Deri')==1;ylim([0 1]);linkaxes(AX,'x');end;end

    axis tight
    if exist('limx','var')==1; set(a(end),'xlim',limx);end
    plot_gooddatetick(a(end))

end

if plotingsdtyle == 2 
    
    [hpp] = resizepanels(hp,hpp,1);
    h=[];
    
    a(length(a)+1) = subplot(1,10,1:9,'parent',hpp(end));
    if exist('axyy','var') ==0
        [AX,H1,H2]=plotyy(X1,Y1,XX1,YY1,'semilogy','plot',styl{1},styyl{1},'parent',a(end));h=H1;
    else
        [AX,H1,H2]=plotyy(X1,Y1,XX1,YY1,axy,axyy,styl{1},styyl{1},'parent',a(end));h=H1;
    end
    set(AX(1),'YColor',[0 0 0])
    set(AX(2),'YColor',[0.5 0.5 0.5])
    set(H1,'color',char(styl{1}(end)),'linestyle',char(styl{1}(1:end-1)));
    set(H2,'color',char(styyl{1}(end)),'linestyle',char(styyl{1}(1:end-1)));
    if numel(H2) > 1; set(H2(2),'color','m');end

    axes(AX(1));
    if exist('Y2','var')==1;if numel(Y2)==numel(X2);    hold on;tmp=plot(X2,Y2,styl{2},'parent',AX(1));h=[h; tmp];hold off;end;end
    if exist('Y3','var')==1;if numel(Y3)==numel(X3);    hold on;tmp=plot(X3,Y3,styl{3},'parent',AX(1));h=[h; tmp];hold off;end;end
    axis tight;
    if exist('ylims','var')==1;set(AX(1),'ylim',[0 ylims(2)]);end %ylims(1)
    if exist('limx','var')==1; set(AX(1),'xlim',limx);end
    drawnow
    % add eruption/swarm
    loc=pwd;cd ~/PostDoc_Utah/Datas/eruptions;Farrell_2007(AX(1),limx,get(AX(1),'ylim'));cd(loc)
    
    if exist('width','var')==1;set(h,'linewidth',width);end
    if exist('ylab','var')==1;ylabel(['{\bf ' ylab '}']);end
    if exist('ylims','var')==1 & strcmp(get(AX(1),'YScale'),'log') ==1
        set(AX(1),'ytick',logspace(log10(0.001),log10(ylims(2)),min([ylims(2) 10])));
    elseif exist('ylims','var')==1 & strcmp(get(AX(1),'YScale'),'linear') ==1
        set(AX(1),'ytick',plot_tick(ylims));
    end
    plot_gooddatetick(a)

    axes(AX(2));h=[h ;H2];hold on
    if exist('YY2','var')==1;if numel(YY2)==numel(XX2);    hold on;tmp=plot(XX2,YY2,styyl{2},'parent',AX(2));h=[h; tmp];ind=1;hold off;end;end
    if exist('YY3','var')==1;if numel(YY3)==numel(XX3);    hold on;tmp=plot(XX3,YY3,styyl{3},'parent',AX(2));h=[h; tmp];ind=2;hold off;end;end
    axis tight
    if exist('wiidth','var')==1;set(h(end-ind:end),'linewidth',wiidth);end
    if exist('yylab','var')==1;ylabel(['{\bf ' yylab '}']);else ylabel(['{\bf Primitives [' char(styyl{1}(1:end-1)) ']}']);end
    if exist('yylims','var')==1;set(AX(2),'ytick',plot_tick(yylims));end
    set(AX(2),'xtick',[],'xticklabel','')

    if exist('forlegend','var')==1;legend(h,forlegend,'location','northwest');end

    linkaxes(AX,'x')
    if exist('limx','var')==1; set(AX(1),'xlim',limx);end
    if exist('yylims','var')==1;set(AX(2),'ylim',[0 yylims(2)]);end %yylims(1)
    if exist('ylims','var')==1;set(AX(1),'ylim',[0 ylims(2)]);end %ylims(1)


end




%plot 2:
if exist('Ylat','var')~=0;
    if numel(Ylat)==numel(Y1(1,:));
        b = subplot(1,10,10,'parent',hpp(end));    h=barh(Y1(1,:),Ylat,'stack');
        set(gca,'yticklabel','','yaxislocation','right');grid on;
        xlabel('Number of eq.')
        if length(h) > 1 ; legend(h,'clustered','1D located','1D relocated','3D located','3D relocated') ;end
        
        % link les plots 1 et 2
        b=[b;a(end)];
        linkaxes(b,'y')
        axis tight

    end
end
 

end
