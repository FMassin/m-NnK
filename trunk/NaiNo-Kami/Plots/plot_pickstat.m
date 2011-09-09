function [ax] = plot_pickstat(in)

path = '/home/fred/Documents/scripts/NaiNoKami';
path = '/Users/fredmassin/PostDoc_Utah/Processes';

switch in
    case {'4','all'}
        figure
        %system('sh pickhist.sh')
        num(:,1) =load('num-1.p');
        num(:,2) =load('num-2.p');
        num(:,3) =load('num-3.p');
        num(:,4) =load('num-1.s');
        num(:,5) =load('num-2.s');
        num(:,6) =load('num-3.s');
        
        OC1p = load('O-C-1.p');
        OC2p = load('O-C-2.p');
        OC3p = load('O-C-3.p');
        OC1s = load('O-C-1.s');
        OC2s = load('O-C-2.s');
        OC3s = load('O-C-3.s');
        
        ab(1)=subplot(3,3,1) ; hist(num(:,[1 4]),1:max(max(num)));grid; box on  ; xlabel('N_{pick per eq.}') ; ylabel('Cum. N_{eq.}'); 
        legend(['UUSS P-waves [' num2str(sum(num(:,1))) ']'],['UUSS S-waves [' num2str(sum(num(:,4))) ']'])
        
        ab(2)=subplot(3,3,4) ; hist(num(:,[2 5]),1:max(max(num)));grid; box on  ; xlabel('N_{pick per eq.}') ; ylabel('Cum. N_{eq.}'); 
        legend(['Xcorr P-waves [' num2str(sum(num(:,2))) ']'],['Xcorr S-waves [' num2str(sum(num(:,5))) ']'])
        
        ab(3)=subplot(3,3,7) ; hist(num(:,[3 6]),1:max(max(num)));grid; box on  ; xlabel('N_{pick per eq.}') ; ylabel('Cum. N_{eq.}'); 
        legend(['NNK P-waves [' num2str(sum(num(:,3))) ']'],['NNK S-waves [' num2str(sum(num(:,6))) ']'])
        
        linkaxes(ab,'x');xlim([0 max(max(num))])
        
        ax(1)=subplot(3,3,2) ; hist(OC1p,-5:0.01:5);xlim([-1 1]);grid; box on ; xlabel('t_{P}^{Obs-Calc} [s]') ; ylabel('Cum. N_{t}^{UUSS}')
        ax(2)=subplot(3,3,3) ; hist(OC1s,-5:0.01:5);xlim([-1 1]);grid; box on ; xlabel('t_{S}^{Obs-Calc} [s]') ; ylabel('Cum. N_{t}^{UUSS}')
        
        ax(3)=subplot(3,3,5) ; hist(OC2p,-5:0.01:5);xlim([-1 1]);grid; box on ; xlabel('t_{P}^{Obs-Calc} [s]') ; ylabel('Cum. N_{t}^{Xcorr}')
        ax(4)=subplot(3,3,6) ; hist(OC2s,-5:0.01:5);xlim([-1 1]);grid; box on ; xlabel('t_{S}^{Obs-Calc} [s]') ; ylabel('Cum. N_{t}^{Xcorr}')
        
        ax(5)=subplot(3,3,8) ; hist(OC3p,-5:0.01:5);xlim([-1 1]);grid; box on ; xlabel('t_{P}^{Obs-Calc} [s]') ; ylabel('Cum. N_{t}^{NNK}')
        ax(6)=subplot(3,3,9) ; hist(OC3s,-5:0.01:5);xlim([-1 1]);grid; box on ; xlabel('t_{S}^{Obs-Calc} [s]') ; ylabel('Cum. N_{t}^{NNK}')
        linkaxes(ax,'x');xlim([-1.5 1.5])
        
        
    case {'1','all'}
        figure
        for i = 1:2
            ax(i) = subplot(2,1,i) ; hold on
            one = importdata([path '/NaiNoKami_2/Utils/backedup_tmp' num2str(i) '.txt']) ;

            picks = one.data ;
            stat = one.textdata ;
            [poubelle,I] = sort(picks(:,1)) ;
            picks = picks(I,:);
            statP = stat(I,:) ;

            bar(picks,'stack') ;
            set(gca,'XTick',1:1:size(statP,1)) ;
            set(gca,'XTickLabel',statP) ;
            legend('P','S','Coda') ;
            if i == 1 ; title 'UUSS names' ; end
            if i == 2 ; title 'NNK names' ; end
            axis tight
        end

    case {'2','all'}
        figure ; ax(3) = gca ; hold on
        one = importdata([path '/NaiNoKami_2/Utils/backedup_tmp1.txt']) ;
        picks = one.data ;
        P = picks(:,1) ;
        S = picks(:,2) ;
        C = picks(:,3) ;
        stat = one.textdata ;
        two = importdata([path '/NaiNoKami_2/Utils/STAT.txt']) ;
        stat2 = two.textdata ;
        XYZ = two.data ;
        count = 0 ;
        for i=1:size(stat,1)
            disp([stat(i,:) ]) ; %' ' stat2(ii,:)]) ;
            for ii=1:size(stat2,1)
                if strcmp(stat(i,:),stat2(ii,:)) ==1
                    disp(['------------> ' stat(i,:) ' ' stat2(ii,:)]) ;
                    count = count+1 ;
                    X(count) = XYZ(ii,2) ;
                    Y(count) = XYZ(ii,1) ;
                    Z(count) = P(i) ;
                    st(count) = stat(i,:) ;
                end
            end
        end
        decim = 50 ;
        xlin=linspace(min(X),max(X),decim);
        ylin=linspace(min(Y),max(Y),decim);
        [Xc,Yc]=meshgrid(xlin,ylin);
        map=griddata(X,Y,Z,Xc,Yc,'v4'); % Interpolation v4 de matlab
        map = real(map) ;
        [plotedmap] = pcolor(Xc,Yc,map);
        plot(X,Y,'ow')
        %text(X,Y,st,'Color','w')
        axis tight

    case {'3','all'}

        two = importdata([path '/NaiNoKami_2/Utils/STAT.txt']) ;
        test = two.textdata;
        test1 = two.data;count = 0;
        for i=1:size(test,1)
            if test1(i,1) >= 44
                count = count +1 ;
                sta(count,:) = test(i,:) ;
                utm(count,:) = test1(i,:) ;
            end
        end
        n = 20 ;
        x = min(utm(:,2)) :(max(utm(:,2))-min(utm(:,2)))/n: max(utm(:,2));
        y = min(utm(:,1)) :(max(utm(:,1))-min(utm(:,1)))/n: max(utm(:,1));
        stdazi = zeros(length(y),length(x)) ;
        stdinc = zeros(length(y),length(x)) ;
        medazi = zeros(length(y),length(x)) ;
        medinc = zeros(length(y),length(x)) ;
        lesX(2,:) = utm(:,2)' ;
        lesY(2,:) = utm(:,1)' ;
        lesZ(2,:) = utm(:,3)' ;
        deg2m = 110000 ;
        for j = 1 : length(x)
            for i = 1 : length(y)
                lesX(1,1:end) = x(j) ;
                lesY(1,1:end) = y(i) ;
                lesZ(1,1:end) = -10000 ;
                [azi,inc,R] = cart2sph(diff(lesX,1),diff(lesY,1),diff(lesZ,1)/deg2m) ;
                azi = 90-rad2deg(azi) ;
                for k = 1 : length(azi)
                    if azi(k) < 0 ; azi(k) = azi(k)+360 ; end
                    if azi(k) > 360 ; azi(k) = azi(k)-360 ; end
                end
                inc = 90-rad2deg(inc) ;
                
                stdazi(i,j) = 2* (tinv(0.975,length(azi)-1) * std(azi)/sqrt(length(azi))) ; 
                %stdazi(i,j) = std(azi) ;
                medazi(i,j) = median(azi) ;
                
                stdinc(i,j) = 2* (tinv(0.975,length(inc)-1) * std(inc)/sqrt(length(inc))) ; 
                %stdinc(i,j) = std(inc) ;
                medinc(i,j) = median(inc) ;
            end
        end

        stdouv = 2*sqrt(stdinc.*stdazi) ;
        clim1 = [min(min(stdazi)) max(max(stdazi))] ;
        clim2 = [min(min(stdinc)) max(max(stdinc))] ;
        clim3 = [min(min(stdouv)) max(max(stdouv))] ;

        figure ;
        ax(4) = subplot(1,3,1) ; hold on ; axis equal        
        graph1=imagesc(x,y,stdazi,'Parent',ax(4)) ;
        axes(ax(4)) ; caxis(clim1)
%         [C,h] = contour(Xmnt(indx1:indx2),Ymnt(indy1:indy2),(Zmnt(indy1:indy2,indx1:indx2)),20:equidist:3500,'Color',[0.5 0.5 0.5],'Parent',ax(1));
%         contour(Xmnt(indx1:indx2),Ymnt(indy1:indy2),(Zmnt(indy1:indy2,indx1:indx2)),[20 500:500:3500],'Color',[0.1 0.1 0.1],'Parent',ax(1));
        plot(utm(:,2),utm(:,1),'^w','MarkerFaceColor','w','Parent',ax(4)) ;
        title('Deviation standard azimuth couvert')
        colorbar
        
        ax(5) = subplot(1,3,2) ; hold on ; axis equal
        graph2=imagesc(x,y,stdinc,'Parent',ax(5)) ;
        axes(ax(5)) ; caxis(clim2)
        %         [C,h] = contour(Xmnt(indx1:indx2),Ymnt(indy1:indy2),(Zmnt(indy1:indy2,indx1:indx2)),20:equidist:3500,'Color',[0.5 0.5 0.5],'Parent',ax(1));
        %         contour(Xmnt(indx1:indx2),Ymnt(indy1:indy2),(Zmnt(indy1:indy2,indx1:indx2)),[20 500:500:3500],'Color',[0.1 0.1 0.1],'Parent',ax(1));
        plot(utm(:,2),utm(:,1),'^w','MarkerFaceColor','w','Parent',ax(5)) ;
        title('Deviation standard inclinaison couvert')
        colorbar

        ax(6) = subplot(1,3,3) ; hold on ; axis equal
        graph3=imagesc(x,y,stdouv,'Parent',ax(6)) ;
        axes(ax(6)) ; caxis(clim3)
        %         [C,h] = contour(Xmnt(indx1:indx2),Ymnt(indy1:indy2),(Zmnt(indy1:indy2,indx1:indx2)),20:equidist:3500,'Color',[0.5 0.5 0.5],'Parent',ax(1));
        %         contour(Xmnt(indx1:indx2),Ymnt(indy1:indy2),(Zmnt(indy1:indy2,indx1:indx2)),[20 500:500:3500],'Color',[0.1 0.1 0.1],'Parent',ax(1));
        plot(utm(:,2),utm(:,1),'^w','MarkerFaceColor','w','Parent',ax(6)) ;
        title('Deviation standard secteur couvert')
        colorbar

        linkaxes(ax(4:6),'xy') ; axis image

end