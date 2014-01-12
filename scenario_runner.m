% scenario runner
addpath(genpath('.'));
clc
clear
close all

% combinations:
% 1- simple HOC + Simple DIST + simple MU
% 2- gridding HOC overall (avg/wei) + simple DIST + simple MU
% 3- gridding HOC + gridding DIST (avg/wei) + simple MU
% 4- gridding HOC overall (avg/wei) + simple DIST + complex MU 
% 5- gridding HOC + gridding DIST (avg/wei) + complex MU


headers = {'HOC Bins' , 'Number of Bins', 'Gridding', 'Similarity Measure', 'Model Update', 'Intra Similarity', 'Inter Similarity' , 'Template Similarity' , 'Score'};
delimit = {'========' , '==============', '========', '==================', '============', '================', '================' , '===================' , '====='};

[~, ~, t] = xlsread('in.xlsx');
for i = 1:size(t,1)
    i
    gridding = t{i,3};
    if (isnan(gridding)),        gridding = '';    end;
    
    r = scenario1(t{i,1},gridding,t{i,6},t{i,4},t{i,5});
    
    t{i,6}=sprintf('%0.2f',r(1));
    t{i,7}=sprintf('%0.2f',r(2));
    t{i,8}=sprintf('%0.2f',r(3));
    t{i,9}=sprintf('%0.2f',r(4));
    
end
    
disp([headers;delimit;t])
xlswrite('out.xlsx',[headers;t])
close all

