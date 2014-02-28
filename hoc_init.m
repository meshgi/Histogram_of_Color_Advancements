function [ctrs, Q] = hoc_init ( method , init_frame_img , hoc_param , cs_name )
    switch (method)
        case {'conventional','conventional,g2,avg','conventional,g3,avg','conventional,g5,avg','conventional,g2,wei','conventional,g3,wei','conventional,g5,wei','conventional,g2','conventional,g3','conventional,g5'}
            m1 = hoc_param(1);  % single color channel quantization
            if (length(hoc_param)==1)
                q = linspace(1,255,m1);
                ctrs = setprod (q,q,q);
            else
                m2 = hoc_param(2);
                m3 = hoc_param(3);
                
                q1 = linspace(1,255,m1);
                q2 = linspace(1,255,m2);
                q3 = linspace(1,255,m3);
                
                ctrs = setprod (q1,q2,q3);
            end

            rgb_ctrs = ctrs;

        case {'clustering','clustering,g2,avg','clustering,g3,avg','clustering,g5,avg','clustering,g2,wei','clustering,g3,wei','clustering,g5,wei','clustering,g2','clustering,g3','clustering,g5'}
            img = init_frame_img;
            
            switch ( cs_name )
                case 'rgb'
                case 'hsv'
                    img = uint8(255*rgb2hsv(img));
            end
                        
            bins = hoc_param(1);
            % get all points of image, sample them choosing points in equivalent
            % distance
            all_pixels = reshape (img(:,:,1:3) , size(img,1) * size(img,2) , size(img,3));
            sample_idx = floor (linspace(1,size(all_pixels,1),3000));
            samples =    double (all_pixels(sample_idx,:));

            % feed these sample points (RGB) to K-means
            opts=statset('Display','final');
            [idx,ctrs]=kmeans( samples ,bins,'Options',opts,'Replicates',3);
            
            % if SORTING is enabled
            if (length(hoc_param)>1 && hoc_param(2)== 1)
                clusters = hist(idx,bins);
                [~,sorted_clusters] = sort (clusters, 'descend');
                ctrs = ctrs(sorted_clusters,:);
            end
            
            switch (cs_name)
                case 'rgb'
                    rgb_ctrs = ctrs;
                case 'hsv'
                    rgb_ctrs = 255*hsv2rgb(ctrs/255);          
            end
            
    end
    
    
    Q = create_similarity_matrix ( rgb_ctrs, cs_name );
end


function Q = create_similarity_matrix (ctrs, cs_name)

    n = size(ctrs,1);
    for i = 1:n
        for j = 1:n
            rgb_bins(j,i,:) = uint8(floor(ctrs(i,:)));
        end
    end
    % imshow(rgb_bins);

    cform = makecform('srgb2lab');
    lab_bins = applycform(rgb_bins,cform);
    % imshow(lab_bins);

    ctrs_lab = double(squeeze(lab_bins(1,:,:)));
    d = zeros(n);
    for i = 1:n
        for j = i+1:n
            d(i,j) = deltaE2000 (ctrs_lab(i,:) , ctrs_lab(j,:));
            d(j,i) = d(i,j);
        end
    end
    dmax = max(d(:));
    
    
    sigma = 2;
%     Q = eye (n);                        % no cross bin consideration
%     Q = ones(n) - d/dmax;               % linear
%     Q = exp( - sigma * d/dmax);         % exponential
    Q = exp( - sigma * (d/dmax).^2);    % more exponential

end
