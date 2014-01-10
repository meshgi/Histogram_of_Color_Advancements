% scenario runner

% hoc_name = 'conventional';  hoc_param = 5;
% hoc_name = 'clustering';  hoc_param = 40;

% gridding = '';
% gridding = 'g2,avg';
% gridding = 'g3,avg';
% gridding = 'g5,avg';
% gridding = 'g2,wei';
% gridding = 'g3,wei';
% gridding = 'g5,wei';

% hoc_update = '';
% hoc_update = 'moving average';

% hoc_dist_name = 'L1';
% hoc_dist_name = 'L2';
hoc_dist_name = 'correlation';
% hoc_dist_name = 'chi-square';
% hoc_dist_name = 'intersection';
% hoc_dist_name = 'bhattacharyya';
% hoc_dist_name = 'kl-divergance';


% hoc_dist_name = 'L1,avg';
% hoc_dist_name = 'L2,avg';
% hoc_dist_name = 'correlation,avg';
% hoc_dist_name = 'chi-square,avg';
% hoc_dist_name = 'intersection,avg';
% hoc_dist_name = 'bhattacharyya,avg';
% hoc_dist_name = 'kl-divergance,avg';

% hoc_dist_name = 'L1,wei';
% hoc_dist_name = 'L2,wei';
% hoc_dist_name = 'correlation,wei';
% hoc_dist_name = 'chi-square,wei';
% hoc_dist_name = 'intersection,wei';
% hoc_dist_name = 'bhattacharyya,wei';
% hoc_dist_name = 'kl-divergance,wei';


% combinations:
% 1- simple HOC + Simple DIST + simple MU
% 2- gridding HOC overall (avg/wei) + simple DIST + simple MU
% 3- gridding HOC + gridding DIST (avg/wei) + simple MU
% 4- gridding HOC overall (avg/wei) + simple DIST + complex MU 
% 5- gridding HOC + gridding DIST (avg/wei) + complex MU
