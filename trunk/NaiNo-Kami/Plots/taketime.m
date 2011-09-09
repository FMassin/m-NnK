function [time,res,lims] = taketime

global fieldedit

if exist('plot_NNK.mat','file') == 2
    load plot_NNK.mat
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lesres = [6 8 10 12 14 16 18 20 22 24 ];
res = [] ;
if get(fieldedit(5),'Value')>1 ; res = [res lesres(get(fieldedit(5),'Value')-1)] ; end
if get(fieldedit(6),'Value')>1 ; res = [res lesres(get(fieldedit(6),'Value')-1)] ; end
if get(fieldedit(7),'Value')>1 ; res = [res lesres(get(fieldedit(7),'Value')-1)] ; end
if get(fieldedit(8),'Value')>1 ; res = [res lesres(get(fieldedit(8),'Value')-1)] ; end
if get(fieldedit(10),'Value')>1 ; res = [res lesres(get(fieldedit(10),'Value')-1)] ; end
if get(fieldedit(11),'Value')>1 ; res = [res lesres(get(fieldedit(11),'Value')-1)] ; end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lims = [str2num(get(fieldedit(12),'string')) str2num(get(fieldedit(13),'string'));...
    str2num(get(fieldedit(14),'string')) str2num(get(fieldedit(15),'string'));...
    str2num(get(fieldedit(16),'string')) str2num(get(fieldedit(17),'string'))];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lesincre = [1/(24*60) ; 1/(24) ; 1 ; 30.5] ;
entereddate = get(fieldedit(1),'String') ;
increment = lesincre(get(fieldedit(2),'Value'),:) ;
multi = str2num(get(fieldedit(3),'String')) ;

param(4) = datenum(entereddate(1:17),'yy/mm/dd HH:MM:SS');
param(5) = datenum(entereddate(1:17),'yy/mm/dd HH:MM:SS')+(increment*multi);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
entereddate = get(fieldedit(4),'String') ;

param(6) = datenum(entereddate(1:17),'yy/mm/dd HH:MM:SS');
param(7) = datenum(entereddate(1:17),'yy/mm/dd HH:MM:SS')+(increment*multi);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time = param(4:7) ; %datestr(param(4:7))

save plot_NNK.mat param  -append

for i=1:length(fieldedit)
    if fieldedit(i) >0
        strings{i} = get(fieldedit(i),'string');
    end
end
save strings.mat strings