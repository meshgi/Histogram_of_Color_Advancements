function s = scenario1 (hoc_name,gridding,hoc_param,hoc_dist_name,hoc_update)

hoc_name = [hoc_name gridding];
obj_cnt = 3;

% read all file names
for i = 1:obj_cnt
    obj_img_list{i} = dir(['data/scenario 1/obj' num2str(i) '/*.jpg']);
    obj_msk_list{i} = dir(['data/scenario 1/obj' num2str(i) '/*.bmp']);
end
n = length(obj_img_list{1,1});

% ctrs = hoc_init ( hoc_name , imread('data/scenario 1/frame_0455.jpg'), hoc_param);
load ('ctrs.mat');

for o = 1:obj_cnt
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
intra_sim = zeros(1,n-1);
for o = 1:obj_cnt 
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        hoc2 = frame_obj{i-1,o}.hoc; % last frame
        
        cof1 = frame_obj{i,o}.rat; % this frame
        cof2 = frame_obj{i-1,o}.rat; % last frame
        
        intra_sim (o,i-1) = hoc_similarity ( hoc_dist_name, hoc1, hoc2, cof1 , cof2);
    end
end


%% Inter Similarity
inter_sim = zeros (obj_cnt,obj_cnt,n);
for o1 = 1:obj_cnt
    for o2 = o1+1:obj_cnt
        
        for i = 1:n    
            hoc1 = frame_obj{i,o1}.hoc; % obj 1
            hoc2 = frame_obj{i,o2}.hoc; % obj 2
            cof1 = frame_obj{i,o1}.rat; % obj 1
            cof2 = frame_obj{i,o2}.rat; % obj 2
            
            inter_sim (o1,o2,i) = hoc_similarity ( hoc_dist_name, hoc1, hoc2, cof1, cof2);
            inter_sim (o2,o1,i) = inter_sim (o1,o2,i);
        end
    end
end

o1o2 = squeeze(inter_sim(1,2,:));
o2o3 = squeeze(inter_sim(2,3,:));
o1o3 = squeeze(inter_sim(1,3,:));


%% Template Matching
template_sim = zeros(1,n-1);
for o = 1:obj_cnt 
    hoc2 = frame_obj{1,o}.hoc; % template
    cof2 = frame_obj{1,o}.rat; % template
    
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        rat1 = frame_obj{i,o}.rat; % this frame
        
        template_sim (o,i-1) = hoc_similarity ( hoc_dist_name, hoc1, hoc2, cof1, cof2);
    end
end

%% Template Matching with Model Update
utemplate_sim = zeros(1,n-1);
for o = 1:obj_cnt 

    hoc2 = frame_obj{1,o}.hoc; % template
    cof2 = frame_obj{1,o}.rat; % template
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        cof1 = frame_obj{i,o}.rat;
        hoc2 = template_update ( hoc_update , hoc2 , hoc1 , i );
    
        utemplate_sim (o,i-1) = hoc_similarity ( hoc_dist_name, hoc1, hoc2 , cof1 , cof2);
    end
end

%% Results
s1 = (sum(intra_sim')/n) * 100;
s2 = [sum(inter_sim(1,2,:)) sum(inter_sim(1,3,:)) sum(inter_sim(2,3,:))]/(n-1)*100;
s3 = sum(template_sim')/n*100;

%% Total Results
s(1) = mean(intra_sim(:)) * 100; 
s(2) = mean(s2);   
s(3) = mean(s3);   
s(4) = sqrt(s(1) * (100-s(2)));

% disp(' ');
% disp(['Total (mean/var) Intra         ' mat2str(s(1))]);
% disp(['Total (mean/var) Inter         ' mat2str(s(2))]);
% disp(['Total (mean/var) Template      ' mat2str(s(3))]);
% disp(['Score of This Combination (intra*(1-inter)):   '  num2str(s(4))]);

