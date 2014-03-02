function [img , gt_img , gt_bb] = video_frame ( pa, vn, gt , fr )

filename = sprintf ('%s/%s/img/%04d.jpg',pa,vn,fr);
img = imread(filename);
gt_bb = gt(fr,:);
gt_img = bb_content(img,gt_bb);

