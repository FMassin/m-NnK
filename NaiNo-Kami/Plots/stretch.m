function stretch(a,scale,ORIGIN)

for i=1:length(a)
    
    t = get(a(i),'type');
    if strcmp(t,'patch')    % If patch, rotate vertices
        verts = get(a(i),'Vertices');  x = verts(:,1); y = verts(:,2);
        if size(verts,2)>2;      z = verts(:,3);
        else;                    z = [];
        end
    else % If surface or line, rotate {x,y,z}data
        x = get(a(i),'xdata');
        y = get(a(i),'ydata');
        z = get(a(i),'zdata');
    end
    if isempty(z)
        z = -ORIGIN(3)*ones(size(y));
    end
    [m,n] = size(z);
    if numel(x) < m*n
        [x,y] = meshgrid(x,y);
    end
    
    newx = ORIGIN(1)+((x-ORIGIN(1)).*scale(1));
    newy = ORIGIN(2)+((y-ORIGIN(2)).*scale(2));
    newz = ORIGIN(3)+((z-ORIGIN(3)).*scale(3));

    if strcmp(t,'surface') || strcmp(t,'line')
      set(a(i),'xdata',newx,'ydata',newy,'zdata',newz);
    elseif strcmp(t,'patch')
      set(a(i),'Vertices',[newx,newy,newz]); 
    elseif strcmp(t,'text')
      set(a(i),'position',[newx newy newz])
    elseif strcmp(t,'image')
      set(a(i),'xdata',newx,'ydata',newy)
    end
end

end




