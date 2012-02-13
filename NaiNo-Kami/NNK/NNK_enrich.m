function [Strwfs,Strdataless] = NNK_enrich(Strwfs,Strdataless)


for ev=1:size(Strwfs,1)
    for net=1:size(Strwfs,2)
        for sta=1:size(Strwfs,3)
            for cmp=1:size(Strwfs,4)
                for pha=1:size(Strwfs,5)
 
                    memnum(ev) = 0 ; memdiff(ev) = 0 ; Amplref(ev) = 0 ; memAmplR(ev) = 0 ;
                    if numel(Strwfs{ev,net,sta,cmp,pha}) > 0 & numel(Strdataless{ev,net,sta,cmp,pha})>=17
                    if Strdataless{ev,net,sta,cmp,pha}{15} > Strdataless{ev,net,sta,cmp,pha}{6}
                        amplite=max(abs(Strwfs{ev,net,sta,cmp,pha}));
                        for evref=[1:ev-1 ev+1:size(Strwfs,1)]
                            memnum(evref) = 0 ; memdiff(evref) = 0 ; Amplref(evref) = 0 ; memAmplR(evref) = 0 ; 
                            for netref=[1:net-1 net+1:size(Strwfs,2)]
                                for staref=[1:sta-1 sta+1:size(Strwfs,3)]
                                    cmpref=cmp;pharef=pha;

                                    if numel(Strwfs{evref,netref,staref,cmpref,pharef}) > 0 & numel(Strdataless{evref,net,sta,cmp,pha})>=17
                                    if Strdataless{evref,netref,staref,cmpref,pharef}{15}>Strdataless{evref,netref,staref,cmpref,pharef}{6}

                                        memdiff(evref)  = memdiff(evref)+(Strdataless{evref,netref,staref,cmpref,pharef}{16}-Strdataless{ev,net,sta,cmp,pha}{16});
                                        memnum(evref)   = memnum(evref)+1;
                                        test = max(abs(Strwfs{evref,netref,staref,cmpref,pharef}));
                                        Amplref(evref)  = Amplref(evref)+ test; 
                                        memAmplR(evref) = memAmplR(evref)+(test/amplite);  
                                    end                      
                            end;end;end;
                            memdiff(evref)  = memdiff(evref)/memnum(evref);
                            memAmplR(evref) = memAmplR(evref)/memnum(evref); 
                            Amplref(evref)  = Amplref(evref)/memnum(evref);
                    end
                    end;end

                    mem=ev;
                    if numel(Strwfs{ev,net,sta,cmp,pha}) == 0 
                        for evref=[1:ev-1 ev+1:size(Strwfs,1)]
                            if numel(Strwfs{evref,net,sta,cmp,pha}) > 0 & numel(Strdataless{evref,net,sta,cmp,pha})>=17 & length(Amplref) >=evref & length(Amplref) >=mem
                            if Strdataless{evref,net,sta,cmp,pha}{15}>Strdataless{evref,net,sta,cmp,pha}{6} & Amplref(evref) > Amplref(mem)
                                Strwfs{ev,net,sta,cmp,pha} = Strwfs{evref,net,sta,cmp,pha}/memAmplR(evref);
                                Strdataless{ev,net,sta,cmp,pha} = Strdataless{evref,net,sta,cmp,pha};
                                Strdataless{ev,net,sta,cmp,pha}{6} = Strdataless{evref,net,sta,cmp,pha}{6}-memdiff(evref);
                                Strdataless{ev,net,sta,cmp,pha}{15} = Strdataless{evref,net,sta,cmp,pha}{15}-memdiff(evref);
                                if Strdataless{evref,net,sta,cmp,pha}{16}>Strdataless{evref,net,sta,cmp,pha}{6};
                                    Strdataless{ev,net,sta,cmp,pha}{16} = Strdataless{evref,net,sta,cmp,pha}{16}-memdiff(evref);
                                end
                                if Strdataless{evref,net,sta,cmp,pha}{17}>Strdataless{evref,net,sta,cmp,pha}{6};
                                    Strdataless{ev,net,sta,cmp,pha}{17} = Strdataless{evref,net,sta,cmp,pha}{17}-memdiff(evref);
                                end
                                mem = evref ; 
                            end;end;end;end;end;end;end;end;
    disp(['Event ' num2str(ev) ': phases updated/checked'])
end

