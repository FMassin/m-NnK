function [X,Y,Z,erX,erY,erZ,XX,YY,ZZ,C3,to]=addisolate(lims)

%,X1,X2,Y1,Y2,Ylat
X=[];Y=[];Z=[];erX=[];erY=[];erZ=[];XX=[];YY=[];ZZ=[];C3=[];

load ../tmp/membutton.mat;
if strcmp(get(butt(3),'String'),'U')==1
    if exist('../tmp/plot_NNK.mat','file')== 2;    load ../tmp/plot_NNK.mat ;end
    mem = size(Y,2);
    bornes = [datestr(param(4),'yyyymmddHHMMSS') ; datestr(param(5),'yyyymmddHHMMSS')] ;
    
    if isnan(lims(1,1)) == 1 ; lims(1,1)=-360;end
    if isnan(lims(1,2)) == 1 ; lims(1,2)=360;end
    if isnan(lims(2,2)) == 1 ; lims(2,2)=360;end
    if isnan(lims(2,1)) == 1 ; lims(2,1)=-360;end
    if isnan(lims(3,1)) == 1 ; lims(3,1)=-360;end
    if isnan(lims(3,2)) == 1 ; lims(3,2)=360;end
    
     
    com = ['awk ''$1*1000000+$2*10000*$3*100+$4>' bornes(1,:) ...
        ' && $1*1000000+$2*10000*$3*100+$4<' bornes(2,:) ...
        ' {print $5+$6,$7+$8,$9,$10,$11,$12,$1*1000000+$2*10000*$3*100+$4}'' ~/PostDoc_Utah/Results/NNK/1981-2010/isolated.txt '...
        ' | awk ''$2>' num2str(-1*lims(1,2)) ' && $2<' num2str(-1*lims(1,1)) ...
        ' && $1>' num2str(lims(2,1)) ' && $1<' num2str(lims(2,2)) ...
        ' && $3>' num2str(-1*lims(3,2)) ' && $3<' num2str(-1*lims(3,1)) ...
        ' && $6<' num2str(5) ' {print $0}'' '];
    
    [a,b]=system(com);
    if numel(b) >= 3
        b=str2num(b)';
        
        b(3,:) = -1*b(3,:);
        b(2,:) = -1*b(2,:);
        
        
        X = b(2,:);
        Y = b(1,:);
        Z = b(3,:);
        
        
        [poub,answer]=system(['./distance.pl ' num2str([ nanmean(X) nanmean(Y) nanmean(X)+1 nanmean(Y) ])]);
        kmlon=abs(str2num(answer));
        [poub,answer]=system(['./distance.pl ' num2str([ nanmean(X) nanmean(Y) nanmean(X) nanmean(Y)+1 ])]);
        kmlat=abs(str2num(answer));
        
        %dim=1000; %reloc
        dim=1;%loc
        
        erX = [b(2,:)+b(5,:)./(kmlon*dim) ; b(2,:)-b(5,:)./(kmlon*dim)];
        erY = [b(1,:)+b(4,:)./(kmlon*dim) ; b(1,:)-b(4,:)./(kmlat*dim)];
        erZ = [b(3,:)+b(6,:)./(dim) ; b(3,:)-b(6,:)./(dim)];
        XX  = [b(2,:) ; b(2,:)];
        YY  = [b(1,:) ; b(1,:)];
        ZZ  = [b(3,:) ; b(3,:)];
        to = datenum(num2str(b(7,:)'),'yyyymmddHHMMSS') ; 
        
        C3 = repmat([0 0 0],size(X,2),1);
        
        disp(['addisolate.m: ' num2str(size(b,2)) ' unique earthquakes added between ' datestr(param(4),'yyyy/mm/dd HH:MM:SS') ' and ' datestr(param(5),'yyyy/mm/dd HH:MM:SS')  ])
    end
end