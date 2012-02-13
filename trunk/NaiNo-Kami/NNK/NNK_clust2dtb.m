function [path2clusters] = NNK_clust2dtb(listeclusters,path2dataoutput,stamaitre,compo,sacextension,wfsextention)


path2dataoutput = [path2dataoutput '/clst'] ;
path2clusters = cell(0) ; 
[poubelle,directout] = fileparts(path2dataoutput) ; 



if size(listeclusters,1) > 0
    path2clusters = cell(size(listeclusters,1),1) ; 
    
    % progress bar initiate %%%%%%%%%%%%%%%
    maxi=size(listeclusters,1);progress_bar_position=0;tm=tic;count=0;
    
    for i = 1: maxi
        
        % Prefer known cluster as master %%%%%%
        liste = listeclusters{i};
        inds = 1:size(liste,1) ; 
        flag = 0 ;  
        for ii=1:size(liste,1)
            [pathfile]= fileparts(liste(ii,:)) ;
            if strcmp(pathfile(1:length(path2dataoutput)),path2dataoutput) == 1
                inds = [ii 1:ii-1 ii+1:size(liste,1)] ; 
                flag = 1 ;
                break
            end
        end
        liste = liste(inds,:) ;
        
        
        if flag == 0
            % Create new cluster %%%%%%%%%%%%%%%%%
            [pathevent,event] = fileparts(liste(1,:)) ; 
            newpath = fullfile(path2dataoutput,event(1:4),event(5:6),event(7:8),event)  ;   
            eventspath = fullfile(newpath,'events') ;
            if exist(newpath,'dir') ~= 7
                mkdir(newpath) ;
                copyfile([liste(1,:) '/*' sacextension],[newpath '/'])
                depart = 1 ;
                message= ['NEW CLUSTER : ' liste(1,:) ' copied to ' newpath]; 
                mkdir(eventspath) ;
            else
                depart=1;
                message= ['KNOWN CLUSTER : ' liste(1,:) ' updating']; %disp(message)
            end
        else
            % Update known cluster %%%%%%%%%%%%%%%
            eventspath = fullfile(liste(1,:),'events') ; 
            depart = 2 ;
            message= ['KNOWN CLUSTER : ' liste(1,:) ' updating']; %disp(message)
            mkdir(eventspath) ;
        end
        
        
        % Move file to clust %%%%%%%%%%%%%%%%%
        newliste = ''; already='';
        for ii=depart:size(liste,1)
            [poubelle,event] = fileparts(liste(ii,:)) ; 
            [poubelle,test] = system(['ls -dl ' liste(ii,:)]) ;
            cible = fullfile(eventspath,event)  ;
            newliste = [newliste ; cible] ;
            if strcmp(test(1),'d') == 1 
                movefile(liste(ii,:),[eventspath '/']) ;                
                relatifcible = ['../../../../' cible(1,end-55:end)] ; 
                
                % Link clust file to dtec dtbase %%%%
                %man ln : ln -s cible/source nomdulien 
                commande = ['ln -s ' relatifcible ' ' liste(ii,:)] ; % adressage relatif
                system(commande) ;
                message= [ liste(ii,:) ' moved to ' eventspath ' & ' relatifcible ' linked to ' liste(ii,:)];
            elseif strcmp(test(1),'l') == 1 
                message= [ liste(ii,:) ' is already linked to a cluster '];%disp(message)
                already=[already ' ' liste(ii,end-16:end)];
            else
                message= [ liste(ii,:) ' is not a directory, NNK can not link it to ' eventspath ];%disp(message)
            end
        end
        path2clusters{i} = newliste ; 

        % Define mast with MAG header %%%%%%%%%%
        tmpliste = dir([eventspath '/*' wfsextention]) ;
        tmpliste = char(tmpliste.name) ;
        tmpliste = [repmat([eventspath '/'],size(tmpliste,1),1) tmpliste] ;
        if size(tmpliste,1) > 0
            magnitudes = zeros(size(tmpliste,1),1) ;
            for ii=1:size(tmpliste,1)
                divide = 0 ;
                magnitude = 0 ;
                for iii = 1 : size(stamaitre,1)
                    filename = fullfile(tmpliste(ii,:),[stamaitre(iii,1:3) '.' compo sacextension]) ;
                    if exist(filename,'file') == 2
                        out = rsac(filename);
                        [MAG] = lh(out,'MAG') ;
                        magnitude = magnitude+ MAG ;
                        divide = divide+1 ;
                    end
                end
                magnitudes(ii) = magnitude/divide ;
                if divide == 0 ;
                    magnitudes(i) = 0 ;
                    message= ['no MAG header read for ' tmpliste(ii,:)];%disp(message)
                else
                    message= ['Mmoy(' tmpliste(ii,:) ') = ' num2str(magnitudes(ii))] ;%disp(message)
                end
            end
            
            [val,ind] = sort(magnitudes,'descend') ;
            master = tmpliste(ind(1),:)  ;
            [rootsclust] = fileparts(master) ;
            [rootsclust] = fileparts(rootsclust) ;
            delete([rootsclust '/*' sacextension]) ;
            copyfile([master '/*' sacextension], [rootsclust '/']) ;
            message= [ 'Master update : delete ' rootsclust '/*' sacextension ' & copy ' master '/*' sacextension ' to ' rootsclust '/'];%disp(message)
        
        
            % Create events link in clst dtbase
            % 1   5 7 9 111315
            % yyyymmddHHMMSSNN
            % 16-(2+13)    16-(2+1)
            for ii=1:size(tmpliste,1)
                %[val,ind] = sort(str2num(tmpliste(:,end-(length(wfsextention)+13):end-(length(wfsextention)+1))),'descend') ;
                ind=ii;
                younger = tmpliste(ind(1),end-(length(wfsextention)+13):end) ;
                year = younger(1:4) ;
                month = younger(5:6) ;
                day = younger(7:8) ;
                newrootsclust = fullfile(path2dataoutput,year,month,day,younger) ;
                path2newroots = fullfile(path2dataoutput,year,month,day) ;
                if strcmp(newrootsclust,rootsclust) ~= 1 & exist(newrootsclust,'dir') ~= 7
                    if exist(newrootsclust,'dir') ~= 7  ;
                        if exist(path2newroots,'dir')~=7;mkdir(path2newroots);end
                        relatifrootsclust = ['../../../../' rootsclust(1,end-31:end)] ;
                        commande = ['ln -s ' relatifrootsclust ' ' newrootsclust] ; % adressage relatif
                        system(commande) ;
                        message= ['Link to ' relatifrootsclust ' in ' newrootsclust];%disp(message)
                    else
                        warning(['directory ' newrootsclust ' exist and contains :']);
                        dir(newrootsclust)
                    end
                end
            end
        else
            warning(['no file to read in ' eventspath '/*' wfsextention]);
        end
        % progress bar update %%%%%%%%%%%%%%%%%
        message=['Writing cluster ' num2str(i) '/' num2str(maxi) '. '];%disp(message)
        if numel(already)~=0 ; message=[message 'CAUTION, WERE ALREADY WRITTEN IN THIS CLUSTER: ' already ];end
        clc;count=count+1;[progress_bar_position]=textprogressbar(count,maxi,progress_bar_position,toc(tm),message);tm=tic;
    end
end

