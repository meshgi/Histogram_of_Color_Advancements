function ctrs = hoc_init ( method , init_frame , hoc_param)
    switch (method)
        case {'conventional','conventional,g2,avg','conventional,g3,avg','conventional,g5,avg','conventional,g2,wei','conventional,g3,wei','conventional,g5,wei','conventional,g2','conventional,g3','conventional,g5'}
            m = hoc_param(1);  % single color channel quantization
            q = linspace(1,255,m);
            ctrs = setprod (q,q,q);

        case {'clustering','clustering,g2,avg','clustering,g3,avg','clustering,g5,avg','clustering,g2,wei','clustering,g3,wei','clustering,g5,wei','clustering,g2','clustering,g3','clustering,g5'}
            img = init_frame;
            % get all points of image, sample them choosing points in equivalent
            % distance
            all_pixels = reshape (img(:,:,1:3) , size(img,1) * size(img,2) , size(img,3));
            sample_idx = floor (linspace(1,size(all_pixels,1),3000));
            samples =    double (all_pixels(sample_idx,:));

            % feed these sample points (RGB) to K-means
            opts=statset('Display','final');
            [~,ctrs]=kmeans( samples ,hoc_param(1),'Options',opts);
            
    end
    

