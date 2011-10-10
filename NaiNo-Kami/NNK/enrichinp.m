function [file] = enrichinp(lesdir,lesinp,mycomputer) 

cnt=0;
memKSTNM='';
list=dir(lesdir);
list=char(list.name);
tmp1='';tmp2='';
for i=3:size(list,1)
    ledir=list(i,list(i,:)~=' ');
    ledir=fullfile(lesdir(lesdir~='*'),ledir);
    listinp=dir([ledir '/' lesinp(1,:)]);
    listinp=char(listinp.name);
    if numel(listinp)>0
       cnt=cnt+1;
       leinp=['/' listinp(1,listinp(1,:)~=' ')];
       tmp2(cnt,1:length(leinp))=leinp;
       tmp1(cnt,1:length(ledir))=ledir;
    end  
end
list=[tmp1 tmp2];
enriched(1:100,1:87,1:size(list,1))=' ';
for i=1:size(list,1)
    leinp=list(i,list(i,:)~=' ');
    [err,file]=system(['more ' leinp ]);
    file=reshape(file,88,size(file,2)/88)';
    file=file(:,1:87);
    for ii=1:size(file,1)-1
       KSTNM=file(ii,2:5);
       [indKSTNM ,memKSTNM] =findandupdate(memKSTNM ,KSTNM) ;
       enriched(indKSTNM,1:87,i)=file(ii,1:87);
    end
    lesnums(i)=size(file,1);
end
[val,ind]=sort(lesnums,'descend');
lesnums=ind;
enriched=enriched(1:size(memKSTNM,1),1:87,1:size(list,1));

for lay=1:size(enriched,3)
    %disp('the file :')
    %disp(enriched(:,:,lay))
    for lin=1:size(enriched,1)
        if str2num(enriched(lin,10:24,lay))>0
           
        else

           flagP=0;flagS=0;PP=10:24;SS=[10:19 32:36];Sec=[32:36];

           for reflay=lesnums(lesnums~=lay) %[1:lay-1 lay+1:size(enriched,3)]
               for reflin=[lin+1:size(enriched,1) 1:lin-1]

                  if flagP==0 & length(find(enriched(reflin,PP,lay)~=' '))==15 & ...
                     length(find(enriched(reflin,PP,reflay)~=' '))==15 & ...
                     length(find(enriched(lin,PP,reflay)~=' '))==15 

                     P = datenum(enriched(reflin,PP,lay),'yymmddHHMMSS.FFF')-(datenum(enriched(reflin,PP,reflay),'yymmddHHMMSS.FFF')-datenum(enriched(lin,PP,reflay),'yymmddHHMMSS.FFF'));
                     P = datestr(P,'yymmddHHMMSS.FFF');
                     enriched(lin,1:87,lay) = enriched(lin,1:87,reflay) ;
                     enriched(lin,max(PP)+1:87,lay) = ' ';
                     enriched(lin,PP,lay) = P(1:15);
                     flagP=1;
                  end

                  if flagS==0 & length(find(enriched(reflin,SS,lay)~=' '))==15 & ...
                     length(find(enriched(reflin,SS,reflay)~=' '))==15 & ...
                     length(find(enriched(lin,SS,reflay)~=' '))==15

                     S = datenum(enriched(reflin,SS,lay),'yymmddHHMMSS.FFF')-(datenum(enriched(reflin,SS,reflay),'yymmddHHMMSS.FFF')-datenum(enriched(lin,SS,reflay),'yymmddHHMMSS.FFF'));
                     minutmark = str2num(enriched(reflin,Sec,lay));
                     S = datestr(S,'yymmddHHMMSS.FFF');
                     enriched(lin,max(PP)+1:87,lay) = enriched(lin,max(PP)+1:87,reflay) ;
                     enriched(lin,Sec,lay) = S(11:15);
                     if minutmark >= 60;
                         tmp=num2str(str2num(enriched(lin,Sec(1),lay))+6);
                         enriched(lin,Sec(1),lay)=tmp(1);
                     end
                     flagS=1;
                  end 
                  if flagS==1 & flagP==1;break;end                 
               end
               if flagS==1 & flagP==1;break;end
           end
        end
    end
    %disp('has been enriched to :')
    %disp(enriched(:,:,lay))
    %disp('=====================================================================================')
end

test=repmat(' ',1,87);
for lay=1:size(enriched,3)
    event='';
    for lin=1:size(enriched,1)
        if strcmp(enriched(lin,1:87,lay),test)==0
           event=[event ; enriched(lin,1:87,lay)];
        end
    end
    if numel(event)>86
       event=[event ; '                 10                                                                    '];
       filename = [list(lay,list(lay,:)~=' ') '.enriched'];
       system(['rm -rf ' filename]);
       dlmwrite(filename,event,'-append','delimiter','','newline',mycomputer)
%       disp(event)
       disp([filename ' written']);
    end
end




