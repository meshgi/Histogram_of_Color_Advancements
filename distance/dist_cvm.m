function d = dist_cvm ( h1 , h2 )

y1 = cumsum(h1);
y2 = cumsum(h2);

d = sum((y1-y2).^2);
d = d/length(h1);