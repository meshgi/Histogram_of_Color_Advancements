function d = dist_kl ( h1 , h2 )

h1(h1==0) = eps;
h2(h2==0) = eps;

d = sum(log(h1./h2).*h1);