function out = NNK_dtec_rms(in)

%%% Charge les parametres
NNK_dtec_takeparams ;   %
load NNK_dtec_params    %
%%%%%%%%%%%%%%%%%%%%%%%%%

dim = 1;
in = in' ; 
[indice] = NNK_dtec_divideid(fen,in) ;
lim = size(indice,2)-1 ;
%out = sqrt(
sum(in(indice(:,1:lim)',dim).^2)%/
size(in(indice(:,1:lim))',dim)
%) ; 
