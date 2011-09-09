function plot_gmtfault(file,lims,ax,maptoolbox,flag)

% simple drawing of active fault lines using ascii input file
%
% input: flag = 1, lon (1st column) and lat (2nd column)
%        flag = 0, lat (1st column) and lon (2nd column)

if exist('flag','var') == 0 ; flag = 1 ; end 
if exist('ax','var') == 0 ; ax = gca ; end 
if exist('maptoolbox','var') == 0 ; maptoolbox = 0 ; end
if exist('lims','var') == 0 
    lims = [get(ax,'xlim')  get(ax,'ylim')]; %[-111 -110 44 45] ;
    disp(['ATTENTION : A automatic box (' num2str(lims) ') has been set up !! '])
end
MIN_LON=lims(1);
MAX_LON=lims(2);
MAX_LAT=lims(3);
MIN_LAT=lims(4);

[poub,answer]=system(['./distance.pl ' num2str([ MIN_LON mean(lims(3:4))  MAX_LON mean(lims(3:4)) ])]);  
GRID(3,1) = abs(str2num(answer));
[poub,answer]=system(['./distance.pl ' num2str([ mean(lims(1:2)) MIN_LAT   mean(lims(1:2)) MAX_LAT  ])]);  
GRID(4,1) = abs(str2num(answer));
[poub,answer]=system(['./distance.pl ' num2str([ mean(lims(1:2)) mean(lims(3:4))  mean(lims(1:2))+1 mean(lims(3:4))  ])]);  
kmlon = abs(str2num(answer));
[poub,answer]=system(['./distance.pl ' num2str([ mean(lims(1:2)) mean(lims(3:4))  mean(lims(1:2)) mean(lims(3:4))+1  ])]);  
kmlat = abs(str2num(answer));
OVERLAY_MARGIN = 0 ;
ICOORD = 2 ;% =1 lat-lon =2 km 
PREF(6,1:4) = [0.6 0.6 0.6 1]; % fault color width

xs = GRID(1,1);
xf = GRID(3,1);
ys = GRID(2,1);
yf = GRID(4,1);   
xinc = (xf - xs)/(MAX_LON-MIN_LON);
yinc = (yf - ys)/(MAX_LAT-MIN_LAT);

fid = fopen(file,'r');
n = 10000;  % dummy number (probably use 'end' later)
count = 0;
for m = 1:n
    count = count + 1;
    if m == 1
        a = textscan(fid,'%f %f','headerlines', 2);
        if flag == 0
            y{m} = a{1};
            x{m} = a{2};
        elseif flag == 1
            x{m} = a{1};
            y{m} = a{2};
        end
    else
        a = textscan(fid,'%f %f','headerlines', 1);
        if flag == 0
            y{m} = a{1};
            x{m} = a{2};
        elseif flag == 1
            x{m} = a{1};
            y{m} = a{2};
        end
    end
end
fclose(fid);

dummy = OVERLAY_MARGIN;
icount = 0;
temp = 0;
nn = 0;


for m = 1:count
    if numel([x{m}])>0
        xx = [x{m}];
        yy = [y{m}];
        xx = xs + (xx - MIN_LON) * xinc;
        yy = ys + (yy - MIN_LAT) * yinc;
        nkeep = nn;
        hold on;
        for k = 1:length(xx)
            if xx(k) >= (xs-dummy)
                if xx(k) <= (xf+dummy)
                    if yy(k) >= (ys-dummy)
                        if yy(k) <= (yf+dummy)
                            nn = nn + 1;
                            if m ~= temp
                                icount = icount + 1;
                                temp = m;
                            end
                            %                        a = xy2lonlat([xx(k) yy(k)]);
                            a = [x{m}(k) y{m}(k)];
                            
                            %             b = xy2lonlat([xx(k+1) yy(k+1)]);
                            %          if ICOORD == 2 && isempty(LON_GRID) ~= 1
                            %             h = plot(gca,[a(1) b(1)],[a(2) b(2)],'Color',PREF(6,1:3),'LineWidth',PREF(6,4));
                            %          else
                            %             h = plot(gca,[xx(k) xx(k+1)],[yy(k) yy(k+1)],'Color',PREF(6,1:3),'LineWidth',PREF(6,4));
                            %          end
                            %             set(h,'Tag','AfaultObj');
                            %             AFAULT_DATA(nn,1) = icount;
                            %             AFAULT_DATA(nn,2) = a(1);	% lon. (start)
                            %             AFAULT_DATA(nn,3) = a(2);   % lat. (start)
                            %             AFAULT_DATA(nn,4) = b(1);   % lon. (finish)
                            %             AFAULT_DATA(nn,5) = b(2);   % lat. (finish)
                            %             AFAULT_DATA(nn,6) = xx(k);
                            %             AFAULT_DATA(nn,7) = yy(k);
                            %             AFAULT_DATA(nn,8) = xx(k+1);
                            %             AFAULT_DATA(nn,9) = yy(k+1);
                            AFAULT_DATA(nn,1) = a(1) ;	% lon. (start)
                            AFAULT_DATA(nn,2) = a(2) ; % lat. (start)
                            AFAULT_DATA(nn,3) = xx(k);
                            AFAULT_DATA(nn,4) = yy(k);
                            hold on;
                        end
                    end
                end
            end
        end
        % put NaN tag to raise drawing pen (breaking active fault segment)
        if nn > nkeep
            nn = nn + 1;
            AFAULT_DATA(nn,1) = NaN;
            AFAULT_DATA(nn,2) = NaN;
            AFAULT_DATA(nn,3) = NaN;
            AFAULT_DATA(nn,4) = NaN;
        end
    end
end


AFAULT_DATA = single(AFAULT_DATA);    % to reduce memory size

% ---------------------------- actual plotting --------------
if isempty(AFAULT_DATA)~=1
    axes(ax) ; 
    hold on
    [m,n] = size(AFAULT_DATA);
    % ===== old format plotting =================
    if n == 9
        disp('!!! Warning !!!');
        disp('   * This active fault data AFAULT_DATA are from old versions,');
        disp('   * Since old format produces fragmented lines, we strongly');
        disp('   * recommend to clear the data and re-read ascii data.');
        if ICOORD == 2 
            x1 = [rot90(AFAULT_DATA(:,2));rot90(AFAULT_DATA(:,4))];
            y1 = [rot90(AFAULT_DATA(:,3));rot90(AFAULT_DATA(:,5))];
        else
            x1 = [rot90(AFAULT_DATA(:,6));rot90(AFAULT_DATA(:,8))];
            y1 = [rot90(AFAULT_DATA(:,7));rot90(AFAULT_DATA(:,9))];
        end
    else
        if ICOORD == 2 
            x1 = AFAULT_DATA(:,1);
            y1 = AFAULT_DATA(:,2);
        else
            x1 = AFAULT_DATA(:,3);
            y1 = AFAULT_DATA(:,4);
        end
    end
    if maptoolbox == 1
        h = plot3m(y1,x1,repmat(3.5,size(x1,1),size(x1,2)),'Color',PREF(6,1:3),'LineWidth',PREF(6,4),'parent',ax);
    else
        h = plot3(x1,y1,repmat(3.5,size(x1,1),size(x1,2)),'Color',PREF(6,1:3),'LineWidth',PREF(6,4),'parent',ax);
        daspect([  1/kmlon 1/kmlat 1])
    end
    
    set(h,'Tag','AfaultObj');
    hold off;
end
