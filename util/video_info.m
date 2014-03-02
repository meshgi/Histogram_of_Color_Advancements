function [frames, vid_sz, gt , first]  = video_info ( pa , video_name )

gt = dlmread ( [pa video_name '\groundtruth_rect.txt']);
frames = size(gt,1);
first = imread([pa video_name '\img\0001.jpg']);
vid_sz = size(first);


