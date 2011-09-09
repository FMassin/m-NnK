function [h,l,occupation] = eclatball(ax,X,Y,Z,S,D,R,occupation,grideclat,diameter,vue,colored)

if sum(occupation) == length(occupation)
    occupation(:) = 0 ; 
end
if length(occupation) ~= size(grideclat,2)
    disp('bad dimension of occupation variable')
end
dist = [] ; 
indices = [] ; 
for i = 1 : length(occupation)
    if occupation(i) == 0
        
        if size(grideclat,1) == 2
            dist(length(dist)+1) = ((X - grideclat(1,i))^2 + (Y - grideclat(2,i))^2)^0.5 ;
        elseif size(grideclat,1) == 3
            dist(length(dist)+1) = ((X - grideclat(1,i))^2 + (Y - grideclat(2,i))^2)^0.5 ;
            eclatZ = Z ;
        end
        indices(length(indices)+1) = i ; 
        
    end
end

[a,b] = min(dist) ; 
ind = indices(b) ; 

eclat = [grideclat(1,ind) grideclat(2,ind) grideclat(3,ind)] ;

if size(grideclat,1) == 2
    [h] = drawball(diameter*1.5,eclat(1),eclat(2),eclat(3),S,D,R,vue,colored,ax) ;
    [l] = line([X eclat(1)],[Y eclat(2)],[Z eclat(3)],'Color','k','Parent',ax);
elseif size(grideclat,1) == 3
    [h] = drawball(diameter*1.5,eclat(1),eclat(2),eclatZ,S,D,R,vue,colored,ax) ;
    [l] = line([X eclat(1)],[Y eclat(2)],[Z eclatZ],'Color','k','Parent',ax);
end
occupation(ind) = 1 ; 










