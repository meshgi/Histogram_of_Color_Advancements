function d = dist_canberra ( a , b )
c = (a+b);

c(c==0) = 1; % both are zero

d = sum (abs(a-b)./c);

