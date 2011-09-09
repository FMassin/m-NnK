function [ax,ay]=fpvsFPvshyp

% system('./prt2hypoDD.pl "/Users/fredmassin/PostDoc_Utah/Results/Teton/NNK-Teton-loh-0.9/clst/2010/*/*/*/events/*/*.h71"');
composite = load('/Users/fredmassin/PostDoc_Utah/Results/Teton/composite_NP_all.txt') ;
focmec = load('/Users/fredmassin/PostDoc_Utah/Results/Teton/focmecM2.txt');
load loc3d.txt

coef=[85 111 -1];

loc=cell(100,1);mem=0;ind=0;
for i=1:size(loc3d,1)
    if loc3d(i,1)~=mem;ind=ind+1;loc{ind}=[];end
    loc{ind}=[loc{ind};loc3d(i,:)];mem=loc3d(i,1);
end
loc=loc(1:ind);

cnt=0;
for i=1:size(loc,1)
    if size(loc{i},1)>2
        cnt=cnt+1;
        loc{cnt}=loc{i};
        id(cnt) = i;
    end
end
loc=loc(1:cnt);

figure
c=ceil(((size(loc,1))^0.5)*1.3);
l=ceil(size(loc,1)/c);
if c >= size(loc,1) ; l = 1 ; end

for i=1:size(loc,1)
    if size(loc{i},1)>2
        kms = [loc{i}(:,3)*coef(1) loc{i}(:,4)*coef(2) loc{i}(:,5)*coef(3)] ; 
        ay(i)=subplot(l,c,i);
        [strike(i),dip(i)]=fit3Dplane(kms,1);
        disp(['                                                         strike : ' num2str(strike(i)) ' dip : ' num2str(dip(i))])
        zlabel('Depth [km]')
        xlabel('Lon [dec.°]')
        set(ay(i),'xticklabel',get(ay(i),'xtick')/coef(1))
        ylabel('lat [dec.°]')
        set(ay(i),'yticklabel',get(ay(i),'ytick')/coef(2))
        title(['Cluster ' num2str(id(i))])
        box on
    end
end
    
figure
% rose3D(T,P,M,D,X,Y,Z,cut,colored,patate)
fak1 = zeros(size(focmec,1),1);
fak2 = zeros(size(composite,1),1);
fak3 = zeros(length(strike),1);

ax(1)=subplot(2,3,1);rose3D(focmec(:,end-2)+90,fak1,fak1+1,1,0,0,0,'map','r','earthquakes');
ax(2)=subplot(2,3,2);rose3D(composite(:,end-2)+90,fak2,fak2+1,1,0,0,0,'map','g','clusters');
ax(3)=subplot(2,3,3);rose3D(strike,fak3,fak3+1,1,0,0,0,'map','b','cluster fits');


ax(1)=subplot(2,3,4);rose3D(focmec(:,end-1),fak1,fak1+1,1,0,0,0,'dip','r','earthquakes');
ax(2)=subplot(2,3,5);rose3D(composite(:,end-1),fak2,fak2+1,1,0,0,0,'dip','g','clusters');
ax(3)=subplot(2,3,6);rose3D(dip,fak3,fak3+1,1,0,0,0,'dip','b','cluster fits');

