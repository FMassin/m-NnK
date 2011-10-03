function plot_CCC_1(in)

load ../tmp/plot_NNK.mat ;
amem=a;
        
if in == 4
    
    load([pathname Clustered]);
    inds=1:length(links);
    lesrecord=num2str(inds');
    if exist([pathname record],'file') ==2 
        lesrecord = num2str(importdata([pathname record]));
    else
        disp([pathname record ' do not exist'])
    end
    
    cla(amem,'reset');axes(amem);hold on;disp('plot...');axis equal
    for i=inds ;
        links{i}(i)=0;
        clustinds = find(links{i}>0);
        if ~isempty(clustinds)
            plot(clustinds,repmat(i,1,length(clustinds)),'sb');plot(i,i,'.r');drawnow            
        end
    end
    axis([1 size(one,1) 1 size(one,1)])
    set(amem,'Xticklabel',lesrecord(get(amem,'Xtick'),:))
    set(amem,'Yticklabel',lesrecord(get(amem,'Ytick'),:),'Layer','top')
    set(gcf,'Colormap',mycmap)
    colorbar;box on
    title(['Clustered on 2 stations'])
    
    
elseif in == 1 | in == 2 
    pha = get(fieldedit(1),'Value') ;
    sta = get(fieldedit(2),'Value') ;
    comp = get(fieldedit(3),'Value') ;

    load([pathname CCCs]);
    load('../tmp/MyColormapsCCC','mycmap')

    one=cell2mat(tmp(:,sta,comp,pha));
    
    lesstat='';lescompo = '';lesrecord='';
    if exist([pathname stat],'file') ==2 & exist([pathname compo],'file') ==2 & exist([pathname record],'file') ==2 
        lesstat = char(importdata([pathname stat]));
        lescompo = char(importdata([pathname compo]));
        lesrecord = num2str(importdata([pathname record]));
    else
        disp([pathname stat ' or ' compo ' or ' record ' do not exist'])
    end
    lespha = ['P   ' ; 'S   ' ; 'Coda'];

    disp('find...')
    [l,c,v]=find(one>=0.85);



    cla(a,'reset');axes(a); hold on
    disp('plot...')
    if in == 1
        imagesc(one)
    elseif in == 2
        for i=1:length(l)
            plot(c(i),l(i),'s','Color',mycmap(fix(one(c(i),l(i))*size(mycmap,1)),:));
        end
    end
    axis equal
    axis([1 size(one,1) 1 size(one,1)])

    set(gca,'Xticklabel',lesrecord(get(gca,'Xtick'),:))
    set(gca,'Yticklabel',lesrecord(get(gca,'Ytick'),:),'Layer','top')
    set(gcf,'Colormap',mycmap)
    colorbar;box on
    title([lesstat(sta,:) ' ' lescompo(comp,:) ' ' lespha(pha,:)])
    
    set(h(1),'Enable','on')
    
    save ../tmp/plot_NNK.mat sta comp pha -append

elseif in ==3
    coord=ginput(1);
    coord(1:2)=round(coord(1:2));
    load([pathname WFS]); %Strwfs
    lesrecord = num2str(importdata([pathname record]));
    
    cla(a,'reset');axes(a); hold on
    plot(Strwfs{coord(1),sta,comp,pha},'-b','LineWidth',3) ;
    plot(Strwfs{coord(2),sta,comp,pha},'--r','LineWidth',3) ;

    box on
    set(a,'Xticklabel',num2str(get(a,'Xtick')'/100))
    xlabel('Time [s]')
    legend(lesrecord(coord(1),:),lesrecord(coord(2),:))
    title(['CCC = ' num2str(coord(3))])

end