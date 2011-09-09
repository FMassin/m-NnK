function NNK_sacupdate(pathtomanualinp,path2clusters,sacextension)

date2sec = (60*60*24) ;
for i = 1 : size(path2clusters,1)
    liste = path2clusters{i} ;

    for ii = 1 : size(liste,1)

        %[poubelle,dirname] = fileparts(liste(ii,:));
        listesac = dir(fullfile(liste(ii,:),['*' sacextension])) ;
        listesac = char(listesac.name) ;

        if size(listesac,1) > 0
            outslave = rsac(fullfile(liste(ii,:),listesac(1,:)));
            [dirname] = lh(outslave,'KEVNM') ;

            test = fullfile(pathtomanualinp,[dirname(3:14) '.inp']);
            if exist(test,'file') == 2
                for iii = 1 : size(listesac,1)
                    sta = listesac(iii,1:3) ;
                    compo = listesac(iii,5) ;
                    commande = ['./NNK/inp2NNK.pl ' pathtomanualinp ' ' dirname(3:14)  ' ' sta ' P'] ;
                    [a,b] = system(commande) ;
                    if numel(b) >= 20
                        P = datenum(b(4:20),'yymmddHHMMSS.FFF') ;
                        polP = b(1:2) ;
                    else
                        P = [] ;
                        polP = '  ' ;
                    end
                    commande = ['./NNK/inp2NNK.pl ' pathtomanualinp ' ' dirname(3:14)  ' ' sta ' S'] ;
                    [a,b] = system(commande) ;
                    if numel(b) >= 20
                        S = datenum(b(4:20),'yymmddHHMMSS.FFF') ;
                        polS = b(1:2) ;
                    else
                        S = [] ;
                        polS = '  ' ;
                    end

                    if strcmp(compo,'Z') == 1 & (numel(P) > 0 | numel(S) > 0)

                        memnamesalve = fullfile(liste(ii,:),listesac(iii,:));
                        outslave = rsac(memnamesalve);
                        [NZYEAR,NZJDAY,NZHOUR,NZMIN,NZSEC,NZMSEC] = ...
                            lh(outslave,'NZYEAR','NZJDAY','NZHOUR','NZMIN','NZSEC','NZMSEC') ;
                        zero1 = str2num(datestr(addtodate(datenum(['00/00/' num2str(NZYEAR) ' 00:00' ]), NZJDAY, 'day'),'yymmddHHMMSS')) ;
                        zero1 = zero1 + (NZHOUR*10000+NZMIN*100+NZSEC+NZMSEC/1000)  ;
                        zero1 = datenum(num2str(zero1),'yymmddHHMMSS.FFF') ;

                        if numel(P) >0
                            T6 = (P-zero1)*date2sec ;
                            KT6 = [polP '   man'] ;
                            outslave=ch(outslave,'T6',T6,'KT6',KT6) ;
                        end
                        if numel(S) >0
                            T7 = (S-zero1)*date2sec ;
                            KT7 = [polS '   man'] ;
                            outslave=ch(outslave,'T7',T7,'KT7',KT7) ;
                        end
                        %lh(outslave)
                        wsac(memnamesalve,outslave);
                    end
                end
            end
        end
    end
end