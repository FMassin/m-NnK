function [tim,maxi,timenorm,timenorm2]=plot_NNKwfsmax(data,dataless)


tim = [] ; 
maxi = [] ;
timenorm = [] ;
timenorm2 = [] ;
if exist('ax','var')==0;ax=gca;end
if exist('in','var')==0;in=1;end
if exist('nets','var')==0 ; nets = 1:size(data,2) ; end
if exist('stas','var')==0 ; stas = 1:size(data,3) ; end

stas =  1;
for net=nets ;
    for stat=stas;
        for compo=1:size(data,4);
            for pha=1:size(data,5);
                cnt=0;
                for ev=1:size(data,1); 
                    if length(dataless{ev,net,stat,compo,pha})>=6
                        if sum(abs(data{ev,net,stat,compo,pha})) >0 
                            cnt=cnt+1;
                        end
                    end
                end
                if cnt>0
                    mat = zeros(10000,size(data,1));
                    time = zeros(1,size(data,1));
                    cnt = 0 ;
                    for ev=1:size(data,1);
                        if length(dataless{ev,net,stat,compo,pha})>=6 & sum(abs(data{ev,net,stat,compo,pha})) >0
                            cnt=cnt+1;
                            a=data{ev,net,stat,compo,pha};
                            mat(1:size(a,1),cnt) = a(:,1) ;
                            time(1,cnt) = dataless{ev,net,stat,compo,pha}{6};
                        end
                    end
                    mat = mat(1:length(a),1:cnt);
                    time = time(1,1:cnt);
                    [maximas,shifts] = max(abs(mat(1:fix(size(mat,1)/2),:))) ;
                    time = time+(shifts/(24*60*60*100)) ;
                    [poub,main] = nanmax(maximas);
                    maximas = maximas./poub;
                    
                    if maximas(main) == 1
                        test = time-min(time) ;
                        test = test./nanmax(test) ;                        
                        timenorm2 = [timenorm2  test];
                        
                         
                        maxi = [maxi   maximas] ;

                        time = (time-time(main))*24*60*60;
                        tim = [tim  time];
                        
                        time = time./nanmax(abs(time));
                        time(isnan(time)==1) = 0 ;
                        
                        timenorm = [timenorm time] ; 
                        
                        %whos time timenorm timenorm2 maxi
                        
                    else
                        maximas
                        time
                    end
                end
end;end;end;end;

