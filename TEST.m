addpath(genpath('.'));
clc
clear
close all

option_verbose = false;
obj_cnt = 3;
hoc_name = 'conventional';
hoc_dist_name = 'sse';

% read all file names
for i = 1:obj_cnt
    obj_img_list{i} = dir(['data/obj' num2str(i) '/*.jpg']);
    obj_msk_list{i} = dir(['data/obj' num2str(i) '/*.bmp']);
end
n = length(obj_img_list{1,1});


figure
% colors = {'r-','g-','b-'};

intra_sim = zeros(1,n-1);
for o = 1:obj_cnt 
    disp(['Obj' num2str(o) ' Intra Similarity Calculation.'] );
    for i = 2:n
        prefix = ['data/obj' num2str(o) '/'];
        hoc1 = hoc ( hoc_name , [prefix obj_img_list{1,o}(i).name], [prefix obj_msk_list{1,o}(i).name] ); % this frame
        hoc2 = hoc ( hoc_name , [prefix obj_img_list{1,o}(i-1).name], [prefix obj_msk_list{1,o}(i-1).name] ); % last frame
        
        % visualization of hoc differences
        if (option_verbose)
            figure
            bar (hoc1-hoc2); xlim([0 length(hoc1)]); drawnow;
        end

        intra_sim (o,i-1) = hoc_dist ( hoc_dist_name, hoc1, hoc2);
    end
%     plot (1:n-1 , intra_sim(o,:),colors{1,o},'LineWidth',2);
%     hold on
end
% hold off
pl= plot (1:n-1 ,intra_sim(1,:) ,'r-',1:n-1 , intra_sim(2,:), 'g-',1:n-1 , intra_sim(3,:),'b-');
set(pl,'LineWidth',2);
legend ('obj1','obj2','obj3','Location', 'SouthEast');
xlim([1 n]);
ylim([0 1]);


inter_sim = zeros (obj_cnt,obj_cnt,n);
for o1 = 1:obj_cnt
	p1 = ['data/obj' num2str(o1) '/'];
    for o2 = o1+1:obj_cnt
        p2 = ['data/obj' num2str(o2) '/'];
        
        disp(['Obj' num2str(o1) ' and Obj' num2str(o2) ' Inter Similarity Calculation.'] );
        for i = 1:n    
            hoc1 = hoc ( hoc_name , [p1 obj_img_list{1,o1}(i).name], [p1 obj_msk_list{1,o1}(i).name] ); % first object
            hoc2 = hoc ( hoc_name , [p2 obj_img_list{1,o2}(i).name], [p2 obj_msk_list{1,o2}(i).name] ); % second object
            inter_sim (o1,o2,i) = hoc_dist ( hoc_dist_name, hoc1, hoc2);
            inter_sim (o2,o1,i) = inter_sim (o1,o2,i);
        end
    end
end

figure
o1o2 = squeeze(inter_sim(1,2,:));
o2o3 = squeeze(inter_sim(2,3,:));
o1o3 = squeeze(inter_sim(1,3,:));

pl= plot (1:n ,o1o2 ,'k-',1:n , o2o3, 'c-',1:n , o1o3,'m-');
set(pl,'LineWidth',2);
legend ('obj1-obj2','obj2-obj3','obj1-obj3');
xlim([1 n+1]);
ylim([0 1]);

% Similarities of one person, named Intra-object similarity, are calculated on
% consecutice frames of this subject. On the other side, similarities (here: dissimilarities)
% between different objects, named Inter-object similarity, are computed 
% on the subject images of the same frame.
% intra subject similarity r: obj1 g: obj2: b: obj3
% inter subject similarity k: obj1:obj2 m: obj2:obj3 c: obj1:obj3