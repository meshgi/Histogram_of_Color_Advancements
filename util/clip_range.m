function y = clip_range (x , r)

% r = [min max]
y = max(x,r(1));
y = min(x,r(2)); 