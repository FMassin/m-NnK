function [Peak,indsliste,StrCECM] = NNK_dtec_CECM(Strwfs,stat,compo,fen,ufen,seuil,maxnpts)




% parameter and arrays initiate %%%%%%%
pasdecalcul = 1000 ; 
peaks = [] ; 
Peak = zeros(400000,12) ;
indsliste = zeros(400000,1) ;
StrCECM = [] ; %Strwfs(:,:,1) ; %cell(size(Strwfs,1),size(Strwfs,2)) ; 
[indice] = NNK_dtec_divideid(pasdecalcul,size(Strwfs,1)) ; 
oldind = 0 ;
oldindliste = 0; 
init1=zeros(min([pasdecalcul size(Strwfs,1)]),maxnpts);

% progress bar initiate %%%%%%%%%%%%%%%
maxi=size(stat,1)*size(indice,2);progress_bar_position=0;etm=tic;count =0;


for i = 1:size(indice,2)    
    for ii = 1 : size(stat,1) ; tic;

        
        % progress bar update %%%%%%%%%%%%%%%%%
        clc;
        count=count+1;[progress_bar_position] = textprogressbar(count,maxi,progress_bar_position,toc(etm),...
            ['Detecting ' stat(ii,:) ' ']) ;etm=tic;
        
        % Make matrix of signal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        count = count + 1 ; 
        processmatZ = [] ; 
        processmatE = [] ;  
        processmatN = [] ; 
        for iii = 1:size(compo,1)
            if strcmp(compo(iii),'Z') == 1
                chan(1) = iii ;                 
                processmatZ=cell2mat2(Strwfs,min(indice(:,i)):max(indice(:,i)),ii,iii,1,maxnpts,init1);  
                processmatZ=processmatZ';
            elseif strcmp(compo(iii),'E') == 1
                chan(2) = iii ; 
                processmatE=cell2mat2(Strwfs,min(indice(:,i)):max(indice(:,i)),ii,iii,1,maxnpts,init1);  
                processmatE=processmatE';
            elseif strcmp(compo(iii),'N') == 1
                chan(3) = iii ; 
                processmatN=cell2mat2(Strwfs,min(indice(:,i)):max(indice(:,i)),ii,iii,1,maxnpts,init1);
                processmatN=processmatN';
            end            
        end
        
        % Detecting P and S waves %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if sum(sum(abs(processmatZ))) > 0
                [OUT,peaks] = CECM(processmatZ,processmatN,processmatE,fen,ufen,seuil,chan);
        end
        
        
        % Output picks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ~isempty(peaks)
            
            indpeak = [oldind+1 oldind+size(peaks,1)] ;
            peaks(:,8) = repmat(ii,size(peaks,1),1) ;
            if size(peaks,2) ~= size(Peak,2) ; disp(['!!!!! Attention : ligne 8 de NNK_dtec_CECM augmenter size(Peak,2) a ' num2str(size(peaks,2))]) ; end
            Peak(indpeak(1):indpeak(2),:) = peaks ;
            oldind = indpeak(2) ;
            
            toaddliste = str2num(NNK_dtec_findkey(num2str(peaks(:,7)))) ; 
            indpeak = [oldindliste+1 oldindliste+size(toaddliste,1)] ;
            indsliste(indpeak(1):indpeak(2)) = toaddliste ;
            oldindliste = indpeak(2) ;
            
            peaks = [] ; 
        end
    end
end
Peak = Peak(1:oldind,:) ;
indsliste = str2num(NNK_dtec_findkey(num2str(indsliste(1:oldindliste)))) ;