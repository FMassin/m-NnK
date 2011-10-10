function [done] = NNK_wsac(Strwfs,Strdataless,path2clst,path2dtb,exten,prefix,formatinp,mycomputer,seuil)

%                                     v- window length
% Usage : [stacks] = NNK_clust_interf(d,Strwfs,Strdataless,path2clst)
%  cell stacks-'            cell waveform-^    |____.____|     ^-path for wsac
%                                                   ^-cell info
%
%
% wf must be lined-up !



% parameter and arrays initiate %%%%%%%
dim1=1:size(Strdataless,1);
dim2=1:size(Strdataless,2);
dim3=1:size(Strdataless,3);
dim4=1:size(Strdataless,4);
dim5=1:size(Strdataless,5);
d1=length(dim1);
d2=length(dim2);
d3=length(dim3);
d4=length(dim4);
d5=length(dim5);
if exist('prefix','var')==1;if numel(prefix)>0;prefix=[prefix '_'];else;prefix='';end;else;prefix='';end
done='';
date2ind = (24*60*60) ;
if exist('mycomputer','var')==0;mycomputer='unix';seuil=0;end

for i1=dim1
    direct='';
    for i2=dim2
        for i3=dim3
            for i4=dim4
                for i5=dim5
                    if length(Strwfs{i1,i2,i3,i4,i5})>1 & length(Strdataless{i1,i2,i3,i4,i5})>=18
                        % progress bar update %%%%%%%%%%%%%%%%%%%%%%%%%
                        message=['write stack wav:' num2str(i5) '/' num2str(d5) ' ch:' num2str(i4) '/' num2str(d4) ' sta:' num2str(i3) '/' num2str(d3) ' rec:' num2str(i1) '/' num2str(d1)];disp(message);
                        [direct,poub]=fileparts(Strdataless{i1,i2,i3,i4,i5}{14});
                        [poub,direct]=fileparts(direct);
                        system(['mkdir -p ' fullfile(path2clst,direct)]);
                        sacfilename = fullfile(fullfile(path2clst,direct),[prefix Strdataless{i1,i2,i3,i4,i5}{2} '_' Strdataless{i1,i2,i3,i4,i5}{3} '_' Strdataless{i1,i2,i3,i4,i5}{4} '_' Strdataless{i1,i2,i3,i4,i5}{5} exten]);
                        hdrfilename = fullfile(path2dtb,[Strdataless{i1,i2,i3,i4,i5}{2} '_' Strdataless{i1,i2,i3,i4,i5}{3} '_' Strdataless{i1,i2,i3,i4,i5}{4} '.mat' ]);
                        disp(['using ' hdrfilename ' in ' sacfilename]);
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % load basic headers                          %
                        load(hdrfilename) ;                           % => hdr
                        % form sac file                               %
                        [sacfile]=NNK_bsac(Strwfs{i1,i2,i3,i4,i5},Strdataless{i1,i2,i3,i4,i5},prefix,hdr);
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Magnitude                                   %
                        IMAGTYP = 5 ;                                 %
                        duree   = (Strdataless{i1,i2,i3,i4,i5}{18}-Strdataless{i1,i2,i3,i4,i5}{15})*date2ind;
                        MAG=[];if duree>0;MAG=mymagnitude('duree',duree);else;Mag=NaN;end
                        % F: Fini or end of event time (seconds relative to reference time.)
                        F    = (Strdataless{i1,i2,i3,i4,i5}{18} - Strdataless{i1,i2,i3,i4,i5}{6})*date2ind;
                        KF   = 'end     ';                            % A    Fini identification.
                        % P wave pick First arrival time (seconds relative to reference time.)
                        %disp([datestr(Strdataless{i1,i2,i3,i4,i5}{15}) '   -   ' datestr(Strdataless{i1,i2,i3,i4,i5}{6})])
                        A  = (Strdataless{i1,i2,i3,i4,i5}{15} - Strdataless{i1,i2,i3,i4,i5}{6})*date2ind;
                        WAtmp=1;
                        if length(Strdataless{i1,i2,i3,i4,i5}) >= 19
                            WAtmp =Strdataless{i1,i2,i3,i4,i5}{19} ;
                        end
                        if WAtmp<0.25;WA=1;end
                        WA=round((sum(abs(Strwfs{i1,i2,i3,i4,i5}(1:50)))/sum(abs(Strwfs{i1,i2,i3,i4,i5}(51:100))))*3);%WAtmp
                        if numel(WA)==0;WA=0;end;
                        WA(isnan(WA)==1)=0 ; WA(WA<0) = 0 ; WA(WA>3) = 3 ; 
                        WA=num2str(WA);
                        KA = ['P      ' WA] ;pol=0;                       %
                        if fix(A*Strdataless{i1,i2,i3,i4,i5}{7})>1;
                            pol=sum(diff(Strwfs{i1,i2,i3,i4,i5}(fix(A*Strdataless{i1,i2,i3,i4,i5}{7}):min([length(Strwfs{i1,i2,i3,i4,i5}) fix(A*Strdataless{i1,i2,i3,i4,i5}{7})+5]))));
                        end
                        if pol > 0;KA = ['PC     ' WA] ;elseif pol<0;KA = ['PD     ' WA] ;end% K    First arrival time identification.
                        % S waves                                     %
                        T1  = (Strdataless{i1,i2,i3,i4,i5}{16} - Strdataless{i1,i2,i3,i4,i5}{6})*date2ind;
                        KT1 = ['S      ' WA] ;T2=[];KT2='';               %
                        if length(Strdataless{i1,i2,i3,i4,i5}) >= 19  %
                            T1  = (Strdataless{i1,i2,i3,i4,i5}{16} - Strdataless{i1,i2,i3,i4,i5}{6})*date2ind;
                            KT1 = ['SE     ' WA] ;                         %
                            T2  = (Strdataless{i1,i2,i3,i4,i5}{16} - Strdataless{i1,i2,i3,i4,i5}{6})*date2ind;
                            KT2 = ['SN     ' WA] ;                         %
                        end                                           %
                        % C waves                                     %
                        T3  = (Strdataless{i1,i2,i3,i4,i5}{17} - Strdataless{i1,i2,i3,i4,i5}{6})*date2ind;
                        KT3 = 'Coda    ' ;                            %
                        % Output                                      %
                        if numel(MAG)>0;sacfile=ch(sacfile,'MAG',F,'IMAGTYP',IMAGTYP);end
                        if numel(F)>0  ;sacfile=ch(sacfile,'F',F,'KF',KF);end
                        if numel(A)>0  ;sacfile=ch(sacfile,'A',A,'KA',KA);end
                        if numel(T1)>0 ;sacfile=ch(sacfile,'T1',T1,'KT1',KT1);end
                        if numel(T2)>0 ;sacfile=ch(sacfile,'T2',T2,'KT2',KT2);end
                        if numel(T3)>0 ;sacfile=ch(sacfile,'T3',T3,'KT3',KT3);end
                        wsac(sacfilename,sacfile);                    %
                        done(size(done,1)+1,1:length(sacfilename))=sacfilename;
                    end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end
            end
        end
    end
    % pick file
    if exist('formatinp','var')==1 & length(direct) >0;
        [file] = makeinp(formatinp,['E' exten],fullfile(path2clst,direct));
        filename=fullfile(fullfile(path2clst,direct),[direct '.inp']) ;
        delete(filename);
        dlmwrite(filename,file,'-append','delimiter','','newline',mycomputer)
        disp([filename ' written']);
    end
end

