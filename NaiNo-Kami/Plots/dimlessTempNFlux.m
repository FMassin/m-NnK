function [dimensionlessFlux,dimensionlessTemp]=dimlessTempNFlux(alph,mug,col)

% Help of function dimlessTempNFlux.m
%
% usage : [dimensionlessFlux,dimensionlessTemp]=dimlessTemp(alph,mug,col)
%          |_____[0 1]_____________[0 1]_____|          [0 1]-'   |   '-[0 0 0] optional 
%          | Intersection value(s) of dimen- |      mandatory   [0 1]   [1 1 1]         
%          | -sionless flux and temperature  |                mandatory
% 
%
% Read Taisne and Tait "The effect of solidication on a propagating dike"
% JOURNAL OF GEOPHYSICAL RESEARCH 2010
%
% inputs : alph (\alpha) - vector - "can be seen as a proportion of values 
%                           between the dike being halted and undergoing
%                           propagation"
%          mug  (\mu)    - vector - "corresponds to the normalized mean 
%                           surface creation rate during propagation events"
%
% Plot the range of dimensionless temperature as a function of
% dimensionless flux, for the inputed values of "alph" and "mug". Color of
% plot are set automatically but can be inputed in "col". 
%
% Use function polyxpoly to compute intersection of temperature and flux
% domains. Output intersection values of dimensionless flux and
% temperature. Intersection values are indicated both in the plot and in its
% legend.
%
% If "alph" and "mug" are vector with length > 1, several plot are created
% with colors defined in matrix "col". Also, vectors of length=length(alph) 
% are ouputed for dimensionlessFlux and dimensionlessTemp.
%
% Just hit "figure;dimlessTempNFlux;"
% to have a beautiful and dummy example.
%
% fred.massin@gmail.com 2010

if exist('alph','var')==0;disp('Dummy automatic inputs are :');disp('                 mug   alph');end
if exist('alph','var')==0;alph=linspace(0.1,0.9,10);end
if exist('mug','var')==0;mug=linspace(0.1,0.3,10);disp([mug' alph']);end
if exist('col','var')==0;col=rand(length(alph),3);end



dimlessFlux=logspace(log10(0.001),log10(100),40);
cnt = 0 ; 
gca;
hold on
for ii=1:length(alph)
    cnt=cnt+1 ; 
    dimlessTemp_mug=1-(mug(ii).^(dimlessFlux./0.824));
    dimlessTemp_alpha=alph(ii).^(1./(dimlessFlux.*5.36));
    
    [test1,test2] = polyxpoly(dimlessFlux,dimlessTemp_mug,dimlessFlux,dimlessTemp_alpha);    
    if numel(test1)>0 ; 
        dimensionlessFlux(1,ii)=test1(end);
        dimensionlessTemp(1,ii)=test2(end);
    else
        dimensionlessFlux=nan;
        dimensionlessTemp=nan;
    end


    h(cnt) = semilogx(dimlessFlux,dimlessTemp_mug,'--','color',col(ii,:),'LineWidth',2) ;
    h(cnt+1) = semilogx(dimlessFlux,dimlessTemp_alpha,'-','color',col(ii,:),'LineWidth',2) ;
    h(cnt+2) = semilogx([0.001 dimensionlessFlux(end) dimensionlessFlux(end)],[dimensionlessTemp(end) dimensionlessTemp(end) 0],':','color',col(ii,:));

    test=['\Theta=f(\Phi,\mu) & \mu=' num2str(mug(ii))];forlegend(cnt,1:length(test))=test;
    test=['\Theta=f(\Phi,\alpha) & \alpha=' num2str(alph(ii))];forlegend(cnt+1,1:length(test))=test;
    test=['\Theta=' num2str(dimensionlessTemp(end)) ' & \Phi=' num2str(dimensionlessFlux(end))];forlegend(cnt+2,1:length(test))=test;
    cnt=cnt+2;
    
end
semilogx(dimensionlessFlux,dimensionlessTemp,'xk','markersize',10,'LineWidth',2);
hold off
legend(h,forlegend,'Location','West')
xlabel('Dimensionless flux, \Phi');ylabel('Dimensionless temperature, \Theta')
box on ;set(gca,'XScale','log','YScale','linear','ylim',[0 1],'xlim',[min(dimlessFlux) max(dimlessFlux)])
%grid on;

disp(['           The dimensionless Flux, \Phi   = ' num2str(dimensionlessFlux) ])
disp(['and the dimensionless Temperature, \Theta = ' num2str(dimensionlessTemp) ])

