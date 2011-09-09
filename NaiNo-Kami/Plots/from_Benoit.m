function from_Benoit



clear all

sig=0.05;
lam=10;
mu=0.3;
alpha=0.5;

x=[1:500]/500.0;

f1=lam*exp(-lam*x);
f2=exp(-(x-mu).^2/(2*sig*sig))/(sig*sqrt(2*pi));
f3=alpha*f1+(1-alpha)*f2;


cumf1=(1-exp(-lam*x));
cumf2=0.5*(1+erf((x-mu)/(sig*sqrt(2))));
cumf3=alpha*cumf1+(1.0-alpha)*cumf2;



figure
subplot(3,2,1)
plot(x,f1)
subplot(3,2,3)
plot(x,f2)
subplot(3,2,5)
plot(x,f3)
subplot(3,2,2)
plot(x,cumf1)
subplot(3,2,4)
plot(x,cumf2)
subplot(3,2,6)
plot(x,cumf3)
figure
hold on
plot(x/max(x),cumf1/max(cumf1),'r','linewidth',1)
plot(x/max(x),cumf2/max(cumf2),'g','linewidth',1)
plot(x/max(x),cumf3/max(cumf3),'b','linewidth',1)