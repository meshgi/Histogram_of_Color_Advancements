% RUNME 2

% RUN the algorithm looking for template in different scales using sliding
% window (scales = x0.5 and x2), find the HOC and distance of all of them,
% and calculate the probability of the template itself, comparing to all
% other candidates
addpath(genpath('.'));
clc
clear
close all



hoc_name = 'conventional';  hoc_param = 5;
% hoc_name = 'clustering';  hoc_param = 40;
% hoc_name = 'conventional,g2,avg';  hoc_param = 5;
% hoc_name = 'clustering,g2,avg';  hoc_param = 40;
% hoc_name = 'conventional,g3,avg';  hoc_param = 5;
% hoc_name = 'clustering,g3,avg';  hoc_param = 40;
% hoc_name = 'conventional,g5,avg';  hoc_param = 5;
% hoc_name = 'clustering,g5,avg';  hoc_param = 40;
% hoc_name = 'conventional,g2,wei';  hoc_param = 5;
% hoc_name = 'clustering,g2,wei';  hoc_param = 40;
% hoc_name = 'conventional,g3,wei';  hoc_param = 5;
% hoc_name = 'clustering,g3,wei';  hoc_param = 40;
% hoc_name = 'conventional,g5,wei';  hoc_param = 5;
% hoc_name = 'clustering,g5,wei';  hoc_param = 40;
% hoc_name = 'conventional,g2';  hoc_param = 5;
% hoc_name = 'clustering,g2';  hoc_param = 40;
% hoc_name = 'conventional,g3';  hoc_param = 5;
% hoc_name = 'clustering,g3';  hoc_param = 40;
% hoc_name = 'conventional,g5';  hoc_param = 5;
% hoc_name = 'clustering,g5';  hoc_param = 40;

hoc_update = 'moving average';

% hoc_dist_name = 'L1';
% hoc_dist_name = 'L2';
% hoc_dist_name = 'correlation';
% hoc_dist_name = 'chi-square';
% hoc_dist_name = 'intersection';
hoc_dist_name = 'bhattacharyya';
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

dataset_name = 'bear_front';

%princeton datasets
[vid_param, directory, num_frames, ~, grt, ~]   = video_info(dataset_name);

%% Template Initialization
% making first teplate
[img, ~] =  read_frame(vid_param, directory, 1);
bb = grt(1:4,1)';

% HOC centers init
ctrs = hoc_init ( hoc_name , img , hoc_param);

% calculating template HOC
r = []; %fg_bg_ratio ( hoc_name , msk );
template_hoc = hoc ( hoc_name , bb_content(img,bb) , ctrs , r );
utemplate_hoc = template_hoc;

% creating all boxes
[bbs,ss_idx] = make_scaled_bbs ( bb(3) , bb(4) , size(img,1), size(img,2) );
n = ss_idx; %size(bbs,1); % DEBUG MODE

%% Calculating HOC
for fr = 2:num_frames
    tic
    [img, ~] =  read_frame(vid_param, directory, fr);
    bb = grt(1:4,fr)';
    r = [];
    % imshow(img); drawnow;
    
    for i = 1:n
        % [i, bbs(i,1)+bbs(i,3) , bbs(i,2)+bbs(i,4)] % DEBUG MODE
        hoc1 = hoc ( hoc_name , bb_content(img,bbs(i,:)) , ctrs , r );
        
        sim1(fr-1,i) = hoc_similarity ( hoc_dist_name, hoc1, template_hoc);
        sim2(fr-1,i) = hoc_similarity ( hoc_dist_name, hoc1, utemplate_hoc);
    end
    
    [~,rank1] = sort(sim1(fr-1,:)','descend');
    [~,rank2] = sort(sim2(fr-1,:)','descend');
    
    % find the ground truth box
    gt_x = floor(bb(1)/10)*10;
    gt_y = floor(bb(2)/10)*10;
    gt_idx = find(bbs(:,1) == gt_x & bbs(:,2) == gt_y,1,'first');
        
    % save values
    template_rank(fr-1) = rank1(gt_idx);
    utemplate_rank(fr-1) = rank2(gt_idx);
    
    % update template
    
    

    disp (['frame ' num2str(fr) ' takes ' num2str(toc) ' seconds']);
end

%% Showing Results

% sum(template_rank)/n
% sum(utemplate_rank)/n

% visualize boxes
fr = 4;

figure
[img, ~] =  read_frame(vid_param, directory, fr);
imshow(img); hold on;

min_sim = min(sim1(fr,:));
max_sim = max(sim1(fr,:));
for i = 1:n
    sim_p = sim1(fr,i);
    col_p = (sim_p - min_sim)/(max_sim - min_sim); % brighter = more similar
    col_pp = [col_p,col_p,col_p];
    rectangle('Position',bbs(i,:),'EdgeColor',col_pp);
end
hold off

% visualize similarity
fr = 4;

[img, ~] =  read_frame(vid_param, directory, fr);
bb = grt(1:4,fr)';

figure
imshow( zeros(size(img),'uint8') );   hold on;

min_sim = min(sim1(fr,:));
max_sim = max(sim1(fr,:));
for i = 1:n
    sim_p = sim1(fr,i);
    col_p = (sim_p - min_sim)/(max_sim - min_sim); % brighter = more similar
    col_pp = [col_p,col_p,col_p];
    rectangle('Position',bbs(i,:),'EdgeColor',col_pp,'FaceColor',col_pp);
end
hold off
% h = fspecial('gaussian');
% imshow( imfilter(gca,h));
