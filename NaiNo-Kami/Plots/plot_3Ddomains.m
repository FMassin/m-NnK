function plot_3Ddomains(X,Y,Z)

col='rgbykcm';
figure
for i=1:size(X,2)
    vertex = [] ;
    faces = [1 2 6 5 ; ...
             2 4 8 6 ; ...
             4 3 7 8 ; ...
             3 1 5 7 ; ...
             5 6 8 7 ; ...
             1 2 4 3 ] ;
    for z=reshape(Z(:,i),1,2)
        for y=reshape(Y(:,i),1,2)
            for x=reshape(X(:,i),1,2)
                vertex=[vertex ; x y z];
            end
        end
    end
    p(:,i)=patch('Vertices',vertex,'Faces',faces,'FaceColor',col(i));
end

Xlabel('Flux [m^3s^-^1]')
Ylabel('Temperature [\circC]')
Zlabel('Width [m]')
set(gca,'XScale','log', 'YScale','log', 'ZScale','log')
box on
grid on
b(1,1:2) = get(gca,'xlim') ; 
b(2,1:2) = get(gca,'ylim') ; 
b(3,1:2) = get(gca,'zlim') ; 

for i=1:size(X,2)
    vertex = [] ;
    faces = [1 2 6 5 ; ...
             2 4 8 6 ; ...
             4 3 7 8 ; ...
             3 1 5 7 ; ...
             5 6 8 7 ; ...
             1 2 4 3 ] ;
    for z=[b(3,1) Z(2,i)]
        for y=reshape(Y(:,i),1,2)
            for x=reshape(X(:,i),1,2)
                vertex=[vertex ; x y z];
            end
        end
    end
    p(:,i)=patch('Vertices',vertex,'Faces',faces,'FaceColor','none','LineStyle',':','EdgeColor', col(i),'linewidth',2);
    vertex = [] ;
    for z=reshape(Z(:,i),1,2)
        for y=[b(2,1) Y(2,i)]
            for x=reshape(X(:,i),1,2)
                vertex=[vertex ; x y z];
            end
        end
    end
    p(:,i)=patch('Vertices',vertex,'Faces',faces,'FaceColor','none','LineStyle',':','EdgeColor', col(i),'linewidth',2);
    vertex = [] ;
    for z=reshape(Z(:,i),1,2)
        for y=reshape(Y(:,i),1,2)
            for x=[b(1,1) X(2,i)]
                vertex=[vertex ; x y z];
            end
        end
    end
    p(:,i)=patch('Vertices',vertex,'Faces',faces,'FaceColor','none','LineStyle',':','EdgeColor', col(i),'linewidth',2);
end
axis tight

