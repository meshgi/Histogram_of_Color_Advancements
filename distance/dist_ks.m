function d = dist_ks ( h1 , h2 )

y1 = cumsum(h1);
y2 = cumsum(h2);

d = max(abs(y1-y2));

end