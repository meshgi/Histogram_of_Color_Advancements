function d = dist_quadratic ( h1 , h2 , M )

diff = abs(h1 - h2);
d = diff * M * diff';

end