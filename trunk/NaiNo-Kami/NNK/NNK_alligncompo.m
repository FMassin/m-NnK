function [out,zero1] = NNK_alligncompo(dalaless,zero1,out,DELTA,maxnpts) %Strwfs(indrec(i),indstat(i),:,1)

 
test=cell2mat(dalaless);
if size(test)>0 & numel(dalaless{1,1,1,1,1})>5
    zeroref = dalaless{1,1,1,1,1}(6) ;
    deb=fix((zeroref-zero1)*(24*60*60*1/DELTA));
    indout = [max([1 deb])  min([size(out,1) deb+maxnpts-1])] ; %maxnpts
    indwf(1) = max([deb*(-1) 1])  ;
    indwf(2) = indwf(1)+diff(indout) ;

    %                 disp(['Ref is :         ' datestr(zeroref,'yy/mm/dd HH:MM:SS.FFF') ])
    %                 disp([' and it start at ' datestr(zero1,'yy/mm/dd HH:MM:SS.FFF')])
    %                 disp(['the lag is : ' num2str(deb)])
    %
    %                 disp(['I take         [' num2str(indwf(1)) ' to ' num2str(indwf(2)) ']'])
    %                 disp(['and move it to [' num2str(indout(1)) ' to ' num2str(indout(2)) ']'])

    tmp=out(indout(1):indout(2),2)';
    out(:,2)=0;
    out(indwf(1):indwf(2),2) = tmp;
    zero1=zeroref;
end
out=[out ; zeros(maxnpts-size(out,1),size(out,2))];