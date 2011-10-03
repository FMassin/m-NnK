function plot_reloc_1(in)
global clust oldclust a dates1 dates2 cumnums clustratio uniqratio neoratio endratio fieldedit   hpp hp


%prend les bons clusters
[time,indeq,lims] = taketime ;
[clust,oldclust]=takeclust(oldclust);
fortitle = '';
xlab = '' ; 

%prepare les truc a ploter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if in == 1                 % pour  histogram des distances interhypocentrales
    plotingsdtyle = 1;
    Y1 =[];X1 =0:0.5:50;
    X2 =X1;Y2=[];
    X3 =X1;Y3=[];
    X4 =X1;Y4=[];
    X5 =X1;Y5=[];
    X6 =X1;Y6=[];
    for i=1:size(clust,1);
        loc1 = cell2mat(clust{i}(:,6));
        loc2 = cell2mat(clust{i}(:,8)); 
        loc3 = cell2mat(clust{i}(:,10));
        loc4 = cell2mat(clust{i}(:,18));
        loc5 = cell2mat(clust{i}(:,16));
        loc6 = cell2mat(clust{i}(:,24));
        
        Y1=[Y1 ; ...
            ((loc1(:,1)*90-nanmean(loc1(:,1)*90)).^2 + (loc1(:,2)*110-nanmean(loc1(:,2)*110)).^2).^0.5 ...
            abs(loc1(:,3)-nanmean(loc1(:,3))) ... 
            ((loc1(:,1)*90-nanmean(loc1(:,1)*90)).^2 + (loc1(:,3)-nanmean(loc1(:,3))).^2 + (loc1(:,2)*110-nanmean(loc1(:,2)*110)).^2).^0.5 ] ;
        Y2=[Y2 ; ...
            ((loc2(:,1)*90-nanmean(loc2(:,1)*90)).^2 + (loc2(:,2)*110-nanmean(loc2(:,2)*110)).^2).^0.5 ...
            abs(loc2(:,3)-nanmean(loc2(:,3))) ... 
            ((loc2(:,1)*90-nanmean(loc2(:,1)*90)).^2 + (loc2(:,3)-nanmean(loc2(:,3))).^2 + (loc2(:,2)*110-nanmean(loc2(:,2)*110)).^2).^0.5 ] ;
        Y3=[Y3 ; ...
            ((loc3(:,1)*90-nanmean(loc3(:,1)*90)).^2 + (loc3(:,2)*110-nanmean(loc3(:,2)*110)).^2).^0.5 ...
            abs(loc3(:,3)-nanmean(loc3(:,3))) ... 
            ((loc3(:,1)*90-nanmean(loc3(:,1)*90)).^2 + (loc3(:,3)-nanmean(loc3(:,3))).^2 + (loc3(:,2)*110-nanmean(loc3(:,2)*110)).^2).^0.5 ] ;
        Y4=[Y4 ; ...
            ((loc4(:,1)*90-nanmean(loc4(:,1)*90)).^2 + (loc4(:,2)*110-nanmean(loc4(:,2)*110)).^2).^0.5 ...
            abs(loc4(:,3)-nanmean(loc4(:,3))) ... 
            ((loc4(:,1)*90-nanmean(loc4(:,1)*90)).^2 + (loc4(:,3)-nanmean(loc4(:,3))).^2 + (loc4(:,2)*110-nanmean(loc4(:,2)*110)).^2).^0.5 ] ;
        Y5=[Y5 ; ...
            ((loc5(:,1)*90-nanmean(loc5(:,1)*90)).^2 + (loc5(:,2)*110-nanmean(loc5(:,2)*110)).^2).^0.5 ...
            abs(loc5(:,3)-nanmean(loc5(:,3))) ... 
            ((loc5(:,1)*90-nanmean(loc5(:,1)*90)).^2 + (loc5(:,3)-nanmean(loc5(:,3))).^2 + (loc5(:,2)*110-nanmean(loc5(:,2)*110)).^2).^0.5 ] ;
        Y6=[Y6 ; ...
            ((loc6(:,1)*90-nanmean(loc6(:,1)*90)).^2 + (loc6(:,2)*110-nanmean(loc6(:,2)*110)).^2).^0.5 ...
            abs(loc6(:,3)-nanmean(loc6(:,3))) ... 
            ((loc6(:,1)*90-nanmean(loc6(:,1)*90)).^2 + (loc6(:,3)-nanmean(loc6(:,3))).^2 + (loc6(:,2)*110-nanmean(loc6(:,2)*110)).^2).^0.5 ] ;
        
        
    end
    ylab = 'N_{eq.}';
    xlab = 'Inter-hypocentre [km]';
    forlegend = ['XY sep.   ';...
                 'Z sep.    ';...
                 'Total sep.'];
    fortitle = ['UUSS-hypo71' ; 'Xcor-hypo71' ; 'NNK-hypo71 ' ; 'NNK-hypoDD ' ; 'NNK-nlloc  ' ; 'NNK-tomoDD '];
    styl={'-g' ; '.k'};
    width=2;
    minlimx = 0 ; 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif in ==2              % histo RMS
plotingsdtyle = 1;
    Y1 =[];X1 =0:0.05:1;
    X2 =X1;Y2=[];
    X3 =X1;Y3=[];
    X4 =X1;Y4=[];
    X5 =X1;Y5=[];
    X6 =X1;Y6=[];
    for i=1:size(clust,1);
        loc1 = cell2mat(clust{i}(:,6));
        loc2 = cell2mat(clust{i}(:,8)); 
        loc3 = cell2mat(clust{i}(:,10));
        loc4 = cell2mat(clust{i}(:,18));
        loc5 = cell2mat(clust{i}(:,16));
        loc6 = cell2mat(clust{i}(:,24));
        
        Y1=[Y1 ; loc1(:,13)] ;
        Y2=[Y2 ; loc2(:,13)] ;
        Y3=[Y3 ; loc3(:,13)] ; 
        Y4=[Y4 ; loc4(:,13) loc4(:,21)] ;
        Y5=[Y5 ; loc5(:,13)] ; 
        Y6=[Y6 ; loc6(:,13) loc6(:,21)] ; 
        
        
    end
    ylab = 'N_{eq.}';
    xlab = 'RMS [s]';
    forlegend = ['Cross-corr.';'Absolute   '] ; 
    fortitle = ['UUSS-hypo71' ; 'Xcor-hypo71' ; 'NNK-hypo71 ' ; 'NNK-hypoDD ' ; 'NNK-nlloc  ' ; 'NNK-tomoDD '];
    styl={'-g' ; '.k'};
    width=2;
    minlimx = 0 ;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif in ==3              % histo data
    plotingsdtyle = 1;
    Y1 =[];X1 =0:5:35;
    X2 =X1;Y2=[];
    X3 =X1;Y3=[];
    X4 =X1;Y4=[];
    X5 =X1;Y5=[];
    X6 =X1;Y6=[];
    for i=1:size(clust,1);
        loc1 = cell2mat(clust{i}(:,6));
        loc2 = cell2mat(clust{i}(:,8));
        loc3 = cell2mat(clust{i}(:,10));
        loc4 = cell2mat(clust{i}(:,18));
        loc5 = cell2mat(clust{i}(:,16));
        loc6 = cell2mat(clust{i}(:,24));
        
        Y1=[Y1 ; loc1(:,14)] ;
        Y2=[Y2 ; loc2(:,14)] ;
        Y3=[Y3 ; loc3(:,14)] ;
        Y4=[Y4 ; loc4(:,14) loc4(:,22)] ;
        Y5=[Y5 ; loc5(:,14)] ;
        Y6=[Y6 ; loc6(:,14) loc6(:,22)] ;
        
        
    end
    ylab = 'N_{eq.}';
    xlab = 'N_{picks}';
    forlegend = ['Cross-corr.';'Absolute   '] ;
    fortitle = ['UUSS-hypo71' ; 'Xcor-hypo71' ; 'NNK-hypo71 ' ; 'NNK-hypoDD ' ; 'NNK-nlloc  ' ; 'NNK-tomoDD '];
    styl={'-g' ; '.k'};
    width=2;
    minlimx = 0 ;
    
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% elseif in ==7              % pour une courbe cumulee de cluster
%     plotingsdtyle = 1;
%     fortest = [1:size(clust,1)];
%     originclust=[];
%     limx=[999999999999 0];
%     for i=fortest;
%         limx = [min([ limx(1) min(cell2mat(clust{i}([1 end],3)))])  max([limx(2) max(cell2mat(clust{i}([1 end],3)))])];        
%         originclust = [originclust ; cell2mat(clust{i}(:,3))];
%     end
%     originclust=sort(originclust,'ascend');
%     clustnum = 1:length(originclust);    
%     aver=(limx(2)-limx(1))/100;
%     
%     inds1 = logical(logical(dates1 >= limx(1)) .* logical(dates1 <= limx(2))) ;
%     Xt = dates1(inds1) ; 
%     Yt = cumnums(inds1)-min(cumnums(inds1)) ;  
%     
%     inds2 = logical(logical(originclust >= limx(1)) .* logical(originclust <= limx(2))) ;
%     X1 = originclust(inds2) ; 
%     Y1 = clustnum(inds2) ; 
%     inds2 = logical(logical(dates2 >= limx(1)) .* logical(dates2 <= limx(2))) ;
%     X2 = dates2(inds2) ; 
%     Y2 = uniqratio(inds2)-min(uniqratio(inds2)) ; 
%     
%     [Y1,X1,Y2,X2,Yt,Xt] = myresample(limx,Y1,X1,Y2,X2,Yt,Xt);
%     ind=[1:min([length(X1) length(X2) length(Xt)])];
%     Y1=Y1(ind);X1=X1(ind);
%     Y2=Y2(ind);X2=X2(ind);
%     Yt=Yt(ind);Xt=Xt(ind);
%     average = fix(aver/mean(diff(X1)));
%     whos Yt Y1 Y2
%     average
%     ref=slidingsum(Yt',average);
%     Y1=slidingsum(Y1',average)./ref;
%     Y2=slidingsum(Y2',average)./ref;
%     
%     
%     ylab = ['Ratios n^E^Q^./n^t^o^t^a^l [' num2str(aver) ' days av.]'];
%     styl={'-g';'-r'};
%     forlegend=['Clustered';'Unique   ']
%     width=2;
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% elseif in ==5              % pour une courbe cumulee de cluster
%     plotingsdtyle = 2;
%     Y1 = [1:size(clust,1)];
%     Y2 = [1:size(clust,1)]; 
%     X1 =[];
%     X2 =[];
%     load ../tmp/plot_NNK.mat
%     for i=Y1;
%         X1 = [X1 min(cell2mat(clust{i}([1 end],3)))];
%         X2 = [X2 max(cell2mat(clust{i}([1 end],3)))];
%     end
%     [X2,inds]=sort(X2,'ascend');
%     [X1,inds]=sort(X1,'ascend');    
%     [tmpY1,tmpX1,tmpY2,tmpX2] = myresample([min([X1 X2]) max([X1 X2])],Y1 , X1, Y2 , X2 );
%     ind=[1:min([length(tmpX1) length(tmpX2)])];
%     XX1=tmpX1(ind);
%     YY1=(tmpY1(ind)-tmpY2(ind));
%     
%     ylab = 'Cumulate n^c^l^s^t^.';
%     styl={'-g' ; '-k' };
%     axy = 'plot';
%     
%     yylab = 'diff(n^c^l^s^t^.)';
%     styyl={'-b'};
%     axyy = 'plot';
%     
%     forlegend = ['Beginnings' ; ...
%                  'Endinds   ' ; ...
%                  'Difference' ];
%     width=2;
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% elseif in ==6              % pour une courbe cumulee de cluster
%     plotingsdtyle = 2;
%     YY1 = [1:size(clust,1)];
%     YY2 = [1:size(clust,1)]; 
%     XX1 =[];
%     XX2 =[];
%     load ../tmp/plot_NNK.mat
%     for i=YY1;
%         XX1 = [XX1  min(cell2mat(clust{i}([1 end],3)))];
%         XX2 = [XX2  max(cell2mat(clust{i}([1 end],3)))];
%     end
%     [XX2,inds]=sort(XX2,'ascend');
%     [XX1,inds]=sort(XX1,'ascend');
% 
%     wiidth=1;
%     styyl={'--g';'--k'};
%     yylab = 'Cumulate n^c^l^s^t^.';
%     yylims=[min([min(YY1) min(YY2)]) max([max(YY1) max(YY2)])];
%     forlegend = ['d(beginnings)/dt' ; ...
%                  'd(Endinds)/dt   ' ; ...
%                  'Beginnings      ' ; ...
%                  'Endinds         '];
%     
%     inds = find(diff(XX1)>0);
%     X1=XX1(inds+1); 
%     Y1=diff(YY1(inds))./((24*60)*diff(X1)) ;
%     X1=X1(2:end);
%     
%     inds = find(diff(XX2)>0);
%     X2=XX2(inds+1); 
%     Y2=diff(YY2(inds))./((24*60)*diff(X2)) ;
%     X2=X2(2:end);
%     
%     ylab = 'd(cumulate n^c^l^s^t^.) [clst.min^-^1]';
%     styl={'-g';'-k'};
%     width=2;
%     ylims=[0 max([max(Y1) max(Y2)])];
%     limx =[min([XX1  XX2  X1  X2]) max([XX1  XX2  X1 X2]) ] ;    
%     [Y1 , X1, Y2 , X2 ] = myresample(limx,Y1 , X1, Y2 , X2 );
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% elseif in ==3              % pour une courbe sismicite cumulee
%     plotingsdtyle = 1;
%     fortest = [1:size(clust,1)];
%     originclust=[];
%     limx=[999999999999 0];
%     for i=fortest;
%         limx = [min([ limx(1) min(cell2mat(clust{i}([1 end],3)))])  max([limx(2) max(cell2mat(clust{i}([1 end],3)))])];        
%         originclust = [originclust ; cell2mat(clust{i}(:,3))];
%     end
%     originclust=sort(originclust,'ascend');
%     clustnum = 1:length(originclust);    
%     inds1 = logical(logical(dates1 >= limx(1)) .* logical(dates1 <= limx(2))) ;
%     X1 = dates1(inds1) ; 
%     Y1 = cumnums(inds1)-min(cumnums(inds1)) ;     
%     inds2 = logical(logical(originclust >= limx(1)) .* logical(originclust <= limx(2))) ;
%     X2 = originclust(inds2) ; 
%     Y2 = clustnum(inds2) ; 
%     inds2 = logical(logical(dates2 >= limx(1)) .* logical(dates2 <= limx(2))) ;
%     X3 = dates2(inds2) ; 
%     Y3 = uniqratio(inds2)-min(uniqratio(inds2)) ; 
%     
%     ylab = 'Cumulate n^E^Q^.';
%     styl={'-b';'-g';'-r'};
%     forlegend=['Total    ';'Clustered';'Unique   ']
%     width=2;
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% elseif in ==4              % pour une derivee de courbe sismicite cumulee
%     plotingsdtyle = 2;
%     fortest = [1:size(clust,1)];
%     originclust=[];
%     limx=[999999999999 0];
%     for i=fortest;
%         limx = [min([ limx(1) min(cell2mat(clust{i}([1 end],3)))])  max([limx(2) max(cell2mat(clust{i}([1 end],3)))])];        
%         originclust = [originclust ; cell2mat(clust{i}(:,3))];
%     end
%     originclust=sort(originclust,'ascend');
%     clustnum = 1:length(originclust);    
%     inds1 = logical(logical(dates1 >= limx(1)) .* logical(dates1 <= limx(2))) ;
%     XX1 = dates1(inds1)' ; 
%     YY1 = cumnums(inds1)-min(cumnums(inds1)) ;     
%     inds2 = logical(logical(originclust >= limx(1)) .* logical(originclust <= limx(2))) ;
%     XX2 = originclust(inds2)' ; 
%     YY2 = clustnum(inds2) ; 
%     inds2 = logical(logical(dates2 >= limx(1)) .* logical(dates2 <= limx(2))) ;
%     XX3 = dates2(inds2)' ; 
%     YY3 = uniqratio(inds2)-min(uniqratio(inds2)) ; 
%     
%     yylims=[min([min(YY1) min(YY2) min(YY3)]) max([max(YY1) max(YY2) max(YY3)])];
%     styyl={'--b';'--g';'--r'} ; 
%     yylab = 'Cumulate n^E^Q^.';
%     wiidth = 1;
%     forlegend=['d(Total)/dt    ';'d(Clustered)/dt';'d(Unique)/dt   ';...
%                'Total          ';'Clustered      ';'Unique         '];
%     
%            
%     inds = find(diff(XX1)>0);
%     X1=XX1(inds+1); 
%     Y1=diff(YY1(inds))./((24*60)*diff(X1)) ;
%     X1=X1(2:end);
%     
%     inds = find(diff(XX2)>0);
%     X2=XX2(inds+1); 
%     Y2=diff(YY2(inds))./((24*60)*diff(X2)) ;
%     X2=X2(2:end);
%     
%     inds = find(diff(XX3)>0);
%     X3=XX3(inds+1); 
%     Y3=diff(YY3(inds))./((24*60)*diff(X3)) ;
%     X3=X3(2:end);
%     
%     ylab = 'd(cumulate n^E^Q^.) [eq.min^-^1]';
%     styl={'-b';'-g';'-r'};
%     width=2;
%     ylims=[0 max([max(Y1) max(Y2) max(Y3)])];
%     limx =[min([XX1  XX2  X1  X2]) max([XX1  XX2  X1 X2]) ] ;
%     
%     [Y1 , X1, Y2 , X2 ,Y3 , X3 ] = myresample(limx,Y1 , X1, Y2 , X2 ,Y3 , X3 );
    
end








%fait la place :
if plotingsdtyle ==1 
    [hpp] = resizepanels(hp,hpp,1);
    h=[];    
    %plot 1:
    if exist('Y2','var')==1;
        a(length(a)+1) = subplot(1,6,2,'parent',hpp(end));
        N2=hist(Y2,X2);h2=bar(X2,N2);
        xlabel(xlab)
        %if exist('forlegend','var')==1  ;if size(forlegend,1)==length(h2);legend(h2,forlegend,'location','northeast');end;end
        if size(fortitle)>=2  ;  title(fortitle(2,:));end
        grid on
    end
    
    if exist('Y3','var')==1;
        a(length(a)+1) = subplot(1,6,3,'parent',hpp(end));
        N3=hist(Y3,X3);h3=bar(X3,N3);
        xlabel(xlab)
        %if exist('forlegend','var')==1  ;if size(forlegend,1)==length(h3);legend(h3,forlegend,'location','northeast');end;end
        if size(fortitle)>=3; title(fortitle(3,:));end
        grid on
    end
    
    if exist('Y4','var')==1;
        a(length(a)+1) = subplot(1,6,4,'parent',hpp(end));
        N4=hist(Y4,X4);h4=bar(X4,N4);
        xlabel(xlab)
        if exist('forlegend','var')==1  ;if size(forlegend,1)==length(h4); legend(h4,forlegend,'location','northeast');end ;end
        if size(fortitle)>=4; title(fortitle(4,:));end
        grid on
    end
    
    if exist('Y5','var')==1;
        a(length(a)+1) = subplot(1,6,5,'parent',hpp(end));
        N5=hist(Y5,X5);h5=bar(X5,N5);
        xlabel(xlab)
        %if exist('forlegend','var')==1  ;if size(forlegend,1)==length(h6); legend(h5,forlegend,'location','northeast');end ;end
        if size(fortitle)>=5; title(fortitle(5,:));end
        grid on
    end
    
    if exist('Y6','var')==1;
        a(length(a)+1) = subplot(1,6,6,'parent',hpp(end));
        N6=hist(Y6,X6);h6=bar(X6,N6);
        xlabel(xlab)
        if exist('forlegend','var')==1  ;if size(forlegend,1)==length(h6); legend(h6,forlegend,'location','northeast');end ;end
        if size(fortitle)>=6; title(fortitle(6,:));end
        grid on
    end
    
    a(length(a)+1) = subplot(1,6,1,'parent',hpp(end));
    N1=hist(Y1,X1);h1=bar(X1,N1);
    xlabel(xlab)
    grid on
    if size(fortitle)>=1  ; title(fortitle(1,:));end
    %if exist('forlegend','var')==1  ;if size(forlegend,1)==length(h1);legend(h1,forlegend,'location','northeast');end;end
    if exist('width','var')==1      ;set(h,'linewidth',width);end
    if exist('ylab','var')==1       ;ylabel(ylab);
        if strcmp(ylab(1:4),'Deri')==1;
                                    ylim([0 1]);
    end;end
    if exist('yylab','var')==1 & exist('AX','var')==1
                                    axes(AX(2));ylabel(yylab);
       if strcmp(yylab(1:4),'Deri')==1;    
                                    ylim([0 1]);linkaxes(AX,'x');
    end;end



    linkaxes(a(end-5:end),'xy')
    mini=min([size(Y1,1) size(Y2,1) size(Y3,1) size(Y4,1)]);
    test = [Y1(1:mini,:) Y2(1:mini,:) Y3(1:mini,:) Y4(1:mini,:)] ;
    mini=min([size(N1,1) size(N2,1) size(N3,1) size(N4,1)]); 
    test2 = [N1(1:mini,:) N2(1:mini,:) N3(1:mini,:) N4(1:mini,:)] ; 
    step = mean(diff(X1)) ;
    axis([nanmean(nanmedian(test))-nanmean(nanstd(test))-step min([nanmean(nanmedian(test))+nanmean(nanstd(test))+step max(X1)+step]) 0 nanmax(nanmax(test2))])
    if exist('minlimx','var')==1; axis([minlimx(1)-step min([nanmean(nanmedian(test))+nanmean(nanstd(test))+step max(X1)+step]) 0 nanmax(nanmax(test2)) ])
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
    set(H1,'color',char(styl{1}(end)),'linestyle',char(styl{1}(1:end-1)));
    set(H2,'color',char(styyl{1}(end)),'linestyle',char(styyl{1}(1:end-1)));
    axes(AX(1));
    if exist('Y2','var')==1;if numel(Y2)==numel(X2);    hold on;tmp=plot(X2,Y2,styl{2},'parent',AX(1));h=[h; tmp];hold off;end;end
    if exist('Y3','var')==1;if numel(Y3)==numel(X3);    hold on;tmp=plot(X3,Y3,styl{3},'parent',AX(1));h=[h; tmp];hold off;end;end
    axis tight
    if exist('width','var')==1;set(h,'linewidth',width);end
    if exist('ylab','var')==1;ylabel(ylab);end
    if exist('ylims','var')==1 & strcmp(get(AX(1),'YScale'),'log') ==1;set(AX(1),'ytick',logspace(log10(0.001),log10(ylims(2)),min([ylims(2) 10])));end
    plot_gooddatetick(a)

    axes(AX(2));h=[h ;H2];hold on
    if exist('YY2','var')==1;if numel(YY2)==numel(XX2);    hold on;tmp=plot(XX2,YY2,styyl{2},'parent',AX(2));h=[h; tmp];ind=1;hold off;end;end
    if exist('YY3','var')==1;if numel(YY3)==numel(XX3);    hold on;tmp=plot(XX3,YY3,styyl{3},'parent',AX(2));h=[h; tmp];ind=2;hold off;end;end
    axis tight
    if exist('wiidth','var')==1;set(h(end-ind:end),'linewidth',wiidth);end
    if exist('yylab','var')==1;ylabel(yylab);else ylabel(['Primitives [' char(styyl{1}(1:end-1)) ']']);end
    if exist('yylims','var')==1;set(AX(2),'ytick',linspace(yylims(1),yylims(2),5));end
    set(AX(2),'xticklabel','')

    if exist('forlegend','var')==1;legend(h,forlegend,'location','east');end

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
