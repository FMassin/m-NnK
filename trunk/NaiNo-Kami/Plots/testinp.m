function testinp

source = '20081228153700WY.UUSS.inp';
[a,num]=system(['cat ' source ' | wc -l']);
num=str2num(num);

for i=1:10
    a = randomshoot(1:num)
    system('"" > inpfiles');
    system('mkdir -p NLLoc');

    for ii=a'
        num2str(ii)
        system(['head -n ' num2str(ii) ' ' source ' | tail -n 1  >> inpfiles']) ; 
        system('NLLoc NLL.inp') ; 
        system(['rm -r NLLoc_' num2str(i) '_' num2str(ii)]);
        system(['cp -r NLLoc NLLoc_' num2str(i) '_' num2str(ii)]) ;    
        system(['cp inpfiles NLLoc_' num2str(i) '_' num2str(ii) '/']) ;
    end
end

system('"" > XYZ.txt');
system('"" > stat.txt');
for ii=1:num
    for i=1:10
        liste = dir(['NLLoc_' num2str(i) '_' num2str(ii) '/WY_*.hyp']);
        test = char(liste.name);
        if numel(test) >= 33
            disp(['Using ' test(1,:)]);
            system(['head -n 7 NLLoc_' num2str(i) '_' num2str(ii) '/' test(1,:) ' | tail -n 1  >> XYZ.txt'])
            system(['head -n 8 NLLoc_' num2str(i) '_' num2str(ii) '/' test(1,:) ' | tail -n 1  >> stat.txt'])
        end
    end
end

XYZ = importdata('XYZ.txt') ; 
Z = XYZ.data ; 
ind = find(Z>-3) ;
Z=Z(ind);

stat = importdata('stat.txt') ; 
stat = stat.textdata;
stat = [str2num(char(stat(ind,11)))  str2num(char(stat(ind,9)))] ; %stat(:,[11 9]) ; 

figure
ax(1) =subplot(1,7,1:2) ; plot(stat(:,1),Z,'ob','LineWidth',2) ; box on ; axis tight;xlabel('N^s^t^a^t^i^o^n');ylabel('Z [km]');
ax(2) =subplot(1,7,3:4) ; plot(stat(:,2),Z,'ob','LineWidth',2) ; box on ; axis tight;xlabel('RMS [s]');ylabel('Z [km]');

color = jet(size(stat,1)) ; 
[poub,ind] = sort(stat(:,2),'descend') ; 
stat = stat(ind,:) ;
Z= Z(ind);
%color = color(ind,:) ; 
ax(3) =subplot(1,7,5:7) ; hold on
for i=1:size(stat,1)
    plot(stat(i,1),Z(i),'o','color',color(i,:),'LineWidth',2);
end
hold off ;
box on ; axis tight;xlabel('N^s^t^a^t^i^o^n');ylabel('Z [km]');
colormap('jet');caxis([min(stat(:,2)) max(stat(:,2))]);c=colorbar;set(get(c,'ylabel'),'String', 'RMS [s]'); shading interp

hlink = linkprop(ax,{'YLim'});
hlink2 = linkprop(ax([1 3]),{'XLim'});
