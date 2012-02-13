function [station,file,P,S,C,E,amP,amS,amC] = NNK_getmanualpick(pickimportcomand,file,sta)


pathtomanualinp = fileparts(file);
[poub,dirname] = fileparts(pathtomanualinp) ;
P = [] ;
amP = '  ' ;
S = [] ;
amS = '  ' ;
C = [] ;
amC = '  ' ;
E = [] ; 
station='';
file = fullfile(pathtomanualinp,[dirname '.p']); 
if exist(file,'file') == 2
    commande = [pickimportcomand ' ' file  ' ' sta ' all'];
    [a,b] = system(commande) ;
    %disp(commande);disp([sta ' | ' b(1:min([100 length(b)]))])
    %b='PD 100430183300 089.07 S  100430183300 000.00 C  100430183300 098.00 E  100430183300 247.07 YWB  YWB';
    %   1  4        13  17   22                40   45                63   68                86   91                  
    if numel(b) >= 20
        if str2num(b(17:22)) > 0
            P = datenum(b(4:13),'yymmddHHMM')+str2num(b(17:22))/(24*60*60) ;
            amP = b(1:2) ;
            station = b(93:95);
        end
        
        if str2num(b(40:45)) > 0
            S = datenum(b(4:13),'yymmddHHMM')+str2num(b(40:45))/(24*60*60) ;
            amS = b(1:2) ;
        end
        
        if str2num(b(63:68)) > 0
            C = datenum(b(4:13),'yymmddHHMM')+str2num(b(63:68))/(24*60*60) ;
            amC = b(1:2) ;
        end
        
        if str2num(b(86:91)) > 0
            E = datenum(b(4:13),'yymmddHHMM')+str2num(b(86:91))/(24*60*60) ;
        end
    end
end
[poubelle,file]=fileparts(file);