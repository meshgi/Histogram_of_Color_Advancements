function d = dist_noticeable ( a , b )

% fa = a > mean(a) + std(a); % flag a
% fb = b > mean(b) + std(b);
% j = fa & fb; % joint
% 
% d = dist_l2(a(j) , b(j));
% 
% oa = fa & ~j;  % only a
% ob = fb & ~j;  
% 
% d = d + sum(a(oa).^2) + sum(b(ob).^2);


e = abs(a - b);
em = mean(e);
ev = std(e);

ef = e > em + 2*ev;
es = e(ef);
d = sum(es);