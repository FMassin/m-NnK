function [Strwfs] = NNK_rsac(listefichier,lesrecord,lesstat,lescompo,indrec,indstat,indcomp,pha,option)

%%%%%%%%%%%%
ploting=0; % Plot some interesting stuff
%%%%%%%%%%%%



% parameter and arrays initiate %%%%%%%
load NNK_params
init = zeros(1,secutim+fen) ;
codainit = zeros(1,secutim+codafen) ; 
Strwfs = cell(size(lesrecord,1),size(lesstat,1),size(lescompo,1),pha+2) ;
pathtostadtb = fullfile(path2dtb,'stat');
flag=1;
if exist(char(pathtostadtb),'dir') ~= 7 ; mkdir(pathtostadtb) ; end
if exist('option','var')~=1;option=0;end

% progress bar initiate %%%%%%%%%%%%%%%
maxi=size(listefichier,1);progress_bar_position=0;etm=tic;count =0;



if ploting==1
    % for test %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure('Position',get(0,'MonitorPosition'));colormap('cool')
    if pha>=1
        ax(4) = subplot(4,2,[1 2]) ; hold on ; ylabel('Raw')
        ax(1) = subplot(4,2,3) ; hold on ; ylabel('P')
        ax(2) = subplot(4,2,4) ; hold on ; ylabel('S')
        ax(3) = subplot(4,2,[5 6]) ; hold on ; ylabel('Coda')
        ax(5) = subplot(4,2,[7 8]) ; hold on ; ylabel('P to end')
    else
        for i=1:max(indcomp)
            ax(i) = subplot(max(indcomp),1,i) ; hold on ; ylabel(lescompo(i,:))
        end
    end
    
end

% Reading each file %%%%%%%%%%%%%%%%%%%   
for i=1:size(listefichier,1) ; 
   
    % each cell initiate %%%%%%%%%%%%%%%%%%   
    if pha >= 1 ; Strwfs{indrec(i),indstat(i),indcomp(i),1} = init ;end
    if pha >= 1 ; Strwfs{indrec(i),indstat(i),indcomp(i),3} = '' ;end
    if pha >= 2 ; Strwfs{indrec(i),indstat(i),indcomp(i),4} = init ; end
    if pha >= 3 ; Strwfs{indrec(i),indstat(i),indcomp(i),5} = codainit ; end
    if pha >= 3 ; Strwfs{indrec(i),indstat(i),indcomp(i),6} = codainit ; end
    
    Strwfs{indrec(i),indstat(i),indcomp(i),2} = 0 ;
      
    % progress bar update %%%%%%%%%%%%%%%%%
    clc;
    count=count+1;[progress_bar_position] = textprogressbar(count,maxi,progress_bar_position,toc(etm),...
        ['Reading ' listefichier(i,:)]) ;etm=tic;whos Strwfs 

    if option == 1;
        flag = logical(findstr(reshape(stamaitre',1,numel(stamaitre)),lesstat(indstat(i),:)));
    end
    
    if exist(listefichier(i,:),'file') == 2 & flag > 0      

        % Reading %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        out = rsac(listefichier(i,:),endian);

        % De-meaned %%%%%%%%%%%%%%%%%%%%%%%%%%%
        out(:,2) = out(:,2) - mean(out(:,2)) ; 
        
        % Filtering %%%%%%%%%%%%%%%%%%%%%%%%%%%
        raw=out;
        if flagfilt == 1
            out(:,2) = filtfilt(B,A,out(:,2)) ;
        end
    
        % Headers reading %%%%%%%%%%%%%%%%%%%%%
        [KSTNM,KCMPNM,NZYEAR,NZJDAY,NZHOUR,NZMIN,NZSEC,NZMSEC,NPTS,DELTA,KNETWK] = lh(out,'KSTNM','KCMPNM','NZYEAR','NZJDAY','NZHOUR','NZMIN','NZSEC','NZMSEC','NPTS','DELTA','KNETWK') ;
        if DELTA == -12345 ; DELTA  = 1/sam_rate ; end        
    
        % Save station infos %%%%%%%%%%%%%%%%%%
        savename =  fullfile(pathtostadtb,[netcode '_' lesstat(indstat(i),:) '_' lescompo(indcomp(i),:) '.mat']) ;
        if exist(savename,'file') ~= 2 
            hdr = out(:,3) ;
            save(savename,'hdr') ;
        end
        
        % First points of read datas %%%%%%%%%%
        zero1 = addtodate(datenum(['00/00/' num2str(NZYEAR) ' 00:00' ]), NZJDAY, 'day')+(NZHOUR/24)+(NZMIN/(24*60))+(NZSEC+(NZMSEC/1000))/(24*60*60)  ;
    
        % First points of P, S, coda, and end point 
        if pha >= 1
            [P,S,C,E]=NNK_getpick(out,[pathtoNNKdtec '/' pickimportcomand],listefichier(i,:),lesstat(indstat(i),:),zero1,DELTA);

            % Zeroing P, S and coda windows %%%%%%%
            WFP = init ;
            WFS = init ;
            WFC = codainit ;
            WFE = codainit ;

            if numel(P) > 0 % Windowing from P-secutim to P+fen %%%
                indout = [max([1 P-secutim])  min([size(out,1) (P+fen-1)])] ;
                indwf(1) = max([(P-secutim)*(-1) 1])  ;
                indwf(2) = indwf(1)+diff(indout) ;
                WFP(indwf(1):indwf(2)) = out(indout(1):indout(2),2)';
            end

            if pha >= 2 & numel(S) > 0 % Windowing from S-secutim to S+fen %%%
                indout = [max([1 S-secutim])  min([size(out,1) (S+fen-1)])] ;
                indwf(1) = max([(S-secutim)*(-1) 1])  ;
                indwf(2) = indwf(1)+diff(indout) ;
                WFS(indwf(1):indwf(2)) = out(indout(1):indout(2),2)';
            end

            if pha >= 3 & numel(C) > 0 % Windowing from C-secutim to C+codafen
                indout = [max([1 C-secutim])  min([size(out,1) (C+codafen-1)])] ;
                indwf(1) = max([(C-secutim)*(-1) 1])  ;
                indwf(2) = indwf(1)+diff(indout) ;
                WFC(indwf(1):indwf(2)) = out(indout(1):indout(2),2)';
            end

            if pha >= 3 & numel(E) > 0 % Windowing from P-secutim to E
                indout = [max([1 C-secutim])  min([size(out,1) (E)])] ;
                indwf(1) = max([(C-secutim)*(-1) 1])  ;
                indwf(2) = indwf(1)+diff(indout) ;
                WFC(indwf(1):indwf(2)) = out(indout(1):indout(2),2)';

                indout = [max([1 P-secutim])  min([size(out,1) (E)])] ;
                indwf(1) = max([(P-secutim)*(-1) 1])  ;
                indwf(2) = indwf(1)+diff(indout) ;
                WFE(indwf(1):indwf(2)) = raw(indout(1):indout(2),2)';
            end
        end
        if pha >= 0
            test=cell2mat(Strwfs(indrec(i),indstat(i),:,2));
            test=find(test>0);            
            if length(test)>0
                zeroref=Strwfs{indrec(i),indstat(i),test(1),2};
                deb=fix((Strwfs{indrec(i),indstat(i),test(1),2}-zero1)*(24*60*60*1/DELTA));
                indout = [max([1 deb])  min([size(out,1) deb+maxnpts-1])] ; %maxnpts
                indwf(1) = max([deb*(-1) 1])  ;
                indwf(2) = indwf(1)+diff(indout) ;
                
%                 disp(['Ref is :         ' datestr(zeroref,'yy/mm/dd HH:MM:SS.FFF') ])
%                 disp([' and it start at ' datestr(zero1,'yy/mm/dd HH:MM:SS.FFF')])
%                 disp(['the lag is : ' num2str(deb)])
%                 
%                 disp(['I take         [' num2str(indwf(1)) ' to ' num2str(indwf(2)) ']'])
%                 disp(['and move it to [' num2str(indout(1)) ' to ' num2str(indout(2)) ']'])
                
                tmp=out(indout(1):indout(2),2)';  
                out(:,2)=0;
                out(indwf(1):indwf(2),2) = tmp;
                zero1=zeroref;
            end
            out=[out ; zeros(maxnpts-size(out,1),size(out,2))];
        end
    
        % Outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if pha >= 0 & ~isempty(out(:,2)) ; Strwfs{indrec(i),indstat(i),indcomp(i),1} = out(1:maxnpts,2)' ;end
        if pha >= 0 & ~isempty(out(:,2)) ; Strwfs{indrec(i),indstat(i),indcomp(i),2} = zero1 ;end
        if pha >= 0 & ~isempty(out(:,2)) ; Strwfs{indrec(i),indstat(i),indcomp(i),3} = savename ;end
        
        if pha >= 1 & ~isempty(WFP) ; Strwfs{indrec(i),indstat(i),indcomp(i),1} = WFP ;end
        if pha >= 1 & ~isempty(WFP) ; Strwfs{indrec(i),indstat(i),indcomp(i),2} = zero1+(max([1 P-secutim-1])/(24*60*60*1/DELTA)) ;end
        if pha >= 1 & ~isempty(WFP) ; Strwfs{indrec(i),indstat(i),indcomp(i),3} = savename ;end
        
        if pha >= 2 & ~isempty(WFS) ; Strwfs{indrec(i),indstat(i),indcomp(i),4} = WFS ;end
        if pha >= 3 & ~isempty(WFC) ; Strwfs{indrec(i),indstat(i),indcomp(i),5} = WFC ;end
        if pha >= 3 & ~isempty(WFE) ; Strwfs{indrec(i),indstat(i),indcomp(i),6} = WFE ;end
    
        if ploting ==1
            % for test %%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            if pha>=1
                toplot = WFP ;if ~isempty(toplot);imagesc(1:length(toplot),repmat(count,1,length(toplot)),(toplot/max(abs(toplot)))','Parent',ax(1));end
                toplot = WFS ;if ~isempty(toplot);imagesc(1:length(toplot),repmat(count,1,length(toplot)),(toplot/max(abs(toplot)))','Parent',ax(2));end
                toplot = WFC ;if ~isempty(toplot);imagesc(1:length(toplot),repmat(count,1,length(toplot)),(toplot/max(abs(toplot)))','Parent',ax(3));end
                toplot = WFE ;if ~isempty(toplot);imagesc(1:length(toplot),repmat(count,1,length(toplot)),(toplot/max(abs(toplot)))','Parent',ax(5));end
                toplot = out(:,2) ;if ~isempty(toplot);imagesc(1:length(toplot),repmat(count,1,length(toplot)),(toplot/max(abs(toplot)))','Parent',ax(4));end
            else
                toplot = out(:,2) ;if ~isempty(toplot);plot((1:length(toplot))/DELTA,indstat(i)+(toplot/max(abs(toplot)))','Parent',ax(indcomp(i)));end
            end
            drawnow
        end
    end
end
if ploting==1&pha==0;linkaxes(ax,'xy');end