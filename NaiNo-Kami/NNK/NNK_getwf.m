function [data,dataless,memKpath,memKEVNM,memKNETWK,memKSTNM,memKCMPNM,mempha]=NNK_getwf(demande,option,windows,filter,path2dtb)

% Usage :
% [data,dataless,memKEVNM,memKNETWK,memKSTNM,memKCMPNM]=NNK_getwf(demande,option,fen,filter);
%
% in: demande = { '/path/to/data/or/to/data/directories' 'date' 'station or *' 'component or *' 'P S C or *' } ;
%               '*' read continuous data
%               'P' read P waves if picked ('S' S-wave ; 'C' Coda)
%               'PSC' read P, S and Coda waves
%               'E' read from P to end
%      option = {'little-endian'|'big-endian' ; demean=1 ; filt=1 ; rms=1 ; spectro=1}
%         fen = {npt_window_rms npt_window_demean}
%      filter = {highpass lowpass nyquist 'bandpass'|'optionbutter' order};
%
% You have the possibility to write this parameter-array in a mat-file
% 'NNK_params.mat' in the worskspace and it will be used as default,
% without any inputs.
%
% out : data = cell(file|event|trigger,network,station,component,phase)
%   dataless = cell(file|event|trigger,network,station,component,phase){KEVNM ; KNETWK ; KSTNM ; KCMPNM ; phase ; zero1 ; 1/DELTA ; size(out,1)}
%
% The comand
% [data,dataless]=NNK_getwf;
% will read all sac file in your workspace AND its sub directories
%
% fred.massin@gmail.com
% YVO University of Utah 2010

% defaults %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sec2day=1/(24*60*60);maxnpts=0;minutes=1/(24*60):1/(24*60):1;cut='';P=[];S=[];C=[];E=[];
path='';eve='*';station='*';compo='Z';pha='*';logax=0;aliases='';
endian='big-endian';demean=0;filt=0;rms=0;spectro=0;psdfl=0;detrend=0;whit=0;onbit=0;fixmin=0;syncr=0;rminstr=0;

% load your eventual defaults %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('demande','var')>0 ;if numel(demande) >0;old=demande;end; end
if exist('NNK_params.mat','file')>0;load NNK_params.mat;end% PROPOSEZ DE RANGER LES DONNEES ;
if exist('old','var')==1;demande=old;end

if exist('path2dtb','var')==1; system(['mkdir -p ' fullfile(path2dtb,'stat')]) ;end

if exist('windows','var')==0;windows=[0 0 0];                 end
if exist('filter','var')==0 ;filter={2 15 50 'bandpass' 2};   end
if exist('netcode','var')==0;netcode='XX';                    end
if exist('demande','var')==0;demande={path ;eve ;station ;compo ;pha};  end
if exist('option','var')==0 ;option={endian ;demean ;filt ;rms ;spectro;psdfl};end

if iscell(demande)==0;demande={demande};    end
if iscell(option)==0;option={option};       end
if iscell(windows)==1;windows=cell2mat(windows);end
if iscell(filter)==0;filter={filter};       end

if length(demande)>=1	;path=demande{1};   end
if length(demande)>=2	;eve=demande{2};    end
if length(demande)>=3	;station=demande{3};end
if length(demande)>=4	;compo=demande{4};  end
if length(demande)>=5	;pha=demande{5};    end

if length(option)>=1    ;endian=option{1};  end
if length(option)>=2	;demean=option{2};  end
if length(option)>=3	;filt=option{3};    end
if length(option)>=4	;rms=option{4};     end
if length(option)>=5	;spectro=option{5}; end
if length(option)>=6	;psdfl=option{6};   end
if length(option)>=7	;detrend=option{7}; end
if length(option)>=8	;whit=option{8};    end
if length(option)>=9	;onbit=option{9};   end
if length(option)>=10	;fixmin=option{10}; end
if length(option)>=11	;syncr=option{11};  end
if length(option)>=12	;rminstr=option{12};end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% declare %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[B,A]=butter(filter{5},cell2mat(filter(1:2))/filter{3},filter{4}) ;
data=cell(1,1,size(station,1),size(compo,1));dataless=data;
memKNETWK='';memKSTNM ='';memKCMPNM='';memKEVNM ='';mempha='';memKpath='';
delete('test.txt');memi=[1:10];extensions={'.sac.linux' '.sac' '.SAC'};memx=[1:numel(extensions)];memm=1:4;F=0;

% list %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Search in');disp(path);disp(eve);disp(station);disp(compo);
for j=1:size(station,1);
    for jj=1:size(compo,1);
        for jjj=1:size(eve,1);
        level='';
            for i=memi; 
                level=repmat('/*',1,i-1);
                for x=memx;
                    motif=[ '*' eve(jjj,:)   '*' station(j,:) '*' compo(jj,:)  '*' extensions{x} ;...
                            '*' eve(jjj,:)   '*' compo(jj,:)  '*' station(j,:) '*' extensions{x} ;...
                            '*' station(j,:) '*' compo(jj,:)  '*' eve(jjj,:)   '*' extensions{x} ;...
                            '*' compo(jj,:)  '*' station(j,:) '*' eve(jjj,:)   '*' extensions{x} ];   
                    for m=memm
                        % % FOR UPGRADE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % % orphan in list
                        %test=['ls -dl ' fullfile(path,level) ' | grep drwxr | awk ''{print "ls "$8"/' motif(m,:) '"}'' | sh' ];
                        %[errorcode,poub]=system([ test ' >> test.txt']);
                        % %system('tail test.txt');
                        % % masters in list 
                        %test=['ls -dl ' fullfile(path2dtb,'clst',level) ' | grep drwxr | awk ''{print "ls "$8"/' motif(m,:) '"}'' | sh'];
                        %[errorcode,poub]=system([ test ' >> test.txt']);
                        % %system('tail test.txt');
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                        test= fullfile(path,level,motif(m,:));            
                        [errorcode,~]=system(['ls ' test ' >> test.txt']);%[~,test]=system('cat test.txt')
                        disp(['ls ' test ' >> test.txt 2> ' num2str(errorcode) ]);
                        if errorcode==0;
                            F=1;memi=i;memx=x;memm=m;break;
                        end
                    end;
                    if F==1;break;end
                end;
                if F==1;break;end
            end;
        end;
    end;
end
if exist('test.txt','file')==2
    c=dir('test.txt');
    if c.bytes > 0
        liste = importdata('test.txt');
        done='';
        % progress bar initiate %%%%%%%%%%%%%%%
        maxi=size(liste,1);progress_bar_position=0;etm=tic;count =0;
        
        % read %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:size(liste,1)
            file=liste{i,:};file=file(isspace(file)==0);
            testwhosfile=dir(file);
            testwhos = whos;
            test1 = testwhosfile.bytes;
            test2 = sum(cell2mat({testwhos.bytes}));
            if test1 < 2000000 & test2 < (11.8e+8-test1*10) & numel(findstr(done,file))==0  & numel(findstr(done,[file '-VEL']))==0 & exist(file,'file')==2
                if rminstr==1;
                   command = ['./NNK/make-RM-INSTR-macro.pl ' file ' ''' fullfile(path2dtb,'stat') '/SAC_PZs*'''];
                   if exist([file '-VEL'],'file')==2;disp(['rm-instr already done for ' file '-VEL'])
                   else;disp(command);system(command);end
                   file=[file '-VEL'];
                end

                % read data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                MEM=file(end-17:end-15);message=(['Reading ' file ' as :' MEM]);
                %if strfind(file,'clst') > 0 ; endian = 'little-endian' ; else ; endian = 'big-endian' ; end
                %/data/4Fred/WF/WY/clst/1993/11/01/19931101080430WY/YLA_Z_WY.sac.linux is a big-endian
                out = rsac(file,endian);
                
                if numel(out) > 100
                    % de-meane %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    out(:,2) = out(:,2) - mean(out(:,2));
                    
                    % read headers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [KEVNM,KNETWK,KSTNMEM,KCMPNM,NZYEAR,NZJDAY,NZHOUR,NZMIN,NZSEC,...
                        NZMSEC,NPTS,DELTA] = lh(out,'KEVNM','KNETWK','KSTNM',...
                        'KCMPNM','NZYEAR','NZJDAY','NZHOUR','NZMIN','NZSEC',...
                        'NZMSEC','NPTS','DELTA') ;
                    
                    % set pretty headers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    KNETWK=KNETWK(isspace(KNETWK)==0);
                    if strcmp(KNETWK,'-12345')==1|numel(KNETWK)==0;KNETWK=netcode;end
                    [a,b]=system(['./Utils/staname4NNK1.pl ' KSTNMEM ' 1 ' aliases]);message=[message '. ' KSTNMEM ' is aliased to ' b];
                    KSTNM=b ;%KSTNMEM;%MEM;
                    KSTNM =KSTNM( isspace(KSTNM) ==0);
                    if strcmp(KSTNM,'-12345')==1|numel(KSTNM)==0;warning(['Defined KSTNM field in ' file]);end
                    if KSTNM(end) == 'Z' | KSTNM(end) == 'z';KSTNM=KSTNM(1:end-1);end
                    if length(KSTNM)>3;if KSTNM(end)=='E' | KSTNM(end)=='N' | KSTNM(end)=='e' | KSTNM(end)=='n';KSTNM=KSTNM(1:end-1);end;end                    
                    KSTNMEM=KSTNMEM(isspace(KSTNMEM)==0);
                    if KSTNMEM(end) == 'Z' | KSTNMEM(end) == 'z';KSTNMEM=KSTNMEM(1:end-1);end
                    if length(KSTNMEM)>3;if KSTNMEM(end)=='E' | KSTNMEM(end)=='N' | KSTNMEM(end)=='e' | KSTNMEM(end)=='n';KSTNMEM=KSTNMEM(1:end-1);end;end                    
                    KCMPNM=KCMPNM(isspace(KCMPNM)==0);
                    if strcmp(KCMPNM,'-12345')==1|numel(KCMPNM)==0;warning(['Defined KCMPNM field in ' file]);end
                    if strcmp(KCMPNM,'UNKNOWN')==1|numel(KCMPNM)==0;KCMPNM='Z';end
                    if strcmp(KCMPNM,'VERTICAL')==1|numel(KCMPNM)==0;KCMPNM='Z';end
                    if strcmp(KCMPNM,'NORTH')==1;KCMPNM='N';end
                    if strcmp(KCMPNM,'EAST')==1;KCMPNM='E';end
                    
                    % transform data as you asked %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    leg=[KNETWK '-' KSTNM '-' KCMPNM '-* '];
                    if demean==1;   out(:,2)=out(:,2)-slidingmean(out(:,2),windows(2));
                        leg=[leg 'de-meaned, '];                             end
                    if detrend== 1; out(:,2)=out(:,2)-(mean(diff(out(:,2)))*[1:length(out(:,2))])';
                        leg=[leg 'de-trended, '];                            end
                    if filt== 1;    out = [out(:,1) filtfilt(B,A,out(:,2)) out(:,3) out(:,2)];
                        leg=[leg 'filtered, ' num2str(filter{1}) '< <' num2str(filter{2}) 'Hz '];end
                    if whit== 1;    out(:,2) = prewhit(out(:,2));
                        leg=[leg 'withening, '];                             end
                    if onbit== 1;   out(:,2) = onebit(out(:,2));
                        leg=[leg 'one bit, '];                               end
                    if rms==1;      [out,DELTA]=rmsac(out,windows(1:2));
                        leg=[leg 'RMS, ' num2str(DELTA) 's '];               end
                    if spectro==1;  [out,DELTA,logax]=spectrosac(out,DELTA,windows(3),0);
                        leg=[leg 'spectrogram, ' num2str(DELTA) 's '];       end
                    if spectro==2;  [out,DELTA,logax]=spectrosac(out,DELTA,windows(3),1);
                        leg=[leg 'spectrogram log, ' num2str(DELTA) 's '];   end
                    if psdfl==1;  [out]=psdsac(out,DELTA,windows(3));
                        leg=[leg 'psd, ' num2str(windows(3)*DELTA) 's '];    end
                    
                    % beginning time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    zero1 = addtodate(datenum(['00/00/' num2str(NZYEAR) ' 00:00']), NZJDAY,'day')+...
                        (NZHOUR/24)+(NZMIN/(24*60))+(NZSEC+out(1,1)+(NZMSEC/1000))/(24*60*60)  ;
                    
                    % cut to next minut
                    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if fixmin ==1
                        ind = fix(1+(min([minutes(minutes>(zero1-fix(zero1)))-(zero1-fix(zero1))])*8640000));
                        out = [out(ind:end,1:2) out(1:end-(ind-1),3)];
                    end
                    if numel(out) > 100
                        zero1 = addtodate(datenum(['00/00/' num2str(NZYEAR) ' 00:00']), NZJDAY,'day')+...
                            (NZHOUR/24)+(NZMIN/(24*60))+(NZSEC+out(1,1)+(NZMSEC/1000))/(24*60*60)  ;
                        
                        % Update event name %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        KEVNM=KEVNM( isspace(KEVNM) ==0);
                        if strcmp(KEVNM,'-12345')==1|numel(KEVNM)==0;KEVNM=datestr(zero1);end
                        KEVNM=datestr(zero1);
                        
                        
                        % set index %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        Kpath = fileparts(file);
                        if strcmp(pha,'*')==1 ;
                            [indpath  ,memKpath] =findandupdate(memKpath ,Kpath) ;
                            [indKEVNM ,memKEVNM] =findandupdate(memKEVNM ,KEVNM) ;
                            [indKNETWK,memKNETWK]=findandupdate(memKNETWK,KNETWK);
                            [indKSTNM ,memKSTNM] =findandupdate(memKSTNM ,KSTNM) ;
                            [indKCMPNM,memKCMPNM]=findandupdate(memKCMPNM,KCMPNM);
                            [indpha  ,mempha]   =findandupdate(mempha,pha);
                            
                            % synchronize all comp same sta %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            if syncr == 1 & strcmp(pha,'*')==1
                                [out,zero1] = NNK_alligncompo(dataless(indKEVNM,indKNETWK,indKSTNM,:,indpha),zero1,out,DELTA,maxnpts); 
                                leg=[leg ' synchronized'];
                            end
                            leg=[leg datestr(zero1)];
                            message=([message '. ' leg ' ' num2str(size(out,1)) ' points. Netw:' KNETWK '. Stat:' KSTNM '. Comp:' KCMPNM '. Event:' KEVNM ]) ;
                            
                        elseif find(pha=='P')>0 | find(pha=='S')>0 | find(pha=='C')>0 | find(pha=='E')>0 ;
                            % cut asked waves %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            [KSTA,filepick,WFP,WFS,WFC,WFE,cut,P,S,C,E,mes]=NNK_selectarrivals(out,fen,codafen,secutim,pathtoNNKdtec,pickimportcomand,file,KSTNMEM,zero1,DELTA,pha);
                            message=[message '. ' mes];
                            if length(cut)>0
                                % Update event name %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                KEVNM=datestr(datenum(filepick(1:14),'yyyymmddHHMMSS'));
                                %KSTNM=KSTA;
                                leg=[leg ' waves:' reshape(cut,1,numel(cut)) '.'];
                                [indpath  ,memKpath] =findandupdate(memKpath ,Kpath) ;
                                [indKEVNM ,memKEVNM] =findandupdate(memKEVNM ,KEVNM) ;
                                [indKNETWK,memKNETWK]=findandupdate(memKNETWK,KNETWK);
                                [indKSTNM ,memKSTNM] =findandupdate(memKSTNM ,KSTNM) ;
                                [indKCMPNM,memKCMPNM]=findandupdate(memKCMPNM,KCMPNM);
                                leg=[leg datestr(zero1)];
                                message=([ message '. ' leg ' ' num2str(size(out,1)) ' points. Netw:' KNETWK '. Stat:' KSTNM '. Comp:' KCMPNM '. Event:' KEVNM ]) ;
                            end
                        end
                            
                        % output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if strcmp(pha,'*')==1
                            dataless{indKEVNM,indKNETWK,indKSTNM,indKCMPNM,indpha} = ...
                                    {KEVNM ; KNETWK ; KSTNM ; KCMPNM ; pha(1) ; ...
                                    zero1 ; 1/DELTA ; size(out,1) ;...
                                    option ; windows ; filter ; leg ; logax ; file ; P ; S ; C ; E} ;
                            data{indKEVNM,indKNETWK,indKSTNM,indKCMPNM,indpha} = out(:,2:end);
                        end
                            
                        for ii=1:length(cut);if find(pha==cut(ii))>0
                                eval(['WF = WF' cut(ii) ';';]) ;wfleg = leg ; wfleg(wfleg=='*') = cut(ii) ;
                                [indpha,mempha]=findandupdate(mempha,cut(ii));
                                dataless{indKEVNM,indKNETWK,indKSTNM,indKCMPNM,indpha} = ...
                                    {KEVNM ; KNETWK ; KSTNM ; KCMPNM ; cut(ii) ; ...
                                    zero1+WF(1,1)/(24*60*60) ; 1/DELTA ; size(WF,1) ;...
                                    option ; windows ; filter ; wfleg ; logax ; file ; P ; S ; C ; E} ;
                                data{indKEVNM,indKNETWK,indKSTNM,indKCMPNM,indpha} = WF(:,2);
                        end;end
                        % save headers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if exist('path2dtb','var')==1;
                            savename =  fullfile(path2dtb,['stat/' KNETWK '_' KSTNM '_' KCMPNM '.mat']); 
                            if exist(savename,'file')~=2;hdr=out(:,end);save(savename,'hdr');end
                        end
                    end
                end
                done=[done file];                        
            end
            if maxi>=500;clc;[progress_bar_position]=textprogressbar(i,maxi,progress_bar_position,toc(etm),message);etm=tic;else disp(message);end
        end
            
        % Reduce (data & dataless have been declared with dummy dimensions) %%%%%%%
        %[i1,i2,i3,i4,i5]=size(data);disp(num2str([i1 i2 i3 i4 i5]));[i1,i2,i3,i4,i5]=size(dataless);disp(num2str([i1 i2 i3 i4 i5]));disp(num2str([size(memKEVNM,1) size(memKNETWK,1) size(memKSTNM,1) size(memKCMPNM,1) size(mempha,1)]));
        data=data(1:size(memKEVNM,1),1:size(memKNETWK,1),1:size(memKSTNM,1),1:size(memKCMPNM,1),1:size(mempha,1));
        dataless=dataless(1:size(memKEVNM,1),1:size(memKNETWK,1),1:size(memKSTNM,1),1:size(memKCMPNM,1),1:size(mempha,1));
    end
end
disp('============================LOADED============================')
[i1,i2,i3,i4,i5]=size(data);		disp(['struct     data : ' num2str([i1 i2 i3 i4 i5]) ' {rec*net*sta*cha*wav}(:,1) ']);
[i1,i2,i3,i4,i5]=size(dataless);	disp(['struct dataless : ' num2str([i1 i2 i3 i4 i5]) ' {rec*net*sta*cha*wav}{rec;net;sta;cha;wav;t0;fs;size;opt;fen;filt;leg;log;file;P;S;C;E}']);
if i1==1; error(['NNK did not read any data in inputed path:' path]);end







