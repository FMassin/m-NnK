function dendro2bval(clustin)



%%% pre set %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
global clust hpp hp fieldedit oldclust
if exist('../tmp/plot_NNK.mat','file')== 2;    load ../tmp/plot_NNK.mat ;end
file= '/Users/fredmassin/PostDoc_Utah/Results/NNK/1981-2010/yell_nlloc_zmap_full_7210_loc.cat'; %total
if exist('clustin','var')==0
    [time] = taketime ;
    [clust,oldclust,limx]=takeclust(oldclust);
else
    clust=clustin;
end
if exist('clust','var')==0 ;[clust] = clusters;end
nb=[2 +inf] ;
pickcluster = 1:size(clust,1) ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% collect r ev's M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cnt=0;
for clst = pickcluster(1:end)
    if size(clust{clst},1)> nb(1) & size(clust{clst},1) < nb(2) 
        cnt=cnt+1;
    end
end
Mclst(1:cnt) = NaN ;
for clst = pickcluster(1:end)
    if size(clust{clst},1)> nb(1) & size(clust{clst},1) < nb(2) 
        test=cell2mat(clust{clst}(:,25))';
        test(test==-9.99) = NaN ; 
        Mclst(cnt+1:cnt+length(test)) = test;
        cnt=cnt+length(test);
    end
end
Mclst=Mclst(1:cnt);
X=-1:0.2:13;

[Nclst] = hist(Mclst,X) ;
[~,born(1,1)]=max(Nclst);
for i=born(1,1):length(X);if sum(Nclst(i:i+1))==0;      born(2,1)=i-1;       break;end;end

test= -1*(  diff(abs(log10(Nclst(born(1,1):born(2,1))))) ./ diff(X(born(1,1):born(2,1)))  );
test(test==-Inf)=NaN;test(test==Inf)=NaN;
b(1)= nanmean(test)+nanvar(test)/2;
test= log10(Nclst(born(1,1):born(2,1))) + (b(1) .* X(born(1,1):born(2,1)));
test(test==-Inf)=NaN;test(test==Inf)=NaN;
a(1)=  nanmean(test)+nanvar(test)/2 ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%% collect total ev's M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bornes = [datestr(param(4),'yyyymmddHHMMSS') ; datestr(param(5),'yyyymmddHHMMSS')] ;
com = ['awk ''$3*10000000000+$4*100000000+$5*1000000+$8*10000+$9*100+$10>' bornes(1,:) ...
            ' && $3*10000000000+$4*100000000+$5*1000000+$8*10000+$9*100+$10<' bornes(2,:) ...
            ' {print $6}'' ' file ];
[~,answer]=system(com);
Mtot = str2num(answer); 

[Ntot] = hist(Mtot,X) ;
[~,born(1,2)]=max(Ntot);
for i=born(1,2):length(X);if sum(Ntot(i:i+1))==0;      born(2,2)=i-1;       break;end;end

test= -1*(  diff(abs(log10(Ntot(born(1,2):born(2,2))))) ./ diff(X(born(1,2):born(2,2)))  );
test(test==-Inf)=NaN;test(test==Inf)=NaN;
b(2)= nanmean(test)+nanvar(test)/2;
test= log10(Ntot(born(1,2):born(2,2))) + (b(2) .* X(born(1,2):born(2,2)));
test(test==-Inf)=NaN;test(test==Inf)=NaN;
a(2)=  nanmean(test)+nanvar(test)/2 ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%hpp=uipanel;
[hpp] = resizepanels(hp,hpp,1);

%layout %%%%%%%%%%%%%%%%%%%%%%%%%%%
ax(1)=subplot(1,2,1,'parent',hpp(end));
ax(2)=subplot(1,2,2,'parent',hpp(end));

%%% plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(ax(1))
hold on ;
[h(2)]=semilogy(X(born(1,1):born(2,1)), 10.^(a(1)-(b(1)*X(born(1,1):born(2,1)))),'g','linewidth',2) ;
[h(1)]=semilogy(X,Nclst,'ok','MarkerFaceColor','g') ;

[h(4)]=semilogy(X(born(1,2):born(2,2)), 10.^(a(2)-(b(2)*X(born(1,2):born(2,2)))),'b','linewidth',2) ;
[h(3)]=semilogy(X,Ntot,'ok','MarkerFaceColor','b') ;
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% label %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(ax,'Layer','top','xlim',[0 5],'ylim',[0.1 10000],'YScale','log');
legend(h, ['R. eq. [' num2str(sum(isnan(Mclst)==0)) ']'], ['a=' num2str(a(1)) ', b=' num2str(b(1)) ], ['Tot. eq. [' num2str(sum(isnan(Mtot)==0)) ']'] , ['a=' num2str(a(2)) ', b=' num2str(b(2)) ] ) ;
xlabel({'\bf Coda magnitude'});ylabel({'\bf Number of eq.'});title([datestr(param(4)) ' to ' datestr(param(5)) ])
grid on;box on
% set(A2,'linewidth',2,'linestyle','-');
% set(AX(1),'Ydir','normal','xlim',[0 1],'ylim',[0 1],'ytick',[0 0.5 1]);
% xlabel({'\bf Normalized time'})
% ylabel({'\bf Mo/Mo_{max}'});grid on
% axes(AX(2))
% ylabel({'\bf d(Mo/Mo_{max})'});grid on
% linkaxes(AX,'x') ; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

