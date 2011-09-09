function [volflux,temp,width,mat] = dimensioner(phi,theta)

g = 9.81;

% host rock temp %
t0 = 200 ;       % Waite 2002
% host rock density %
p0 = 2670 ;         % DeNosaquo2009108
% thermal diffusivity %
K = 1.5*10^(-6) ;     % Taisne 2011 
%%%%%%%%%%%%%%%%%%%%%%%

% Intrusion type %%%%%%%%%
mat = [' Rhyolite' ; ... % col 1
       '   Basalt' ; ... % col 2
       'Hyd fluid'];     % col 3
col = 'rbg';             % colors
% Intrusion solidus %%%%%%
ts = [870  950 400  ;... %
      750 1000 500] ;    % Farrel 2010 Waite 2002
% Intrusion density %%%%%%%%
pm = [2180 2650 1000  ;... %
      2250 2800 1100] ;    % Bottinga09011970 Taisne 2011
% Intrusion Young modulus %%%%%%%%%%%%%%%%%%%%%
E =  [[0.1*10^9 15*10^9 ; ...                  %
       5*10^9  20*10^9 ]  repmat(10^3,2,1)];  % Eurock 2002 (B R) Taisne 2011 (eau)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Intrusion geometry %
x=0.1 ;              % width [m] 
y=1000/(24*60*60) ;  % migration rate [m/s]
z=3500 ;             % height [m] 
%%%%%%%%%%%%%%%%%%%%%%





xlims1 = [] ; xlims2 = [] ; xlims3 = [] ; tmp1 = []; tmp2 = [] ; tmp3 = [] ; 
% figure;
% subplot(2,1,1);
% [AX,H1,H2] = plotyy(1,1,1,1,'semilogx','plot');
% subplot(2,1,2);
% [AX(3:4),H1,H2] = plotyy(1,1,1,1,'semilogx','semilogx');

for i=1:size(ts,2)

    volflux = [abs(min(phi)*(2*min(K)*min(E(:,i)))./(3*(max(pm(:,i))-p0)*g)) ; ...
        abs(max(phi)*(2*max(K)*max(E(:,i)))./(3*(min(pm(:,i))-p0)*g))] ; %Taisne 2011
    temp = abs(((ts(:,i)-t0)/theta)+t0) ;                %Taisne 2011
    width = volflux/(z*y) ;
        
    tmp1 = [tmp1 volflux] ;  
    tmp2 = [tmp2 temp] ;  
    tmp3 = [tmp3 width] ;
    
%     xlims3=[xlims3 ; width];
%     xlims2=[xlims2 ; temp];
%     xlims1=[xlims1 ; volflux];
%     
%     %%%%%%%%%%
%     rectangle('Position',[min(volflux) i abs(diff(volflux)) 0.5],'linewidth',2,'EdgeColor','k','FaceColor',col(i),'parent',AX(1))
%     rectangle('Position',[min(volflux) 1 abs(diff(volflux)) i-0.5],'linewidth',1,'linestyle',':','EdgeColor','k','parent',AX(1))
%     
%     rectangle('Position',[min(temp) i+0.5 abs(diff(temp)) 0.5],'linewidth',2,'EdgeColor','k','FaceColor',col(i),'parent',AX(2))
%     rectangle('Position',[min(temp) i+0.5 abs(diff(temp)) (1+size(ts,2))-(i+0.5)],'linewidth',1,'linestyle',':','EdgeColor','k','parent',AX(2))
%     
%     %%%%%%%%%%
%     rectangle('Position',[min(volflux) i abs(diff(volflux)) 0.5],'linewidth',2,'EdgeColor','k','FaceColor',col(i),'parent',AX(3))
%     rectangle('Position',[min(volflux) 1 abs(diff(volflux)) i-0.5],'linewidth',1,'linestyle',':','EdgeColor','k','parent',AX(3))
%     
%     rectangle('Position',[min(width) i+0.5 abs(diff(width)) 0.5],'linewidth',2,'EdgeColor','k','FaceColor',col(i),'parent',AX(4))
%     rectangle('Position',[min(width) i+0.5 abs(diff(width)) (1+size(ts,2))-(i+0.5)],'linewidth',1,'linestyle',':','EdgeColor','k','parent',AX(4))
%     
%     if i==1 ; axes(AX(1)) ; hold on ; axes(AX(2)); hold on ; axes(AX(3)); hold on ; axes(AX(4)); hold on ; end 
    
end
% xlims1 = [min(xlims1) max(xlims1)] ; 
% xlims2 = [min(xlims2) max(xlims2)] ; 
% xlims3 = [min(xlims3) max(xlims3)] ; 
% 
% xlims1 = [xlims1(1)-diff(xlims1)/10 xlims1(2)+diff(xlims1)/10] ;
% xlims2 = [xlims2(1)-diff(xlims2)/10 xlims2(2)+diff(xlims2)/10] ;
% xlims3 = [xlims3(1)-diff(xlims3)/10 xlims3(2)+diff(xlims3)/10] ;
% 
% linkaxes(AX(1:4),'y');
% axes(AX(1)) ; hold off ; ylim([1 i+1]);xlim(xlims1) ; box on ; 
% axes(AX(3)) ; hold off ; ylim([1 i+1]);xlim(xlims1) ; box on ; 
% axes(AX(2)) ; hold off ; xlim(xlims2) ; box on ; 
% axes(AX(4)) ; hold off ; xlim(xlims3) ; box on ; 
% 
% set(AX(2),'ytick',1.5:i+0.5,'yticklabel','','XAxisLocation','top','ygrid','on')
% set(AX(1),'ytick',1.5:i+0.5,'yticklabel',mat)
% set(AX(3),'ytick',1.5:i+0.5,'yticklabel',mat)
% set(AX(4),'ytick',1.5:i+0.5,'yticklabel','','XAxisLocation','top','ygrid','on')
% 
% set(get(AX(2),'Xlabel'),'String','Temperature [\circC]')
% set(get(AX(1),'Xlabel'),'String','Flux [m^3s^-^1]')
% set(get(AX(3),'Xlabel'),'String','Flux [m^3s^-^1]')
% set(get(AX(4),'Xlabel'),'String','Width [m]')

volflux = tmp1;
temp = tmp2 ;
width = tmp3;
plot_3Ddomains(volflux,temp,width)


% p1 = ;%intrusion density
% ts = ;%intrusion liquide phase phase temp
% t0 = ;%host rock temp
% 
% p0 = 2771 ;%host density
% E = 10^10 ;%Young?s modulus 
% K = 10^(-6) ;%is the thermal diffusivity
% mat = ['Andesite          ' ; ...
%        'Dacite            ' ; ...
%        'basalte           ' ; ...
%        'hydrothermal fluid'];

%http://www.usu.edu/geo/shervais/G4500_PDF/45Week1B_Magmas.pdf
%
% rhyolite basalte t
%http://www.minsocam.org/msa/collectors_corner/arc/tempmagmas.htm 
%
%hydro fluid 
%http://econgeol.geoscienceworld.org/cgi/reprint/103/5/877.pdf
%http://onlinelibrary.wiley.com/store/10.1111/j.1551-2916.2010.03772.x/asset/j.1551-2916.2010.03772.x.pdf?v=1&t=gk8r6fu8&s=9ce7e44be93f87e128f7ec5f32fe439e732bbd70
%
%young modulus :
%http://www.epito.bme.hu/eat/dolgozok/feltoltesek/vasarhelyib/eurock2002.pdf