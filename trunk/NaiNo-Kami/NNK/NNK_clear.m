function NNK_clear(pathtowfs,records)

for i = 1 : size(records,1)
    commande = [ 'rm -rf ' pathtowfs '/' liste(i,:)] ; 
    system(commande) ; 
%     disp(commande)
end