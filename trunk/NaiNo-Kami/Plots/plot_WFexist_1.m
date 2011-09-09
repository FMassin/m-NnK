function plot_WFexist_1(in)

load plot_NNK.mat ;
lesrecord = char(importdata([pathname record]));
lesstat = char(importdata([pathname stat]));
lescompo = char(importdata([pathname compo])) ;
%lespha = ['P   ' ; '    ' ;'    ' ; 'S   ' ;'    ' ; 'Coda'];
lespha = ['P   ' ; '    '; '    '; 'S   ' ; 'Coda'];

time=1;

n=size(lescompo,1)*size(lespha,1);
load([pathname WFS]); %Strwfs
if size(Strwfs,4)>3
    phases=[1 4 5];
else
    phases=[1];% 4 5];
end

if in==1
    cnt=0;
    for ii=1:size(Strwfs,2)
        for iii=1:size(Strwfs,3)
            for iiii=phases
                cnt = cnt+1;
                line(ii,iii,iiii)= cnt;
                labels(cnt,1:10)= [lesstat(ii,:) ' ' lescompo(iii,:) ' ' lespha(iiii,:)];
            end
        end
    end
    cnt = cnt+1;
    labels(cnt,1:10)= [ '*   * P   '];
    
    mymat=zeros(cnt,size(Strwfs,1));
    for i=1:size(Strwfs,1)
        for ii=1:size(Strwfs,2)
            for iii=1:size(Strwfs,3)
                for iiii=phases
                    test = sum(abs(Strwfs{i,ii,iii,iiii}));
                    
                    if test > 0
                        
                        mymat(line(ii,iii,iiii),i) = 1 ; 
                    else
                        mymat(line(ii,iii,iiii),i) = 0 ;
                    end
                end
            end
        end
        mymat(cnt,i) = 2*logical(sum(mymat(1:n:cnt-1,i))) ;
    end
    
    cla(a,'reset');axes(a); hold on
    imagesc(mymat) ; colorbar ; axis tight ;box on
    set(a,'Xticklabel',lesrecord(get(a,'Xtick'),:))
    set(a,'Ytick',1:cnt,'Yticklabel',labels,'Layer','top')
   
    set(h(1),'Enable','on')
    
    save plot_NNK.mat line -append
    
elseif in ==2
    coord=round(ginput(1));
    i=coord(1);
    
    flag = 0;
    for ii=1:size(Strwfs,2)
        for iii=1:size(Strwfs,3)
            for iiii=phases
                if line(ii,iii,iiii) == coord(2)
                flag = 1 ;break
                end
            end
            if flag == 1 ; break;end
        end
        if flag == 1 ; break;end
    end

    pas = 1/(100*60*60*24);
    maxi = Strwfs{i,ii,iii,iiii+time}+(length(Strwfs{i,ii,iii,iiii})*pas)-pas;
    time = Strwfs{i,ii,iii,iiii+time}:pas:maxi;
    
    cla(a,'reset');axes(a); hold on
    plot(time,Strwfs{i,ii,iii,iiii}) ; 
    
    box on
    set(a,'Xticklabel',datestr(get(a,'Xtick')))
    
    
end