clc
close all
database_path = 'D:\scenario 2\';
video_name = 'Boy';


disp(['... Reading video ' video_name]) %==================================
[frames, vid_sz, gt , first] = video_info ( database_path, video_name );

if (length(vid_sz) == 2 || vid_sz(3) == 1)
    disp('...... Grayscale Video - Skip!')
    return
end

disp(['...... Processing ' num2str(frames) ' frames']) %==================
for fr = 1:min(frames,100)
    [img , gt_img , gt_bb] = video_frame ( database_path, video_name, gt , fr );
    disp (['...... Frame ' num2str(fr)]);


    subplot(2,3,[1,2,4,5]); imshow(img); hold on;
    rectangle('Position',gt_bb,'EdgeColor','y');
    subplot(2,3,[3,6]); imshow(gt_img);
    set(gcf,'Name',num2str(fr));
    drawnow;
end