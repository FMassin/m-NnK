function resizeeffect(fh,bar)

currentpos=get(fh,'Position');
pas=(bar(4)-currentpos(4))/1;

for i=currentpos(4):pas:bar(4)
    set(fh,'Position',[bar(1:3) i])
end