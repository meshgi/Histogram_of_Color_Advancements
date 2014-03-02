function [boxes,gt_idx] = sliding_window (SZ, sz , f)

if ( f < 1 )
    % overlap mode
    interval_x = floor(sz(3) * f);
    interval_y = floor(sz(4) * f);
else
    % pixel-wise intervals
    interval_x = f;
    interval_y = f;
end

range_x = 1:interval_x:SZ(2)-sz(3)-1;
range_y = 1:interval_y:SZ(1)-sz(4)-1;

[x,y] = meshgrid(range_x,range_y);

o = ones(size(x));

boxes = [x(:),y(:),sz(3)*o(:),sz(4)*o(:)];

gt_x = sz(1) - mod(sz(1)-1,interval_x);
gt_y = sz(2) - mod(sz(2)-1,interval_y);

gt_idx = find(boxes(:,1) == gt_x & boxes(:,2) == gt_y);
