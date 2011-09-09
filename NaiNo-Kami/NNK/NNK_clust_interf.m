function [interf] = NNK_clust_interf(wind,Strwfs,dim4,dim3,dim2)

%                                             ,- window length
% Usage : [interf] = NNK_clust_interf(d,Strwfs,dim4,dim3,dim2)
%  cell interf-'             cell waveform-'    |    |    |     
%                                         Waves-'    |    '-stations
%                                                    '-components
%
% wf must be lined-up !



% parameter and arrays initiate %%%%%%%
if exist('cases','var')~=1 ; cases=2;end
if exist('dim1','var')~=1 ; dim1=1:size(Strwfs,1);end
if exist('dim2','var')~=1 ; dim2=1:size(Strwfs,2);end
if exist('dim3','var')~=1 ; dim3=1:size(Strwfs,3);end
if exist('dim4','var')~=1 ; dim4=[1 4 5];end
d1=length(dim1);
d2=length(dim2);
d3=length(dim3);
d4=length(dim4);
init1=zeros(d1,wind(1));
init2=zeros(d1,wind(2));
interf = cell(d1,d2,d3);
% progress bar initiate %%%%%%%%%%%%%%%
maxi=d4*d2*d3;progress_bar_position=0;tm=tic;count=0;


for i4=dim4
    for i3=dim3
        for i2=dim2
            % progress bar update %%%%%%%%%%%%%%%%%
            message=['Interfering phase ' num2str(i4) '/' num2str(d4) ' compo ' num2str(i3) '/' num2str(d3) ' station ' num2str(i2) '/' num2str(d2) ' on ' num2str(d1) ' events '];
            clc;
            count=count+1;[progress_bar_position] = textprogressbar(count,maxi,progress_bar_position,toc(tm),message);tm=tic;
            
            % Prepare %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            dinterf=wind(1);
            init0=init1;
            if i4==dim4(3)
                dinterf=wind(2);
                init0=init2;
            end          
            [X,Strwfs,cnt0]=cell2mat2(Strwfs,dim1,i2,i3,i4,dinterf,init0);
            X=X(:,1:dinterf);
            
            if cnt0 > 1
                % Interfero %%%%%%%%%%%%%%%%%%%%%%%%%%%
                for j=dim1
                    if sum(X(j,:)) > 0
                        interf{j,i2,i3}=NNK_interf(X(j,:),X,dinterf);
                        break
                    end
                end
                clear  X
            end
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