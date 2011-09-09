function plot_goodgeotick(ax,in)

if exist('in','var') ==0 ; in =''; end
X='x';
Y='y';
Z='z';
if strcmp(in,'EW') == 1
    X='x';
    Y='z';
    Z='y';
elseif strcmp(in,'NS') == 1
    X='z';
    Y='y';
    Z='x';
end
[loclatlab,pas]=plot_tick(get(ax,[Y 'lim']),2);
[loclonlab,pas]=plot_tick(get(ax,[X 'lim']),2);
[locdeplab,pas]=plot_tick(get(ax,[Z 'lim']));

[latlab]=geo2str(loclatlab,'N','S');
[lonlab]=geo2str(loclonlab,'E','W');
[deplab]=num2str(locdeplab');

%lonlab = angl2str(loclonlab,'ew');
%latlab = angl2str(loclatlab,'ns');


set(ax,[X 'tick'],loclonlab,[X 'ticklabel'],{lonlab},...
    [Y 'tick'],loclatlab,[Y 'ticklabel'],{latlab},...
    [Z 'tick'],locdeplab,[Z 'ticklabel'],deplab);

eval([ Z 'label(''{\bf Depth [km]}'')' ])
eval([ X 'label('''')' ])
eval([ Y 'label('''')' ])


function [b]=geo2str(a,L1,L2)

b(1:length(a),1:2)=repmat(['°' L1],length(a),1) ; 
b(sign(a)==-1,2)=L2 ; 
a(sign(a)==-1)=a(sign(a)==-1)*(-1) ; 
b= [num2str(a') b];