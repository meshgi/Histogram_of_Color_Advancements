function s = scenario1 (hoc_name,gridding,hoc_param,hoc_dist_name)

hoc_name = [hoc_name gridding];
obj_cnt = 3;

% read all file names
for i = 1:obj_cnt
    obj_img_list{i} = dir(['data/scenario 1/obj' num2str(i) '/*.jpg']);
    obj_msk_list{i} = dir(['data/scenario 1/obj' num2str(i) '/*.bmp']);
end
n = length(obj_img_list{1,1});

ctrs_name = ['automation/' hoc_name, num2str(hoc_param) '.mat'];
if exist (ctrs_name , 'file') == 2
    load (ctrs_name);
else
    [ctrs,q] = hoc_init ( hoc_name , imread('data/scenario 1/frame_0455.jpg'), hoc_param);
    save(ctrs_name, 'ctrs' , 'q');
end

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
        
        intra_sim (o,i-1) = hoc_distance ( hoc_dist_name, hoc1, hoc2, cof1 , cof2 , q);
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
            
            inter_sim (o1,o2,i) = hoc_distance ( hoc_dist_name, hoc1, hoc2, cof1, cof2 , q);
            inter_sim (o2,o1,i) = inter_sim (o1,o2,i);
        end
    end
end


%% Preparation for template update phase
template_update ( 'clear' );

%% Template Matching with Model Update = none
utemplate_sim = zeros(obj_cnt,n-1);
for o = 1:obj_cnt 

    hoc2 = frame_obj{1,o}.hoc; % template
    cof2 = frame_obj{1,o}.rat; % template
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        cof1 = frame_obj{i,o}.rat;
        hoc2 = template_update ( 'none' , hoc2 , hoc1 , i );
    
        utemplate_sim (o,i-1) = hoc_distance ( hoc_dist_name, hoc1, hoc2 , cof1 , cof2 , q);
    end
end

%% Template Matching with Model Update = moving average
u1template_sim = zeros(obj_cnt,n-1);
for o = 1:obj_cnt 

    hoc2 = frame_obj{1,o}.hoc; % template
    cof2 = frame_obj{1,o}.rat; % template
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        cof1 = frame_obj{i,o}.rat;
        hoc2 = template_update ( 'moving average' , hoc2 , hoc1 , i );
    
        u1template_sim (o,i-1) = hoc_distance ( hoc_dist_name, hoc1, hoc2 , cof1 , cof2 , q);
    end
end

%% Template Matching with Model Update = last 5
u2template_sim = zeros(obj_cnt,n-1);
for o = 1:obj_cnt 

    hoc2 = frame_obj{1,o}.hoc; % template
    cof2 = frame_obj{1,o}.rat; % template
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        cof1 = frame_obj{i,o}.rat;
        hoc2 = template_update ( 'last 5' , hoc2 , hoc1 , i );
    
        u2template_sim (o,i-1) = hoc_distance ( hoc_dist_name, hoc1, hoc2 , cof1 , cof2 , q);
    end
end

%% Template Matching with Model Update = average all
u3template_sim = zeros(obj_cnt,n-1);
for o = 1:obj_cnt 

    hoc2 = frame_obj{1,o}.hoc; % template
    cof2 = frame_obj{1,o}.rat; % template
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        cof1 = frame_obj{i,o}.rat;
        hoc2 = template_update ( 'average all' , hoc2 , hoc1 , i );
    
        u3template_sim (o,i-1) = hoc_distance ( hoc_dist_name, hoc1, hoc2 , cof1 , cof2 , q);
    end
end

%% Template Matching with Model Update = update with memory
u4template_sim = zeros(obj_cnt,n-1);
for o = 1:obj_cnt 

    hoc2 = frame_obj{1,o}.hoc; % template
    cof2 = frame_obj{1,o}.rat; % template
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        cof1 = frame_obj{i,o}.rat;
        hoc2 = template_update ( 'update with memory' , hoc2 , hoc1 , i );
    
        u4template_sim (o,i-1) = hoc_distance ( hoc_dist_name, hoc1, hoc2 , cof1 , cof2 , q);
    end
end

%% Normalization Phase
max_dist = max([intra_sim(:); inter_sim(:); utemplate_sim(:); u1template_sim(:); u2template_sim(:); u3template_sim(:); u4template_sim(:)]);

big1 = ones(size(intra_sim));
big2 = ones(size(inter_sim));

intra_sim = big1 - intra_sim / max_dist;
inter_sim = big2 - inter_sim / max_dist;
utemplate_sim = big1 - utemplate_sim / max_dist;
u1template_sim = big1 - u1template_sim / max_dist;
u2template_sim = big1 - u2template_sim / max_dist;
u3template_sim = big1 - u3template_sim / max_dist;
u4template_sim = big1 - u4template_sim / max_dist;

o1o2 = squeeze(inter_sim(1,2,:));
o2o3 = squeeze(inter_sim(2,3,:));
o1o3 = squeeze(inter_sim(1,3,:));

%% Results
s1 = (sum(intra_sim')/n) * 100;
s2 = [sum(inter_sim(1,2,:)) sum(inter_sim(1,3,:)) sum(inter_sim(2,3,:))]/(n-1)*100;
s3 = sum(utemplate_sim')/n*100;
s4 = sum(u1template_sim')/n*100;
s5 = sum(u2template_sim')/n*100;
s6 = sum(u3template_sim')/n*100;
s7 = sum(u4template_sim')/n*100;


%% Total Results
s(1) = mean(intra_sim(:)) * 100; 
s(2) = mean(s2);   
s(3) = mean(s3);   
s(4) = mean(s4);
s(5) = mean(s5);
s(6) = mean(s6);
s(7) = mean(s7);
s(8) = sqrt(s(1) * (100-s(2)));



