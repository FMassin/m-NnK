function plot_dtb

if exist('plot_NNK.mat','file')== 2
    load plot_NNK.mat ;
end

if exist('pathname','var')==1;if ischar(pathname) == 1
        
        % affiche infos %%%%%%%%%%%%%%%%
        disp('Plot database ') ;
        disp('Module plot_dtb.m  ...')

        resizeeffect(fh,bar1)
        clf(fh,'reset');[th,hp,pth]=plot_NNKtools(fh,backcolor,bar1);
        a(2) = subplot(1,10,[1:8],'parent',hp(2),'Layer','top'); box on; hold on
        a(1) = subplot(1,10,[9:10],'parent',hp(2),'Layer','top');box on; 
        resizeeffect(fh,bar2)
        
        lesnumber = importdata([pathname 'hist_stat_NNK.txt']) ; 
        station = lesnumber.textdata;
        cumulatepick = lesnumber.data;
        clear lesnumber
        [val,ind]=sort(cumulatepick(:,1));
        station=station(ind);
        cumulatepick=cumulatepick(ind,:);
        pick = cell(size(station,1),1);
        
        axes(a(1))
        barh(cumulatepick(1:size(station,1),1))
        linkaxes(a,'y')
        for i=size(station,1)-5:size(station,1) %1:size(station,1)
            file = [pathname 'pick.' char(station(i)) '.P.txt'];
            if exist(file,'file') == 2
                loaded = textread(file,'%s');
                loaded = datenum(loaded,'yymmddHHMMSS')';
                
                x=repmat([i-0.5 i+0.5]',1,size(loaded,2));
                pick{i,2} = [loaded ; loaded ] ;
                pick{i,1} = x ;
                
                plot(pick{i,2},pick{i,1},'b','Parent',a(2)); drawnow
            end
        end
        clear loaded
        

        xlims = [1980:2010]' ;
        ylims = [1:size(station,1)] ; 
        
        xtickslabel = num2str(xlims);
        xticks = datenum(xtickslabel,'yyyy');
        
        set(a(2),'Ytick',ylims,'Yticklabel',station,'Ylabel','Station name')
        set(a(2),'Xtick',xticks,'Xticklabel',xtickslabel,'Xlabel','P phase arrival time [year]')
        
        set(a(1),'Xlabel','Cumulate number of P phase arrival time')
        
        save plot_NNK.mat hp a -append
    else disp('Please choose path before that') ;        
    end
else disp('Please choose path before that') ;
end