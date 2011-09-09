function [M] = mymagnitude(in1,X1) ;

switch in1
    case 'duree'
        M = -0.9 + 2*log10(X1) ;
    case 'moment'
        M = -0.9 + 2*log10(X1) ;
        M = 1.5 * M + 10.73 ; 
end