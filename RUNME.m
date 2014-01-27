% Similarities of one person, named Intra-object similarity, are calculated on
% consecutice frames of this subject. On the other side, similarities (here: dissimilarities)
% between different objects, named Inter-object similarity, are computed 
% on the subject images of the same frame.
% intra subject similarity r: obj1 g: obj2: b: obj3
% inter subject similarity k: obj1:obj2 m: obj2:obj3 c: obj1:obj3

addpath(genpath('.'));
clc
clear
close all

option_verbose = false;

obj_cnt = 3;
% =========================================================================

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

% =========================================================================

% hoc_update = 'none';
hoc_update = 'moving average';
% hoc_update = 'nerd';
% hoc_update = 'last 5';
% hoc_update = 'average all';
% hoc_update = 'update with memory';

% =========================================================================

% hoc_dist_name = 'L1';
% hoc_dist_name = 'L2';
% hoc_dist_name = 'Linf';
% hoc_dist_name = 'correlation';
% hoc_dist_name = 'chi-square';
% hoc_dist_name = 'intersection';
% hoc_dist_name = 'bhattacharyya';
% hoc_dist_name = 'kl-divergance';
% hoc_dist_name = 'diffusion';
% hoc_dist_name = 'match';
% hoc_dist_name = 'jeffry div';
% hoc_dist_name = 'kolmogorov smirnov';
% hoc_dist_name = 'cramer von mises';
hoc_dist_name = 'quadratic';
% hoc_dist_name = 'quadratic-chi';
% hoc_dist_name = 'emd';


% hoc_dist_name = 'L1,avg';
% hoc_dist_name = 'L2,avg';
% hoc_dist_name = 'Linf,avg';
% hoc_dist_name = 'correlation,avg';
% hoc_dist_name = 'chi-square,avg';
% hoc_dist_name = 'intersection,avg';
% hoc_dist_name = 'bhattacharyya,avg';
% hoc_dist_name = 'kl-divergance,avg';
% hoc_dist_name = 'diffusion,avg';
% hoc_dist_name = 'match,avg';
% hoc_dist_name = 'jeffry div,avg';
% hoc_dist_name = 'kolmogorov smirnov,avg';
% hoc_dist_name = 'cramer von mises,avg';
% hoc_dist_name = 'quadratic,avg';
% hoc_dist_name = 'quadratic-chi,avg';
% hoc_dist_name = 'emd,avg';

% hoc_dist_name = 'L1,wei';
% hoc_dist_name = 'L2,wei';
% hoc_dist_name = 'Linf,wei';
% hoc_dist_name = 'correlation,wei';
% hoc_dist_name = 'chi-square,wei';
% hoc_dist_name = 'intersection,wei';
% hoc_dist_name = 'bhattacharyya,wei';
% hoc_dist_name = 'kl-divergance,wei';
% hoc_dist_name = 'diffusion,wei';
% hoc_dist_name = 'match,wei';
% hoc_dist_name = 'jeffry div,wei';
% hoc_dist_name = 'kolmogorov smirnov,wei';
% hoc_dist_name = 'cramer von mises,wei';
% hoc_dist_name = 'quadratic,wei';
% hoc_dist_name = 'quadratic-chi,wei';
% hoc_dist_name = 'emd,wei';

% =========================================================================

% read all file names
disp('Loading Data...');
for i = 1:obj_cnt
    obj_img_list{i} = dir(['data/scenario 1/obj' num2str(i) '/*.jpg']);
    obj_msk_list{i} = dir(['data/scenario 1/obj' num2str(i) '/*.bmp']);
end
n = length(obj_img_list{1,1});

[ctrs,q] = hoc_init ( hoc_name , imread('data/scenario 1/frame_0455.jpg'), hoc_param);

for o = 1:obj_cnt
    disp (['Calculating HOC for Obj ' num2str(o)]);
    for i = 1:n
        img = imread(['data/scenario 1/obj' num2str(o) '/' obj_img_list{1,o}(i).name]);
        msk = imread(['data/scenario 1/obj' num2str(o) '/' obj_msk_list{1,o}(i).name]);

        r = fg_bg_ratio ( hoc_name , msk );
        h = hoc ( hoc_name , img , ctrs , r);
        
        frame_obj{i,o}.img = img;
        frame_obj{i,o}.msk = msk;
        frame_obj{i,o}.hoc = h;
        frame_obj{i,o}.rat = r;
    end
end
        


%% Intra Similarity
figure ('Name','Intra Similarity');
intra_sim = zeros(1,n-1);
for o = 1:obj_cnt 
    disp(['Obj' num2str(o) ' Intra Similarity Calculation.'] );
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        hoc2 = frame_obj{i-1,o}.hoc; % last frame
        
        cof1 = frame_obj{i,o}.rat; % this frame
        cof2 = frame_obj{i-1,o}.rat; % last frame
        
        % visualization of hoc differences
        if (option_verbose)
            clf;
            subplot (3,3,[1,2]); hist_vis (hoc1,ctrs);
            subplot (3,3,[4,5]); hist_vis (hoc2,ctrs);
            subplot (3,3,3);     imshow(frame_obj{i,o}.img);
            subplot (3,3,6);     imshow(frame_obj{i-1,o}.img);
            subplot (3,3,[7,8]);  bar (abs(hoc1-hoc2)); xlim([0 length(hoc1)]); ylim([0 0.2]); drawnow;
        end

        intra_sim (o,i-1) = hoc_similarity ( hoc_dist_name, hoc1, hoc2, cof1 , cof2 , q);
    end
%     plot (1:n-1 , intra_sim(o,:),colors{1,o},'LineWidth',2);
%     hold on
end
% hold off
clf
pl= plot (1:n-1 ,intra_sim(1,:) ,'r-',1:n-1 , intra_sim(2,:), 'g-',1:n-1 , intra_sim(3,:),'b-');
set(pl,'LineWidth',2);
legend ('obj1','obj2','obj3','Location', 'SouthEast');
xlim([1 n]);
ylim([0.9 1]);
drawnow;


%% Inter Similarity
figure ('Name','Inter Similarity');
inter_sim = zeros (obj_cnt,obj_cnt,n);
for o1 = 1:obj_cnt
    for o2 = o1+1:obj_cnt
        
        disp(['Obj' num2str(o1) ' and Obj' num2str(o2) ' Inter Similarity Calculation.'] );
        for i = 1:n    
            hoc1 = frame_obj{i,o1}.hoc; % obj 1
            hoc2 = frame_obj{i,o2}.hoc; % obj 2
            cof1 = frame_obj{i,o1}.rat; % obj 1
            cof2 = frame_obj{i,o2}.rat; % obj 2
            
            inter_sim (o1,o2,i) = hoc_similarity ( hoc_dist_name, hoc1, hoc2, cof1, cof2 , q);
            inter_sim (o2,o1,i) = inter_sim (o1,o2,i);
        end
    end
end

o1o2 = squeeze(inter_sim(1,2,:));
o2o3 = squeeze(inter_sim(2,3,:));
o1o3 = squeeze(inter_sim(1,3,:));

clf
pl= plot (1:n ,o1o2 ,'k-',1:n , o2o3, 'c-',1:n , o1o3,'m-');
set(pl,'LineWidth',2);
legend ('obj1-obj2','obj2-obj3','obj1-obj3','Location', 'SouthEast');
xlim([1 n+1]);
ylim([0.7 1]);
drawnow;

%% Template Matching
figure ('Name','Template Matching');
template_sim = zeros(1,n-1);
for o = 1:obj_cnt 
    hoc2 = frame_obj{1,o}.hoc; % template
    cof2 = frame_obj{1,o}.rat; % template
    
    disp(['Obj' num2str(o) ' Template Similarity Calculation.'] );
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        rat1 = frame_obj{i,o}.rat; % this frame
        
        % visualization of hoc differences
        if (option_verbose)
            clf;
            subplot (3,3,[1,2]); hist_vis (hoc1,ctrs);
            subplot (3,3,[4,5]); hist_vis (hoc2,ctrs);
            subplot (3,3,3);     imshow(frame_obj{i,o}.img);
            subplot (3,3,6);     imshow(frame_obj{1,o}.img);
            subplot (3,3,[7,8]);  bar (abs(hoc1-hoc2)); xlim([0 length(hoc1)]); ylim([0 0.2]); drawnow;
            drawnow;
        end

        template_sim (o,i-1) = hoc_similarity ( hoc_dist_name, hoc1, hoc2, cof1, cof2 , q);
    end
%     plot (1:n-1 , template_sim(o,:),colors{1,o},'LineWidth',2);
%     hold on
end
% hold off
clf
pl= plot (1:n-1 ,intra_sim(1,:) ,'r-',1:n-1 , template_sim(2,:), 'g-',1:n-1 , intra_sim(3,:),'b-');
set(pl,'LineWidth',2);
legend ('obj1','obj2','obj3','Location', 'SouthWest');
xlim([1 n]);
ylim([0.9 1]);
drawnow;

%% Template Matching with Model Update
figure ('Name','Template Matching with Update');
utemplate_sim = zeros(1,n-1);
for o = 1:obj_cnt 
    disp(['Obj' num2str(o) ' Updated Template Similarity Calculation.'] );
    hoc2 = frame_obj{1,o}.hoc; % template
    cof2 = frame_obj{1,o}.rat; % template
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        cof1 = frame_obj{i,o}.rat;
        hoc2 = template_update ( hoc_update , hoc2 , hoc1 , i );
        % visualization of hoc differences
        if (option_verbose)
            subplot (3,3,[1,2]); hist_vis (hoc1,ctrs);
            subplot (3,3,[4,5]); hist_vis (hoc2,ctrs);
            subplot (3,3,3);     imshow(frame_obj{i,o}.img);
            subplot (3,3,[7,8]);  bar (abs(hoc1-hoc2)); xlim([0 length(hoc1)]); ylim([0 0.2]); drawnow;
            drawnow;
        end

        utemplate_sim (o,i-1) = hoc_similarity ( hoc_dist_name, hoc1, hoc2 , cof1 , cof2 , q);
    end
%     plot (1:n-1 , intra_sim(o,:),colors{1,o},'LineWidth',2);
%     hold on
end
% hold off

clf
pl= plot (1:n-1 ,intra_sim(1,:) ,'r-',1:n-1 , utemplate_sim(2,:), 'g-',1:n-1 , intra_sim(3,:),'b-');
set(pl,'LineWidth',2);
legend ('obj1','obj2','obj3','Location', 'SouthWest');
xlim([1 n]);
ylim([0.9 1]);
drawnow;

%% Results
s1 = (sum(intra_sim')/n) * 100;
s2 = [sum(inter_sim(1,2,:)) sum(inter_sim(1,3,:)) sum(inter_sim(2,3,:))]/(n-1)*100;
s3 = sum(template_sim')/n*100;
s4 = sum(utemplate_sim')/n*100;

disp(' ');
disp(['Intra         ' mat2str(s1)]);
disp(['Inter         ' mat2str(s2)]);
disp(['Template      ' mat2str(s3)]);
disp(['Template(U)   ' mat2str(s4)]);


%% Total Results
s5(1) = mean(intra_sim(:)) * 100;   s5(2) = var(intra_sim(:)) * 100;
s6(1) = mean(s2);   s6(2) = var( [squeeze(inter_sim(1,2,:)) ; squeeze(inter_sim(1,3,:)) ; squeeze(inter_sim(2,3,:))])*100;
s7(1) = mean(s3);   s7(2) = var(template_sim(:))*100;
s8(1) = mean(s4);   s8(2) = var(utemplate_sim(:))*100;

disp(' ');
disp(['Total (mean/var) Intra         ' mat2str(s5)]);
disp(['Total (mean/var) Inter         ' mat2str(s6)]);
disp(['Total (mean/var) Template      ' mat2str(s7)]);
disp(['Total (mean/var) Template(U)   ' mat2str(s8)]);

s9 = sqrt(s5(1) * (100-s6(1)));
disp(['Score of This Combination sqrt(intra*(1-inter)):   '  num2str(s9)]);



