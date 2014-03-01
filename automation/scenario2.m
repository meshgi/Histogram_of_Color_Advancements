function scenario2 ()
clc;
clear all;
close all;

database_path = 'D:\scenario 2\';

colorspace_name = 'rgb';
hoc_name = 'conventional';  
hoc_param = [8,8,4];
hoc_update = 'none';
hoc_dist_name = 'bhattacharyya';

video_database = find_videos ( database_path );
    
% Football1, Basketball

scale = 1;

for vid = 1:length(video_database)
    video_name = video_database{vid};
    disp(' ')
    disp(['Reading video ' video_name])
    [frames, vid_sz, gt , first] = video_info ( database_path, video_name );
    
    disp('... Initializing HOC')
    [ctrs,q] = hoc_init ( hoc_name , first , hoc_param , colorspace_name);

    disp(['... Processing ' num2str(frames) ' frames'])
    h = figure;
    for fr = 1:frames
        [img , gt_img , gt_bb] = video_frame ( database_path, video_name, gt , fr );

%         subplot(3,3,[1,2,4,5]); imshow(img);
%         subplot(3,3,3); imshow(gt_img);
%         set(h,'Name',num2str(fr));
%         drawnow;

        boxes = sliding_window (vid_sz, gt_bb);
            

    end % fr
end % vid
