function [ticks,pas]=plot_tick(lims,in)

if exist('in','var')==0 ; in = 1 ; end

a=[0.0001 0.001 0.01 0.1 1 10 100 1000 10000 100000 1000000];
b=diff(lims)/5;
[val,ind]=min(abs(a-b));
pas=a(ind);
puissance = ind-5;
ticks=fix(lims(1)*10^(-1*puissance))/10^(-1*puissance):pas:lims(2);
if length(ticks)>10
    pas = pas*5;
    ticks=fix(lims(1)*10^(-1*puissance))/10^(-1*puissance):pas:lims(2);
end

if length(ticks)>2*in
    ticks=ticks(in:in:end);
    pas=pas*in ;
end