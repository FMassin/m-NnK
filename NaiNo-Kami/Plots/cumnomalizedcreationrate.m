function [Ycalc,leg,a,l,m,o,Xobs] = cumnomalizedcreationrate(Xobs,a,l,m,o)

maxi = max([length(a) length(l) length(m) length(o)]) ;

a = reshape(a,1,length(a));
l = reshape(l,1,length(l));
m = reshape(m,1,length(m));
o = reshape(o,1,length(o));
Xobs = reshape(Xobs,length(Xobs),1);

a(end:maxi) = a(end) ; 
l(end:maxi) = l(end) ; 
m(end:maxi) = m(end) ; 
o(end:maxi) = o(end) ; 

a = repmat(a,length(Xobs),1);
l = repmat(l,length(Xobs),1);
m = repmat(m,length(Xobs),1);
o = repmat(o,length(Xobs),1);
Xobs = repmat(Xobs,1,size(a,2));

leg=[repmat('\alpha=',size(a,2),1)  num2str(a(1,:)') ...
     repmat(' \mu=',size(a,2),1)     num2str(m(1,:)') ...
     repmat(' \lambda=',size(a,2),1) num2str(l(1,:)') ...
     repmat(' \sigma=',size(a,2),1)  num2str(o(1,:)') ];

Ycalc = a.*(1-exp(-l.*Xobs)) + (1.0-a).*0.5.*(1+erf((Xobs-m)./(o*sqrt(2)))) ;

if nargout == 0
    figure
    h=plot(Xobs,Ycalc);
    legend(h,leg) ; 
    box on
    grid on
    axis equal
    axis([0 1 0 1])    
end

a = a(1,:);
l = l(1,:);
m = m(1,:);
o = o(1,:);