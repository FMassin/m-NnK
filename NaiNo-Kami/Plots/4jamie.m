function fpvsFPvshyp

system('./prt2hypoDD.pl "/Users/fredmassin/PostDoc_Utah/Results/Teton/NNK-Teton/clst/2010/*/*/*/events/*/*.h71"');
load /Users/fredmassin/PostDoc_Utah/Results/Teton/clusterfocmec.txt
load /Users/fredmassin/PostDoc_Utah/Results/Teton/focmecM2.txt
load loc3d.txt
mem=0;ind=0;loc=cell(1000,1);
for i=1:size(loc3d,1)
    if loc3d(i,1)~=mem;ind=ind+1;mem=loc3d(i,1);end
    loc{ind}=[loc{ind};loc3d(i,:)]; 
end
loc=loc{ind};
for i=size(loc,1)
    [strike(i),dip(i)]=fit3Dplane(loc{i}(:,3:5));
end
    
ax(1)=subplot(1,3,1);rose3D(focmecM2(:,end-2)+90);
ax(2)=subplot(1,3,2);rose3D(clusterfocmec(:,end-2)+90);
ax(3)=subplot(1,3,3);rose3D(strike);
linkprop(ax,{'CameraPosition','CameraUpVector'});
