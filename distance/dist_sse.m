function d = dist_sse ( h1 , h2 )

d = sqrt(sum((h1-h2).^2));

end