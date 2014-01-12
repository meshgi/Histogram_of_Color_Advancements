function s = scenario1 (hoc_name,gridding,hoc_param,hoc_update,hoc_dist_name)

hoc_name = [hoc_name gridding];

obj_cnt = 3;
option_verbose = false;

%% Read data
disp('Loading Data...');
for i = 1:obj_cnt
    obj_img_list{i} = dir(['data/scenario 1/obj' num2str(i) '/*.jpg']);
    obj_msk_list{i} = dir(['data/scenario 1/obj' num2str(i) '/*.bmp']);
end
n = length(obj_img_list{1,1});

ctrs = hoc_init ( hoc_name , imread('data/scenario 1/frame_0455.jpg'), hoc_param);

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
% figure ('Name','Intra Similarity');
intra_sim = zeros(1,n-1);
for o = 1:obj_cnt 
    disp(['Obj' num2str(o) ' Intra Similarity Calculation.'] );
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        hoc2 = frame_obj{i-1,o}.hoc; % last frame
        
        % visualization of hoc differences
%         if (option_verbose)
%             clf;
%             subplot (3,3,[1,2]); hist_vis (hoc1,ctrs);
%             subplot (3,3,[4,5]); hist_vis (hoc2,ctrs);
%             subplot (3,3,3);     imshow(frame_obj{i,o}.img);
%             subplot (3,3,6);     imshow(frame_obj{i-1,o}.img);
%             subplot (3,3,[7,8]);  bar (abs(hoc1-hoc2)); xlim([0 length(hoc1)]); ylim([0 0.2]); drawnow;
%         end

        intra_sim (o,i-1) = hoc_similarity ( hoc_dist_name, hoc1, hoc2);
    end
end

if (option_verbose)
    subplot(2,2,1);
    pl= plot (1:n-1 ,intra_sim(1,:) ,'r-',1:n-1 , intra_sim(2,:), 'g-',1:n-1 , intra_sim(3,:),'b-');
    set(pl,'LineWidth',2);
    legend ('obj1','obj2','obj3','Location', 'SouthEast');
    xlim([1 n]);
    ylim([0.9 1]);
    title('Intra Similarity');
    drawnow;
end


%% Inter Similarity
% figure ('Name','Inter Similarity');
inter_sim = zeros (obj_cnt,obj_cnt,n);
for o1 = 1:obj_cnt
    for o2 = o1+1:obj_cnt
        
        disp(['Obj' num2str(o1) ' and Obj' num2str(o2) ' Inter Similarity Calculation.'] );
        for i = 1:n    
            hoc1 = frame_obj{i,o1}.hoc; % obj 1
            hoc2 = frame_obj{i,o2}.hoc; % obj 2
            inter_sim (o1,o2,i) = hoc_similarity ( hoc_dist_name, hoc1, hoc2);
            inter_sim (o2,o1,i) = inter_sim (o1,o2,i);
        end
    end
end

o1o2 = squeeze(inter_sim(1,2,:));
o2o3 = squeeze(inter_sim(2,3,:));
o1o3 = squeeze(inter_sim(1,3,:));

if (option_verbose)
    subplot(2,2,2);
    pl= plot (1:n ,o1o2 ,'k-',1:n , o2o3, 'c-',1:n , o1o3,'m-');
    set(pl,'LineWidth',2);
    legend ('obj1-obj2','obj2-obj3','obj1-obj3','Location', 'SouthEast');
    xlim([1 n+1]);
    ylim([0.7 1]);
    title('Inter Similarity');
    drawnow;
end

%% Template Matching
% figure ('Name','Template Matching');
template_sim = zeros(1,n-1);
for o = 1:obj_cnt 
    hoc2 = frame_obj{1,o}.hoc; % template
    disp(['Obj' num2str(o) ' Template Similarity Calculation.'] );
    for i = 2:n
        hoc1 = frame_obj{i,o}.hoc; % this frame
        hoc2 = template_update ( hoc_update , hoc2 , hoc1 , i );
        
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

        template_sim (o,i-1) = hoc_similarity ( hoc_dist_name, hoc1, hoc2);
    end
end


if (option_verbose)
    subplot(2,2,3);
    pl= plot (1:n-1 ,intra_sim(1,:) ,'r-',1:n-1 , template_sim(2,:), 'g-',1:n-1 , intra_sim(3,:),'b-');
    set(pl,'LineWidth',2);
    legend ('obj1','obj2','obj3','Location', 'SouthWest');
    xlim([1 n]);
    ylim([0.9 1]);
    title('Template Matching');
    drawnow;
end


%% Results
s1 = (sum(intra_sim')/n) * 100;
s2 = [sum(inter_sim(1,2,:)) sum(inter_sim(1,3,:)) sum(inter_sim(2,3,:))]/(n-1)*100;
s3 = sum(template_sim')/n*100;

%% Total Results
s(1) = mean(intra_sim(:)) * 100; 
s(2) = mean(s2);   
s(3) = mean(s3);   

disp(' ');
disp(['Total (mean/var) Intra         ' mat2str(s(1))]);
disp(['Total (mean/var) Inter         ' mat2str(s(2))]);
disp(['Total (mean/var) Template      ' mat2str(s(3))]);

s(4) = sqrt(s(1) * (100-s(2)));
disp(['Score of This Combination (intra*(1-inter)):   '  num2str(s(4))]);

