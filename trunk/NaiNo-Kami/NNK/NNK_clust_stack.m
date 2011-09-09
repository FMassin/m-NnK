function [stacks] = NNK_clust_stack(wind,Strwfs,dim4,dim3,dim2)

%                                             ,- window length
% Usage : [stacks] = NNK_clust_interf(d,Strwfs,dim4,dim3,dim2)
%  cell stacks-'             cell waveform-'    |    |    |     
%                                         Waves-'    |    '-stations
%                                                    '-components
%
% wf must be lined-up !



% parameter and arrays initiate %%%%%%%
if exist('cases','var')~=1 ; cases=2;end
if exist('dim1','var')~=1 ; dim1=1:size(Strwfs,1);end
if exist('dim2','var')~=1 ; dim2=1:size(Strwfs,2);end
if exist('dim3','var')~=1 ; dim3=1:size(Strwfs,3);end
if exist('dim4','var')~=1 ; dim4=[1 4 5 6];end
d1=length(dim1);
d2=length(dim2);
d3=length(dim3);
d4=length(dim4);
init1=zeros(d1,wind(1));
init2=zeros(d1,wind(2));
stacks = cell(1,d2,d3,d4);
% progress bar initiate %%%%%%%%%%%%%%%
maxi=d4*d2*d3;progress_bar_position=0;tm=tic;count=0;


for i4=dim4
    for i3=dim3
        for i2=dim2
            % progress bar update %%%%%%%%%%%%%%%%%
            message=['Stacking phase ' num2str(i4) '/' num2str(d4) ' compo ' num2str(i3) '/' num2str(d3) ' station ' num2str(i2) '/' num2str(d2) ' on ' num2str(d1) ' events '];
            clc;
            count=count+1;[progress_bar_position] = textprogressbar(count,maxi,progress_bar_position,toc(tm),message);tm=tic;
            
            % Prepare %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            dinterf=wind(1);
            init0=init1;
            if i4==dim4(3) | i4==dim4(4)
                dinterf=wind(2);
                init0=init2;
            end
            [X,Strwfs,cnt0]=cell2mat2(Strwfs,dim1,i2,i3,i4,dinterf,init0);
            X=X(:,1:dinterf);
            
            if cnt0 > 1
                % stacks %%%%%%%%%%%%%%%%%%%%%%%%%%%
                stacks{1,i2,i3,i4}=sum(X);                        
                clear  X
            end
        end
    end
end


