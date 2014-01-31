function d = dist_match ( h1 , h2 )

y1 = cumsum(h1);
y2 = cumsum(h2);

d = sum(abs(y1-y2));
% d = d / length(h1); % to avoid normalization

end