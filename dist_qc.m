function d = dist_qc ( h1 , h2 , A )
m = 0.5; %between zero and one

Z = (h1 + h2) * A;
% 1 can be any number as Z_i=0 iff D_i = 0
Z(Z==0) = 1;
Z = Z.^m;
D = (h1-h2)./Z;
d = sqrt(D*A*D');