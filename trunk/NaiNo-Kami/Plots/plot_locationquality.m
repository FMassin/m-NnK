function  [ax]=plot_locationquality(algo,source,tmpdir)


if exist('tmpdir','var')==0; tmpdir = '/Users/fredmassin/PostDoc_Utah/Results/NNK/1981-2010/tmp';end
if exist('algo','var')==0;   algo   = {'hypo71' 'NLLoc'};end
if exist('source','var')==0; source = {'UUSS' 'Xcorr' 'NNK'};end
wave = {'P' 'S'};

for ALG=1:numel(algo)
    scrsz = get(0,'ScreenSize');
    figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)],'name',algo{ALG})
    
    for SRC=1:numel(source)
        for W=1:numel(wave)
N{SRC,W}=load([tmpdir '/N-' wave{W} '-' source{SRC} '-' algo{ALG} '.txt']);   lab{SRC,W}=[ wave{W} '-waves [' num2str(sum(N{SRC,W})) ']'] ;
        end
ax(1,SRC)=subplot(numel(source),3,(SRC-1)*numel(source)+1);hold on;[n,x]=hist([N{SRC,1} N{SRC,2}],[0:1:30]);bar(x,n./1000);hold off;xlim([0 30]);ylabel('{\bf N_{eq.} [.10^{3}]}');box on;grid on;   
        if SRC~=numel(source); set(gca,'xticklabel',[]) ;else xlabel('{\bf N_{ph.}}');end
        
        for W=1:numel(wave)
N{SRC,W}=load([tmpdir '/res-' wave{W} '-' source{SRC} '-' algo{ALG} '.txt']);  
        end
        N{SRC,2}(numel(N{SRC,2})+1:numel(N{SRC,1}))=NaN;
ax(2,SRC)=subplot(numel(source),3,(SRC-1)*numel(source)+2);hold on;[n,x]=hist([N{SRC,1} N{SRC,2}],[-1.5:0.05:1.5]);bar(x,n./1000);hold off;xlim([-1.5 1.5]);ylabel('{\bf N_{O-C} [.10^{3}]}');box on;grid on;
        if SRC~=numel(source); set(gca,'xticklabel',[]) ;else xlabel('{\bf t_{O-C} [s]}');end
            
        N{SRC}=load([tmpdir '/XYZ-' source{SRC} '-' algo{ALG} '.txt']);tmp=N;j=0;tmp{SRC}(:,:)=NaN;mem=0;
        for i= 1:size(N{SRC},1);
            for j=[mem+1:i-1 i+1:size(N{SRC},1)];
                tmp{SRC}(j,1:3)= abs([N{SRC}(i,1)-N{SRC}(j,1) N{SRC}(i,2)-N{SRC}(j,2) N{SRC}(i,3)-N{SRC}(j,3) ]);
                if isnan(N{SRC}(j,3))==1 ;mem=j;break;end;
            end;
        end;
        N{SRC}=[ ((tmp{SRC}(:,1).*111).^2+(tmp{SRC}(:,2).*(cos(nanmean(N{SRC}(:,1)))*111)).^2).^0.5 tmp{SRC}(:,3)];
        ax(3,SRC)=subplot(numel(source),3,(SRC-1)*numel(source)+3);[n,x]=hist(N{SRC},0:0.1:30);bar(x,n./100);xlim([0 5]);ylabel('{\bf N_{pair} [.10^{2}]}');box on;grid on;
        if SRC~=numel(source); set(gca,'xticklabel',[]) ;else xlabel('{\bf \Delta [km]}');end
        if SRC==1;legend('{\bf \Delta_{horiz.}}','{\bf \Delta_{depth}}');end
    end
    linkaxes(ax(1,:),'xy');    linkaxes(ax(2,:),'xy');    linkaxes(ax(3,:),'xy')
    for SRC=1:numel(source)
        axes(ax(1,SRC));t=get(gca,'ylim');
        text(-4,t(1)+diff(t)/2,['{\bf ' num2str(sum(1-isnan(tmp{SRC}(:,1)))) ' eq. }'],'rotation',90,'HorizontalAlignment','center','FontSize',11)
        text(-5,t(1)+diff(t)/2,['{\bf ' source{SRC} ' }'],'rotation',90,'HorizontalAlignment','center','FontSize',11)
        legend(lab(SRC,:));
    end
end