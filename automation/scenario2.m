function scenario2 ()
clc;
clear all;
close all;

database_path = 'D:\scenario 2\';

hoc_update = 'none';
% hoc_update = 'moving average';
% hoc_update = 'nerd';
% hoc_update = 'last 5';
% hoc_update = 'average all';
% hoc_update = 'update with memory';


colorspace_name = 'rgb';
hoc_name = 'conventional';  
hoc_param = [5,5,5];
hoc_dist_name = 'bhattacharyya';

oracle_idx = 1;
% oracle{1,:} = {'rgb' , 'conventional' , 'bhattacharyya' , [5,5,5]};


video_database = find_videos ( database_path );
    
scale = 1;

for vid = 1:length(video_database)
    video_name = video_database{vid};
    disp(' ')
    disp(['Reading video ' video_name])
    [frames, vid_sz, gt , first] = video_info ( database_path, video_name );
    
    if (length(vid_sz) == 2 || vid_sz(3) == 1)
        disp('... Grayscale Video - Skip!')
        continue;
    end
    
    disp('... Initializing HOC')
    [ctrs,q] = hoc_init ( hoc_name , first , hoc_param , colorspace_name);

    disp(['... Processing ' num2str(frames) ' frames'])   
    for fr = 1:frames
        [img , gt_img , gt_bb] = video_frame ( database_path, video_name, gt , fr );
        disp (['... Frame ' num2str(fr)]);
        
        if (fr == 1)
            disp('...... Initializing Template')
            template = hoc ( hoc_name , gt_img , ctrs , 0 , colorspace_name);
            continue;
        end
            
        % VIS
%         subplot(2,3,[1,2,4,5]); imshow(img); hold on;
%         subplot(2,3,[3,6]); imshow(gt_img);
%         set(gcf,'Name',num2str(fr));
%         drawnow;

        disp('...... Creating Box Grid')
        [boxes , gt_idx] = sliding_window (vid_sz, gt_bb,0.5);

        % VIS
%         subplot(2,3,[1,2,4,5]);
%         for b = 1:size(boxes,1)
%             rectangle('Position',boxes(b,:),'EdgeColor','k');
%             drawnow
%         end
%         rectangle('Position',boxes(gt_idx,:),'EdgeColor','r','LineWidth',2);
%         drawnow;
%         pause

        for b = 1:size(boxes,1)
            box_img = bb_content(img,boxes(b,:));
            box_hoc = hoc ( hoc_name , box_img , ctrs , 0 , colorspace_name);
            box_d(b) = hoc_distance ( hoc_dist_name, template, box_hoc, 0, 0 , q);
        end % box           

        [~ , box_idx] = sort(box_d,'descend');
        ranking = find(box_idx == gt_idx);
        score = double(ranking) / length (box_idx);
        
        disp(['...... Score: ' num2str(score)]);
        
        % VIS
        
        score_history(fr) = score;
        best_match_idx = box_idx(end);
        best_match_box = boxes(best_match_idx,:);
        best_match_img = bb_content(img, best_match_box);
        best_match_hoc = hoc ( hoc_name , best_match_img , ctrs , 0 , colorspace_name);
        gt_hoc = hoc ( hoc_name , gt_img , ctrs , 0 , colorspace_name);
        
        subplot (7,3,[1,2]);   hist_vis (template,ctrs);
        subplot (7,3,[4,5]);   hist_vis (gt_hoc,ctrs);
        subplot (7,3,[7,8]);   bar (abs(gt_hoc-template)); xlim([0 length(template)]); ylim([0 0.2]);
        subplot (7,3,[10,11]); hist_vis (best_match_hoc,ctrs);
        subplot (7,3,[13,14]); bar (abs(best_match_hoc-template)); xlim([0 length(template)]); ylim([0 0.2]);
        subplot (7,3,[6,9]);   imshow(gt_img);
        subplot (7,3,[12,15]); imshow(best_match_img);
        subplot (7,3,16:21);   plot(1:fr,score_history,'r'); ylim([0.9 1]); xlim([1 frames]); 
        set(gcf,'Color', 'k');
        drawnow;

        
        S{oracle_idx,vid,fr} = score;
        
    end % fr
end % vid

% Savg = mean(oracle_idx,vid,:)



