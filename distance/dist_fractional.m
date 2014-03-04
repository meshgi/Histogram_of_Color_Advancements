function d = dist_fractional ( a , b , p )

diff = abs(a-b);
diff_p = diff .^ p;
diff_s = sum (diff_p);

d = diff_s^(1/p);