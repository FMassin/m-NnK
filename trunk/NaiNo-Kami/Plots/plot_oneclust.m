function plot_oneclust(in)

global clust oldclust a dates1 dates2 cumnums clustratio uniqratio neoratio endratio fieldedit hpp hp indeq indices

[time,indeq,lims] = taketime ;

IND = 1;
indsolution = 1 ;
if exist('../tmp/IND.mat','file') ~=0; load ../tmp/IND.mat;end

    
if in == 1
    if IND > 1 ;
        IND = IND-1;indsolution=1;
    end
    test = [clust{order(IND)}{1,27}(1:end-3) 'sol'];
    if exist(test,'file') > 0
        [a,b]=system(['cat ' test]);
        indsolution = str2num(b);
        disp('======================>      THIS CLUSTER HAS BEEN REVIEWED !!!!!!!!!!! ')
        if indsolution>0 & indsolution<100 ; [boxs(1)]=plot_text('THIS CLUSTER HAS BEEN REVIEWED !',0);
        else  [boxs(1)]=plot_text('THIS CLUSTER HAS BEEN REVIEWED BUT IT S NOT A DC!',0);
        end
    end
    
elseif in ==2
    if IND < length(clust) ;
        IND = IND+1; indsolution=1;
    end
    test = [clust{order(IND)}{1,27}(1:end-3) 'sol'];
    if exist(test,'file') > 0
        [a,b]=system(['cat ' test]);
        indsolution = str2num(b);
        disp('======================>      THIS CLUSTER HAS BEEN REVIEWED !!!!!!!!!!! ')
        if indsolution>0 & indsolution<100 ; [boxs(1)]=plot_text('THIS CLUSTER HAS BEEN REVIEWED !',0);
        else  [boxs(1)]=plot_text('THIS CLUSTER HAS BEEN REVIEWED BUT IT S NOT A DC!',0);
        end
    end
    
elseif in ==11
    test = [clust{order(IND)}{1,27}(1:end-3) 'sol'];
    disp('======================>      RELOADING...')
    if exist(test,'file') > 0
        [a,b]=system(['cat ' test]);
        indsolution = str2num(b);
        disp('======================>      THIS CLUSTER HAS BEEN REVIEWED !!!!!!!!!!! ')
        if indsolution>0 & indsolution<100 ; [boxs(1)]=plot_text('THIS CLUSTER HAS BEEN REVIEWED !',0);
        else  [boxs(1)]=plot_text('THIS CLUSTER HAS BEEN REVIEWED BUT IT S NOT A DC!',0);
        end
    end
    
elseif in ==3
    if indsolution > 1 ;indsolution=indsolution-1;end
elseif in ==5
    if 27+indsolution < size(clust{order(IND)},2) ;indsolution=indsolution+1;end
elseif in ==4 % DC
    load ../tmp/tmpfaulplane.mat
    disp(['You set double couple solution ' num2str(indsolution) ' and fault plan ' ...
        redorgreen(3:end) ' for cluster ' num2str(order(IND)) ' (' ...
        num2str(indices(order(IND))) '): ' num2str(clust{order(IND)}{1,27+indsolution}(1:3))])
    com = ['echo "' num2str(indsolution) '" > ' clust{order(IND)}{1,27}(1:end-3) 'sol'] ;
    disp(com) ; system(com);
    disp([clust{order(IND)}{1,27}(1:end-3) 'mat saved']); 
    copyfile('../tmp/tmpfaulplane.mat',[clust{order(IND)}{1,27}(1:end-3) 'mat'])
    copyfile('../tmp/tmpnodalplane.mat',[clust{order(IND)}{1,27}(1:end-4) '-aux.mat'])
    disp('================================================================')
elseif in == -4 % DC avec autre fault plane
    load ../tmp/tmpnodalplane.mat
    disp(['You set double couple solution ' num2str(indsolution) ' and fault plan ' redorgreen(3:end) ' for cluster ' num2str(order(IND)) ' (' num2str(indices(order(IND))) '): ' num2str(clust{order(IND)}{1,27+indsolution}(1:3))])
    com = ['echo "' num2str(indsolution) '" > ' clust{order(IND)}{1,27}(1:end-3) 'sol'] ;
    disp(com) ; system(com);
    disp([clust{order(IND)}{1,27}(1:end-3) 'mat saved']); 
    copyfile('../tmp/tmpnodalplane.mat',[clust{order(IND)}{1,27}(1:end-3) 'mat'])
    copyfile('../tmp/tmpfaulplane.mat',[clust{order(IND)}{1,27}(1:end-4) '-aux.mat'])
    disp('================================================================')
elseif in ==7 %NDC
    disp(['You interpret cluster ' num2str(order(IND)) ' (' num2str(indices(order(IND))) ') as non-double couple:'])
    disp(num2str(clust{order(IND)}{1,27+indsolution}))
    com = ['echo "0" > ' clust{order(IND)}{1,27}(1:end-3) 'sol'] ;
    disp(com) ; system(com);
    disp('================================================================')
elseif in ==8 %ISO
    disp(['You interpret cluster ' num2str(order(IND)) ' (' num2str(indices(order(IND))) ') as ISOTROPIC:'])
    disp(num2str(clust{order(IND)}{1,27+indsolution}))
    com = ['echo "111" > ' clust{order(IND)}{1,27}(1:end-3) 'sol'] ;
    disp(com) ; system(com);
    disp('================================================================')
elseif in ==9 %CLVD
    disp(['You interpret cluster ' num2str(order(IND)) ' (' num2str(indices(order(IND))) ') as CLVD:'])
    disp(num2str(clust{order(IND)}{1,27+indsolution}))
    com = ['echo "100" > ' clust{order(IND)}{1,27}(1:end-3) 'sol'] ;
    disp(com) ; system(com);
    disp('================================================================')
elseif in ==6    
    %pop up fpplot output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    com=['open ' clust{order(IND)}{1,27}(1:end-3) 'ps'];disp(com);[poub1,poub2]=system(com);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif in ==10
    %pop up stacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    com = 'echo "export CLASSPATH=\"/Applications/my_java_dir/SeisGram2K/SeisGram2K60.jar\"" > sgm.sh';
    system(com);
    com=['echo "java net.alomax.seisgram2k.SeisGram2K -binarytype=SUN_UNIX ' clust{order(IND)}{1,4} '/stacks/*/*_Z_P.sac.linux.stack" >> sgm.sh'];
    system(com);
    system('sh sgm.sh')
end
save ../tmp/IND.mat IND IND0 dist order ax indsolution

if in ==0 | in ==2 | in ==1 | in ==3 | in ==5 | in ==11
    %get data to plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:length(indeq)
        if indeq(i) >=18;dim=1000;else;dim=1;end
        loc{i} = cell2mat(clust{order(IND)}(:,indeq(i))) ;
        if isnan(nanmean(loc{i}(:,1)))==1 | isnan(nanmean(loc{i}(:,2)))==1 ; disp('There s nothing for this cluster');return;end
        
        [poub,answer]=system(['./distance.pl ' num2str([nanmean(loc{i}(:,1)) nanmean(loc{i}(:,2)) nanmean(loc{i}(:,1))+1 nanmean(loc{i}(:,2))]) ]);
        kmlon=abs(str2num(answer));
        [poub,answer]=system(['./distance.pl ' num2str([nanmean(loc{i}(:,1)) nanmean(loc{i}(:,2)) nanmean(loc{i}(:,1)) 1+nanmean(loc{i}(:,2))]) ]);
        kmlat=abs(str2num(answer));
        loc{i}(:,3)=-1*loc{i}(:,3);
        loc{i}(:,4)=loc{i}(:,4)./(kmlon*dim) ;
        loc{i}(:,5)=loc{i}(:,5)./(kmlat*dim) ;
        loc{i}(:,6)=loc{i}(:,6)./(dim) ;
        
        if indeq(i)==6 | indeq(i)==8 | indeq(i)==10
            loc{i}(:,3)=loc{i}(:,3)*(-1) ;
        end
        
        t=cell2mat(clust{order(IND)}(:,3)) ;
        M=cell2mat(clust{order(IND)}(:,25)) ;
        %M(isnan(M)==1) = 0;
        Mo=10.^(1.1*M+18.4);
        Mo(isnan(Mo)==1) = 0;
        %    log(Mo)=1.1*M+18.4 ; Puskas 2007
        Mcum=(log10(sum(Mo))-18.4)/1.1;
        test = cell2mat(clust{order(IND)}(:,indeq(i)-1)) ; test = test(1,:);
        ind=[findstr(test,'loc.')+4 findstr(test,'/')] ; forlege{i} = test(ind(1):ind(end)-1) ;
    end
    S=[];D=[];R=[];flag=0;
    if indsolution > 0 & indsolution < 100
        if exist([clust{order(IND)}{1,27}(1:end-3) 'mat'],'file')==2
            disp([clust{order(IND)}{1,27}(1:end-3) 'mat ploted'])
            load([clust{order(IND)}{1,27}(1:end-3) 'mat']);
        end
        if numel(S)==0
            com=['sed -n ' num2str(indsolution) 'p   ' clust{order(IND)}{1,27}(1:end-3) 'sum'];disp(com);[poub1,test]=system(com);
            S=str2num(test(84:86));  D=str2num(test(87:89));  R=str2num(test(90:93));
        else flag=1;
        end
        disp(['RED: Strike | dip | rake = ' num2str([S D R])]) ; % red plane is the one inputed in drawball
        [strikeGreen,dipGreen,rakeGreen]=n1_2_n2(S,D,R);
        disp(['GREEN: Strike | dip | rake = ' num2str([strikeGreen dipGreen rakeGreen])])
        [diameter]= get_surfaceruturelength(Mcum,D,R);
        diameter=diameter/110;
        diameter=diameter*5;
        %warning(['Mcumul = ' num2str(Mcum) ' but diameter is *2'])
    else
        [val,mini]=min(indeq);
        diameter = max([diff(minmax(loc{mini}(:,1)'))  diff(minmax(loc{mini}(:,2)')) diff(minmax(loc{mini}(:,3)'))/110])*110/3.5;
        disp('======================>      THIS CLUSTER IS NOT A DC !!!!!!!!!!! ')
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    % update panel title %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(hpp(end),'title',['cluster -' num2str(order(IND)) '- (' num2str(dist(IND)) ' km & ' num2str(IND-IND0) ' clst from picked)'])
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ax(1) = subplot(10,3,[5:3:30],'parent',hpp(end));
    ax(2) = subplot(10,3,[6:3:30],'parent',hpp(end));
    ax(3) = subplot(10,3,[13:3:30],'parent',hpp(end));
    ax(4) = subplot(10,3,[4:3:10],'parent',hpp(end));
    
    % plot the magnitude %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla(ax(4)); axes(ax(4));M(M<-1)=NaN;
    [AX,H1,H2] = plotyy(t,cumsum(Mo),t,M,'plot','plot','b','r');%semilogy
    linkaxes(AX,'x');axes(AX(2));axis tight;axes(AX(1));axis tight
    set(get(AX(1),'Ylabel'),'String','Mo [dyn.cm]')
    set(get(AX(2),'Ylabel'),'String','M_{coda}')
    ylims = get(AX(1),'ylim');
    %set(AX(1),'ytick',logspace(log10(0.001),log10(ylims(2)),min([ylims(2) 10]))) ;
    set(AX(2),'ytick',plot_tick(get(AX(2),'ylim')));
    set(H1,'Linewidth',2);set(H2,'Linestyle','none','Marker','s')
    plot_gooddatetick(AX(1));
    plot_gooddatetick(AX(2));
    disp(['Cumulated Mo=' num2str(sum(Mo)) '. Cumulated M=' num2str(Mcum)])
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    %plot hypocenters and errors %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla(ax(1));axes(ax(1));hold on
    h(1)=plot3(loc{1}(:,1),loc{1}(:,2),loc{1}(:,3),'.b','markersize',15);
    plot3([loc{1}(:,1)-loc{1}(:,4) loc{1}(:,1)+loc{1}(:,4)]',[loc{1}(:,2) loc{1}(:,2)]',[loc{1}(:,3) loc{1}(:,3)]','-','color',[0.6 0.6 0.6]);
    plot3([loc{1}(:,1) loc{1}(:,1)]',[loc{1}(:,2)-loc{1}(:,5) loc{1}(:,2)+loc{1}(:,5)]',[loc{1}(:,3) loc{1}(:,3)]','-','color',[0.6 0.6 0.6]);
    plot3([loc{1}(:,1) loc{1}(:,1)]',[loc{1}(:,2) loc{1}(:,2)]',[loc{1}(:,3)-loc{1}(:,6) loc{1}(:,3)+loc{1}(:,6)]','-','color',[0.6 0.6 0.6]);
    if length(indeq)>1
        h(2)=plot3(loc{2}(:,1),loc{2}(:,2),loc{2}(:,3),'.r','markersize',15);
        plot3([loc{2}(:,1)-loc{2}(:,4) loc{2}(:,1)+loc{2}(:,4)]',[loc{2}(:,2) loc{2}(:,2)]',[loc{2}(:,3) loc{2}(:,3)]','-','color',[0.6 0.6 0.6]);
        plot3([loc{2}(:,1) loc{2}(:,1)]',[loc{2}(:,2)-loc{2}(:,5) loc{2}(:,2)+loc{2}(:,5)]',[loc{2}(:,3) loc{2}(:,3)]','-','color',[0.6 0.6 0.6]);
        plot3([loc{2}(:,1) loc{2}(:,1)]',[loc{2}(:,2) loc{2}(:,2)]',[loc{2}(:,3)-loc{2}(:,6) loc{2}(:,3)+loc{2}(:,6)]','-','color',[0.6 0.6 0.6]);
        plot3([loc{2}(:,1) loc{1}(:,1)]',[loc{2}(:,2) loc{1}(:,2)]',[loc{2}(:,3) loc{1}(:,3)]','-c','linewidth',0.5);
        legend(h,forlege{1},forlege{2},'location','NorthEast')
    end
    hold off
    daspect([1/kmlon 1/kmlat 1]);axis tight;grid on;box on;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %isosurf+fp+planes+slip %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla(ax(2));axes(ax(2));hold on %[trend,plunge,Strike,Dip,Rake,flag,rms,largeclust] = chooseslip(S,D,R,loc(:,1),loc(:,2),loc(:,3),[kmlon kmlat 1]);
    %diameter = min([diff(get(ax(1),'xlim')) diff(get(ax(1),'ylim')) diff(get(ax(1),'zlim'))/110] )*55;
    if sum(1-isnan(loc{1}(:,1))) > 1
        [strike,dip,~,XYZyellow] = fit3Dplane(loc{1}(:,1:3),1,ax(2),[1/kmlon 1/kmlat 1],diameter);
        [a,b,XYXred,XYXgreen]=drawball(diameter,nanmedian(loc{1}(:,1)),nanmedian(loc{1}(:,2)),nanmedian(loc{1}(:,3)),S,D,R,1,'none',ax(2),[1/kmlon 1/kmlat 1]);
        [XYZ,redorgreen,XYZinv]=get_goodplan(XYXred,XYXgreen,XYZyellow);
        if redorgreen(1)=='2' & flag==0
            delete(a);delete(b);
            [S,D,R]=n1_2_n2(S,D,R);
            [strikeGreen,dipGreen,rakeGreen]=n1_2_n2(S,D,R);
            [a,b,XYXred,XYXgreen]=drawball(diameter,nanmedian(loc{1}(:,1)),nanmedian(loc{1}(:,2)),nanmedian(loc{1}(:,3)),S,D,R,1,'none',ax(2),[1/kmlon 1/kmlat 1]);
            redorgreen='1: red  ';
            tmp=XYZ;
            XYZ = XYZinv ;
            XYZinv = tmp;
            disp(['RED: Strike | dip | rake = ' num2str([S D R])]) ; % red plane is the one inputed in drawball
            disp(['GREEN: Strike | dip | rake = ' num2str([strikeGreen dipGreen rakeGreen])])
        end
        disp(['Fault plane would be the ' upper(redorgreen(4:end)) ])
        save ../tmp/tmpfaulplane.mat XYZ S D R redorgreen ; 
        XYZ=XYZinv ; [S,D,R]=n1_2_n2(S,D,R); redorgreen=[redorgreen '*-1']; 
        save ../tmp/tmpnodalplane.mat XYZ S D R redorgreen ;
    else
        warning('where is less than 2 NaN hypocenter positions !')
    end
    hold off
    daspect([1/kmlon 1/kmlat 1]);
    set(ax(2),'xlim',get(ax(1),'xlim'),'ylim',get(ax(1),'ylim'),'zlim',get(ax(1),'zlim')); %,'xtick',get(ax(1),'xtick'),'ytick',get(ax(1),'ytick'),'ztick',get(ax(1),'ztick'));
    linkaxes(ax([2 1]),'all') % slip plot and hypo plot same dimensions
    grid on;box on;axis tight;plot_goodgeotick(ax(2));plot_goodgeotick(ax(1));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %plot general location map %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla(ax(3));axes(ax(3));hold on
    plot_Yell(ax(3),[get(ax(1),'xlim') get(ax(1),'ylim') ; lims(1,1:2) lims(2,1:2)],1) ;
    hold off
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
end




