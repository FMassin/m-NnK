function [CCC,TS,Strwfs,Strdataless] = NNK_clust_corr(wind,Strwfs,cases,phases,Strdataless)

%                                           ,- window length
% Usage : [CCC,TS,Strwfs] = NNK_clust_corr(d,Strwfs,case,phases)
%  cell ccc-'   |   |            cell waveform-'            '- phases names    
%   cell shift--'   |                                          
%    enriched waves-'                                          
%
% t(ev1) = t(ev2)+TS(ev1,ev2)



% parameter and arrays initiate %%%%%%%
if exist('cases','var')~=1 ; cases=2;end
dim1=1:size(Strwfs,1);
dim2=1:size(Strwfs,2);
dim3=1:size(Strwfs,3);
dim4=1:size(Strwfs,4);
dim5=1:size(Strwfs,5);
d=wind(1);
d1=length(dim1);
d2=length(dim2);
d3=length(dim3);
d4=length(dim4);
d5=length(dim5);
pas=10;
init=zeros(d1);
init1=zeros(pas+1,d);
CCC = cell(d1,d2,d3,d4,d5);TS = CCC ;

[indice] = NNK_dtec_divideid(pas,d1);inds=size(indice,2);
maxim=length(indice);

% small dataset case %%%%%%%%%%%%%%%%%%
if cases == 2 
    indend = find(phases=='E');
    dstack=wind(2);
    maxim=1;
    init1=zeros(d1,d); 
    init=zeros(d1);
    init2=zeros(d1,dstack); 
    if numel(indend)>0;dim5=[1:indend-1 indend+1:size(Strwfs,5)];end
end

% progress bar initiate %%%%%%%%%%%%%%%
maxim=maxim*d2*d3*d4*d5;progress_bar_position=0;tm=tic;count=0;

for i5=dim5
	for i4=dim4
	    for i3=dim3
		for i2=dim2
		    if cases == 1 | (cases == 2 & d1 > 500)
			for i1=dim1
			    
			    % progress bar update %%%%%%%%%%%%%%%%%
			    message=['Correlating phase ' num2str(i5) '/' num2str(d5) ' compo ' num2str(i4) '/' num2str(d4) ' station ' num2str(i3) '/' num2str(d3) ' Event ' num2str(i1) '/' num2str(d1) ' '];
			    clc;count=count+1;[progress_bar_position] = textprogressbar(count,maxim,progress_bar_position,toc(tm),message);tm=tic;
			    T=init;C=init;
			    
			    if length(Strwfs{i1,i2,i3,i4,i5}) >= d
				for i11=1:inds                            
				    % Prepare %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
				    [X,Strwfs,cnt0]=cell2mat2(Strwfs,[i1 dim1(indice(1,i11)):dim1(indice(2,i11))],i2,i3,i4,i5,d,init1);
				    X=X(:,1:d);
				    
				    % Cross-correlate %%%%%%%%%%%%%%%%%%%%%
				    [CCCtmp,TStmp] = NNK_xcorr(X');
				    C(indice(1,i11):cnt0+indice(1,i11)-2) = CCCtmp(1,2:cnt0);
				    T(indice(1,i11):cnt0+indice(1,i11)-2) = TStmp(1,2:cnt0)-d;
				end
			    else disp(['MASTER warning length of ' num2str(i1) ' is ' num2str(length(Strwfs{i1,i2,i3,i4})) '/' num2str(d) ])
			    end                    
			    % Outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			    CCC(i1,i2,i3,i4,i5) = mat2cell(C(1:d1),1,d1) ;
			    TS(i1,i2,i3,i4,i5) = mat2cell(T(1:d1),1,d1) ;
			end               
			
		    else
			% progress bar update %%%%%%%%%%%%%%%%%
			%message=['Correlating phase ' num2str(i5) '/' num2str(d5) ' compo ' num2str(i4) '/' num2str(d4) ' station ' num2str(i3) '/' num2str(d3) ' on ' num2str(d1) ' events '];clc;
            count=count+1;%[progress_bar_position] = textprogressbar(count,maxim,progress_bar_position,toc(tm),message);tm=tic;

			% Prepare %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			dinterf=d;
			init0=init1;
			if strcmp(phases(i5),'C')==1 | strcmp(phases(i5),'E')==1 
			    dinterf=dstack;
			    init0=init2;
			end
			[X,Strwfs,cnt0]=cell2mat2(Strwfs,dim1,i2,i3,i4,i5,dinterf,init0);
			master=[] ;maxi=0;maxi2=0;begi=[];
                        for j=1:size(X,1);
                            test=sum(abs(X(j,:)));
                            if length(Strdataless{j,i2,i3,i4,i5})>=16 
                                if Strdataless{j,i2,i3,i4,i5}{16} > Strdataless{j,i2,i3,i4,i5}{15}
                                   test2=length(cell2mat(Strdataless{j,i2,i3,i4,i5}(15:16)));
                                else test2=1;end
                            else 
                                test2=0;
                            end
                            if test>0;
                               if numel(begi)==0;begi=j;master=j;end
                               if (test2>=maxi2 & test>maxi) | (maxi2==1 & test2==2)
                                  master=j;
                                  maxi=test;
                                  maxi2=test2;
                        end;end;end;
                        if begi>0 
                           Strwfs{max(dim1)+1,i2,i3,i4,i5}=X(begi,:)';
                           if exist('Strdataless','var')==1;Strdataless{max(dim1)+1,i2,i3,i4,i5}=Strdataless{begi,i2,i3,i4,i5};end
                        end

			if size(X(begi:end,:),1) > 1 & size(X(begi:end,:),2) > 1
			    X(:,end:dinterf) = 0 ; X=X(:,1:dinterf);
			    if cnt0 > 1
			        % Cross-correlate %%%%%%%%%%%%%%%%%%%%%
			        [CCCtmp,TStmp] = NNK_xcorr(X(begi:end,:)');
                                zero=zeros(size(X,1))  ;
                                zero(begi:end,begi:end)=CCCtmp ; CCCtmp=zero;
                                zero=zeros(size(X,1))+size(X,2)  ;
                                zero(begi:end,begi:end)=TStmp  ;  TStmp=zero;
			        % Line-up %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			        [X]=NNK_shift(X,TStmp(:,master),dinterf);
			        % Outputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			        for j=dim1
                        CCC{j,i2,i3,i4,i5} = CCCtmp(j,:) ;
                        TS{j,i2,i3,i4,i5}  = (TStmp(j,:)-dinterf)/(Strdataless{begi,i2,i3,i4,i5}{7}*60*60*24) ;
                        Strwfs{j,i2,i3,i4,i5} = X(j,:)';
                        if exist('Strdataless','var')==1;if numel(Strdataless{j,i2,i3,i4,i5})>=7;
                                Strdataless{j,i2,i3,i4,i5}{6}=Strdataless{j,i2,i3,i4,i5}{6}-(TStmp(j,master)-dinterf)/(Strdataless{j,i2,i3,i4,i5}{7}*60*60*24);
                                if numel(Strdataless{j,i2,i3,i4,i5})>=15
                                    Strdataless{j,i2,i3,i4,i5}{15}=Strdataless{j,i2,i3,i4,i5}{15}-(TStmp(j,master)-dinterf)/(Strdataless{j,i2,i3,i4,i5}{7}*60*60*24);
                                    if Strdataless{j,i2,i3,i4,i5}{16} > Strdataless{j,i2,i3,i4,i5}{6}
                                        Strdataless{j,i2,i3,i4,i5}{16}=Strdataless{j,i2,i3,i4,i5}{16}-(TStmp(j,master)-dinterf)/(Strdataless{j,i2,i3,i4,i5}{7}*60*60*24);
                                    else
                                        if length(Strdataless{master,i2,i3,i4,i5}) >=16 & length(Strdataless{j,i2,i3,i4,i5}) >=16
                                            Strdataless{j,i2,i3,i4,i5}{16} = Strdataless{j,i2,i3,i4,i5}{15}+(Strdataless{master,i2,i3,i4,i5}{16}-Strdataless{master,i2,i3,i4,i5}{15});
                                        end
                                    end
                                end
                            end;end
                    end
                    Strwfs{max(dim1)+1,i2,i3,i4,i5}=sum(X)';
                    if exist('Strdataless','var')==1;
                        Strdataless{max(dim1)+1,i2,i3,i4,i5}=Strdataless{master,i2,i3,i4,i5};
                        Strdataless{max(dim1)+1,i2,i3,i4,i5}{12}=['Stacked ' Strdataless{max(dim1)+1,i2,i3,i4,i5}{12}];
                        disp([num2str(max(dim1)+1) ' is stacked : ' char(Strdataless{max(dim1)+1,i2,i3,i4,i5}{12})])
                    end

                    % Stack %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			        if strcmp(phases(i5),'P')==1 & numel(indend)==1
			 	    [Xall]=cell2mat2(Strwfs,dim1,i2,i3,i4,indend,dstack,init2);
				    Xall=Xall(:,1:dstack);
                    [Xall]=NNK_shift(Xall,TStmp(:,1),d);
                    for j=dim1;
                        Strwfs{j,i2,i3,i4,indend}=Xall(j,:)';
                        if exist('Strdataless','var')==1;if length(Strdataless{j,i2,i3,i4,indend})>7;
                                Strdataless{j,i2,i3,i4,indend}{6}=Strdataless{j,i2,i3,i4,indend}{6}-(TStmp(j,master)-dinterf)/(Strdataless{j,i2,i3,i4,indend}{7}*60*60*24);
                                if length(Strdataless{j,i2,i3,i4,indend})>14;
                                    Strdataless{j,i2,i3,i4,indend}{15}=Strdataless{j,i2,i3,i4,indend}{15}-(TStmp(j,master)-dinterf)/(Strdataless{j,i2,i3,i4,indend}{7}*60*60*24);
                                    if Strdataless{j,i2,i3,i4,indend}{16} > Strdataless{j,i2,i3,i4,indend}{6}
                                        Strdataless{j,i2,i3,i4,indend}{16}=Strdataless{j,i2,i3,i4,indend}{16}-(TStmp(j,master)-dinterf)/(Strdataless{j,i2,i3,i4,indend}{7}*60*60*24);
                                    else
                                        if length(Strdataless{master,i2,i3,i4,indend}) >=16 & length(Strdataless{j,i2,i3,i4,indend}) >=16
                                            Strdataless{j,i2,i3,i4,indend}{16} = Strdataless{j,i2,i3,i4,indend}{15}+(Strdataless{master,i2,i3,i4,indend}{16}-Strdataless{master,i2,i3,i4,indend}{15});
                                        end
                                    end
                                    %Strdataless{j,i2,i3,i4,indend}{16}=Strdataless{j,i2,i3,i4,indend}{16}-(TStmp(j,master)-dinterf)/(Strdataless{j,i2,i3,i4,indend}{7}*60*60*24);
                                end
                                end;end
                    end
                    Strwfs{max(dim1)+1,i2,i3,i4,indend}=sum(Xall)';
                    if exist('Strdataless','var')==1;
                        Strdataless{max(dim1)+1,i2,i3,i4,indend}=Strdataless{master,i2,i3,i4,indend};
                        Strdataless{max(dim1)+1,i2,i3,i4,indend}{12}=['Stacked ' Strdataless{max(dim1)+1,i2,i3,i4,i5}{12}];
                        disp([num2str(max(dim1)+1) ' is stacked : ' char(Strdataless{max(dim1)+1,i2,i3,i4,indend}{12})])

                    end
                    %figure;hold on;plot(sum(X),'k','Linewidth',2);plot(X')
                    %figure;hold on;plot(sum(Xall),'k','Linewidth',2);plot(Xall')
                    end
                end
            end
            end
        end
	    end
	end
end
if exist('Strdataless','var')==0;Strdataless={};end
























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
