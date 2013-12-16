function ctrs = hoc_init ( method , init_frame , hoc_param)
    switch (method)
        case 'conventional'
            m = hoc_param(1);  % single color channel quantization
            q = linspace(1,255,m);
            ctrs = setprod (q,q,q);

        case 'clustering'
            img = imread(init_frame);
            % get all points of image, sample them choosing points in equivalent
            % distance
            all_pixels = reshape (img(:,:,1:3) , size(img,1) * size(img,2) , size(img,3));
            sample_idx = floor (linspace(1,size(all_pixels,1),3000));
            samples =    double (all_pixels(sample_idx,:));

            % feed these sample points (RGB) to K-means
            opts=statset('Display','final');
            [~,ctrs]=kmeans( samples ,hoc_param(1),'Options',opts);
            
        case 'conventional,g2'
            m = hoc_param(1);  % single color channel quantization
            q = linspace(1,255,m);
            ctrs = setprod (q,q,q);
    end
    

