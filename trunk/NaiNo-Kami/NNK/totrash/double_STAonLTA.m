function  [OUT,peaks] = double_STAonLTA(OUT,fen,ordre,decim,chan)

if exist('fen','var') == 0 ; fen = 84 ; ordre = 3; decim = 2 ; end
% figure ; hold on ; plot(0.5+OUT/(2*max(max(abs(OUT)))),'-k') ; 

amplZ = slidingmean(OUT,fix(fen/40)) ;
OUT = resample(OUT,1,decim) ; 
OUT = (OUT - repmat(mean(OUT),size(OUT,1),1)).^2 ; 
for i = 1 : min([ordre size(OUT,1)])
    OUT = slidingmean(OUT,fen)./repmat(mean(OUT),size(OUT,1),1) ;
end
OUT = abs(diff(OUT)) ; 
OUT = resample(OUT,decim,1) ;

% plot(OUT,'r')
condfind = 8*mean(mean(OUT));
seuiltps = 400 ;
lrg = 50 ; 
[peaks] = NNK_peakedit(OUT,amplZ,condfind,chan,lrg,seuiltps) ;



% if ~isempty(peaks)
%     plot(peaks(:,1),peaks(:,2),'sr')
% end





