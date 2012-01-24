function [XYZ,redorgreen,XYZinv]=get_goodplan(XYXred,XYXgreen,XYZyellow)

XYZ=[];redorgreen=[];XYZinv=[];

if size(XYXred,2)==3 & size(XYXgreen,2)==3 %& numel(XYZyellow)==numel(XYXgreen) & numel(XYZyellow)==numel(XYXred)
    for i=1:size(XYZyellow,1)
        rmsred(i)  = nanmin((sum(([ XYZyellow(i,1)-XYXred(:,1)   XYZyellow(i,2)-XYXred(:,2)    (XYZyellow(i,3)-XYXred(:,3))./110   ]).^2,2)).^0.5) ;
        rmsgreen(i)= nanmin((sum(([ XYZyellow(i,1)-XYXgreen(:,1) XYZyellow(i,2)-XYXgreen(:,2)  (XYZyellow(i,3)-XYXgreen(:,3))./110 ]).^2,2)).^0.5) ;
    end
    rmsred=nanmean(rmsred);
    rmsgreen=nanmean(rmsgreen);
    %[rmsred rmsgreen]
    
    if rmsred<rmsgreen
        redorgreen='1: red  ';
        XYZ=XYXred;
        XYZinv=XYXgreen;
    else
        redorgreen='2: green';
        XYZ=XYXgreen;
        XYZinv=XYXred;
    end
end