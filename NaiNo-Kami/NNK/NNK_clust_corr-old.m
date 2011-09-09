function [CCC,TS,Strwfs] = NNK_clust_corr(wind,Strwfs,cases,dim4,dim3,dim2)

%                                           ,- window length
% Usage : [CCC,TS,Strwfs] = NNK_clust_corr(d,Strwfs,case,dim4,dim3,dim2)
%  cell ccc-'   |   |            cell waveform-'            |    |    |     
%   cell shift--'   |                                 Waves-'    |    '-stations
%    enriched waves-'                                            '-components
%
% t(ev1) = t(ev2)+TS(ev1,ev2)



% parameter and arrays initiate %%%%%%%
if exist('cases','var')~=1 ; cases=2;end
if exist('dim1','var')~=1 ; dim1=1:size(Strwfs,1);end
if exist('dim2','var')~=1 ; dim2=1:size(Strwfs,2);end
if exist('dim3','var')~=1 ; dim3=1:size(Strwfs,3);end
if exist('dim4','var')~=1 ; dim4=[1 4 5];end

d=wind(1);
d1=length(dim1);
d2=length(dim2);
d3=length(dim3);
d4=length(dim4);

%d=length(Strwfs{1,1,1,1});
pas=10;
init=zeros(1,d1);
init1=zeros(pas+1,d);
CCC = cell(d1,d2,d3,d4);TS = CCC ;

[indice] = NNK_dtec_divideid(pas,d1);inds=size(indice,2);

% progress bar initiate %%%%%%%%%%%%%%%
maxi=d1*d2*d3*d4;progress_bar_position=0;tm=tic;count=0;

% small dataset case %%%%%%%%%%%%%%%%%%
if cases == 2 
    dstack=wind(2);
    maxi=d2*d3*d4;
    init1=zeros(d1,d); 
    init=zeros(d1);
    init2=zeros(d1,dstack);
end


for i4=dim4
    for i3=dim3
        for i2=dim2
            if cases == 1 | (cases == 2 & d1 > 500)
                for i1=dim1
                    
                    % progress bar update %%%%%%%%%%%%%%%%%                  
                    message=['Correlating phase ' num2str(i4) '/' num2str(d4) ' compo ' num2str(i3) '/' num2str(d3) ' station ' num2str(i2) '/' num2str(d2) ' Event ' num2str(i1) '/' num2str(d1) ' '];
                    clc;count=count+1;[progress_bar_position] = textprogressbar(count,maxi,progress_bar_position,toc(tm),message);tm=tic;
                    T=init;C=init;
                    
                    if length(Strwfs{i1,i2,i3,i4}) >= d
                        for i11=1:inds                            
                            % Prepare %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            [X,Strwfs,cnt0]=cell2mat2(Strwfs,[i1 dim1(indice(1,i11)):dim1(indice(2,i11))],i2,i3,i4,d,init1);
                            X=X(:,1:d);
                            
                            % Cross-correlate %%%%%%%%%%%%%%%%%%%%%
                            [CCCtmp,TStmp] = NNK_xcorr(X');
                            C(indice(1,i11):cnt0+indice(1,i11)-2) = CCCtmp(1,2:cnt0);
                            T(indice(1,i11):cnt0+indice(1,i11)-2) = TStmp(1,2:cnt0)-d;
                        end
                    else disp(['MASTER warning length of ' num2str(i1) ' is ' num2str(length(Strwfs{i1,i2,i3,i4})) '/' num2str(d) ])
                    end                    
                    % Outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    CCC(i1,i2,i3,i4) = mat2cell(C(1:d1),1,d1) ;
                    TS(i1,i2,i3,i4) = mat2cell(T(1:d1),1,d1) ;
                end               
                
            else
                % progress bar update %%%%%%%%%%%%%%%%%
                message=['Correlating phase ' num2str(i4) '/' num2str(d4) ' compo ' num2str(i3) '/' num2str(d3) ' station ' num2str(i2) '/' num2str(d2) ' on ' num2str(d1) ' events '];
                clc;
                count=count+1;[progress_bar_position] = textprogressbar(count,maxi,progress_bar_position,toc(tm),message);tm=tic;
                                 
                % Prepare %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                dinterf=d;
                init0=init1;
                if i4==dim4(3) 
                    dinterf=dstack;
                    init0=init2;
                end
                [X,Strwfs,cnt0]=cell2mat2(Strwfs,dim1,i2,i3,i4,dinterf,init0);
                X=X(:,1:dinterf);

                if cnt0 > 1
                    % Cross-correlate %%%%%%%%%%%%%%%%%%%%%
                    [CCCtmp,TStmp] = NNK_xcorr(X');
                    
                    % Line-up %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [X]=NNK_shift(X,TStmp(:,1),dinterf);
                    
                    % Outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    for j=dim1
                        CCC{j,i2,i3,i4} = CCCtmp(j,:) ;
                        TS{j,i2,i3,i4} = TStmp(j,:)-dinterf ;
                        Strwfs{j,i2,i3,i4}=X(j,:);                        
                    end
                    if i4 == dim4(1)
                        [Xall]=cell2mat2(Strwfs,dim1,i2,i3,6,dstack,init2);
                        Xall=Xall(:,1:dstack);
                        [Xall]=NNK_shift(Xall,TStmp(:,1),dinterf);
                        for j=dim1
                            Strwfs{j,i2,i3,6}=Xall(j,:);
                        end                        
%                         figure;hold on
%                         plot(sum(Xall),'k','Linewidth',2);plot(cell2mat(Strwfs(:,i2,i3,6))')                        
                    end
                end                         
            end            
%             % for test %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             figure('Position',[310 244 1164 471]);
%             ax(1)=subplot(1,2,1);
%             imagesc(cell2mat(CCC(:,i2,i3,i4)),'Parent',ax(1));colorbar;
%             ax(2)=subplot(1,2,2);
%             imagesc(cell2mat(TS(:,i2,i3,i4)),'Parent',ax(2));colorbar;drawnow
        end
    end
end


























% % % l54
% % X = cell2mat(Strwfs([i1 dim1(indice(1,i11)):dim1(indice(2,i11))],i2,i3,i4)) ;
% % cnt0=size(X,1);
% % if cnt0 ~= length([i1 dim1(indice(1,i11)):dim1(indice(2,i11))])
% %     X=init1;cnt=0;cnt0=0;
% %     for j=[i1 indice(1,i11):indice(2,i11)]
% %         cnt=cnt+1;
% %         if length(Strwfs{j,i2,i3,i4}) >= d
% %             cnt0=cnt;
% %             x=Strwfs{j,i2,i3,i4} ;
% %             X(cnt,1:d)= x(1:d) ;
% %         else
% %             Strwfs{j,i2,i3,i4}=init1(1,1:d);
% %             disp(['Slave warning length of ' num2str(j) ' is ' num2str(length(Strwfs{j,i2,i3,i4})) '/' num2str(d) ])
% %         end
% %     end
% % end

% % % l74
% % % X = cell2mat(Strwfs(:,i2,i3,i4)) ;
% % % cnt0=size(X,1);
% % % if cnt0 ~= d1
% % %     X=init1;cnt=0;cnt0=0;
% % %     for j=dim1
% % %         cnt=cnt+1;
% % %         if length(Strwfs{j,i2,i3,i4}) >= d
% % %             cnt0=cnt;
% % %             x=Strwfs{j,i2,i3,i4} ;
% % %             X(cnt,1:d)= x(1:d) ;
% % %         else
% % %             Strwfs{j,i2,i3,i4}=init1(1,1:d);
% % %             disp(['Slave warning length of ' num2str(j) ' is ' num2str(length(Strwfs{j,i2,i3,i4})) '/' num2str(d) ])
% % %         end
% % %     end
% % % end
