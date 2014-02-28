function d = hoc_distance ( method, h1 , h2 , cof1 , cof2 , q)

    if (size(h1) ~= size(h2))
        d = -1;
        disp ('Histogram sizes do not match');
        return;
    end

    % figure; bar([h1' h2'],'grouped'); xlim([0 length(h1)]);

    d = 0;
    switch (method)
        case 'L1'
            d = dist_l1 ( h1 , h2 );
        case 'L2'
            d = dist_l2 ( h1 , h2 );
        case 'Linf'
            d = dist_linf ( h1 , h2 );
        case 'correlation'
            d = dist_correlation ( h1, h2 );
        case 'chi-square'
            d = dist_chisquare ( h1 , h2 );
            d = clip_range(d, [0 1]);
        case 'intersection'
            d = dist_intersection ( h1 , h2 );
            d = 1 - d;
        case 'bhattacharyya'
            d = dist_bhattacharyya ( h1 , h2 );
        case 'kl-divergance'
            d = dist_kl ( h1 , h2 );
            d = clip_range(d, [0 1]);
        case 'diffusion'
            d = dist_diffusion ( h1 , h2 );
            clip_range(d, [0 1]);
        case 'match'
            d = dist_match ( h1, h2 );
        case 'jeffry div'
            d = dist_jeffrey ( h1 , h2 );
        case 'kolmogorov smirnov'
            d = dist_ks ( h1 , h2 );
        case 'cramer von mises'
            d = dist_cvm ( h1 , h2 );
        case 'quadratic'
            d = dist_quadratic ( h1 , h2 , q );
        case 'quadratic-chi'
            d = dist_qc ( h1 , h2 , q );
            d = clip_range(d, [0 1]);
        case 'emd hat'
            d = dist_emd_hat ( h1 , h2 , q );
        case 'cosine'
            d = dist_cosine ( h1 , h2 );
        case 'L0'
            d = dist_l0 ( h1 , h2 );
            
            
            
            
            
        case 'L1,avg'
            for i = 1:size(h1,1)
                x(i) = dist_l1 ( h1(i,:) , h2(i,:) );
            end
            d = mean(x);
        case 'L2,avg'
            for i = 1:size(h1,1)
                x(i) = dist_l2 ( h1(i,:) , h2(i,:) );
            end
            d = mean(x);
        case 'Linf,avg'
            for i = 1:size(h1,1)
                x(i) = dist_linf ( h1(i,:) , h2(i,:) );
            end
            d = mean(x);
        case 'correlation,avg'
            for i = 1:size(h1,1)
                x(i) = dist_correlation ( h1(i,:) , h2(i,:) );
            end
            d = mean(x);
        case 'chi-square,avg'
            for i = 1:size(h1,1)
                x(i) = dist_chisquare ( h1(i,:) , h2(i,:) );
                x(i) = clip_range(x(i), [0 1]);
            end
            d = mean(x);
        case 'intersection,avg'
            for i = 1:size(h1,1)
                x(i) = dist_intersection ( h1(i,:) , h2(i,:) );
            end
            d = 1 - mean(x);
        case 'bhattacharyya,avg'
            for i = 1:size(h1,1)
                x(i) = dist_bhattacharyya ( h1(i,:) , h2(i,:) );
            end
            d = mean(x);
        case 'kl-divergance,avg'
            for i = 1:size(h1,1)
                x(i) = dist_kl ( h1(i,:) , h2(i,:) );
                x(i) = clip_range(x(i), [0 1]);
            end
            d = mean(x);
        case 'diffusion,avg'
            for i = 1:size(h1,1)
                x(i) = dist_diffusion ( h1(i,:) , h2(i,:) );
                x(i) = clip_range(x(i), [0 1]);
            end
            d = mean(x);
        case 'match,avg'
            for i = 1:size(h1,1)
                x(i) = dist_match ( h1(i,:) , h2(i,:) );
            end
            d = mean(x);
        case 'kolmogorov smirnov,avg'
            for i = 1:size(h1,1)
                x(i) = dist_ks ( h1(i,:) , h2(i,:) );
            end
            d = mean(x);
        case 'jeffry div,avg'
            for i = 1:size(h1,1)
                x(i) = dist_jeffrey ( h1(i,:) , h2(i,:) );
            end
            d = mean(x);
        case 'cramer von mises,avg'
            for i = 1:size(h1,1)
                x(i) = dist_cvm ( h1(i,:) , h2(i,:) );
            end
            d = mean(x);
        case 'quadratic,avg'
            for i = 1:size(h1,1)
                x(i) = dist_quadratic ( h1(i,:) , h2(i,:) , q );
            end
            d = mean(x);
        case 'quadratic-chi,avg'
            for i = 1:size(h1,1)
                x(i) = dist_qc ( h1(i,:) , h2(i,:) , q );
                x(i) = clip_range(x(i), [0 1]);
            end
            d = mean(x);
        case 'emd hat,avg'
            for i = 1:size(h1,1)
                x(i) = dist_emd_hat ( h1(i,:) , h2(i,:) , q );
            end
            d = mean(x);
            
        case 'cosine,avg'
            for i = 1:size(h1,1)
                x(i) = dist_cosine ( h1(i,:) , h2(i,:) );
            end
            d = mean(x);
            
            
            
            
        case 'L1,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_l1 ( h1(i,:) , h2(i,:) );
            end
            
            d = sum(x);
        case 'L2,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_l2 ( h1(i,:) , h2(i,:) );
            end
            
            d = sum(x);
        case 'Linf,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_linf ( h1(i,:) , h2(i,:) );
            end
            
            d = sum(x);
        case 'correlation,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_correlation ( h1(i,:) , h2(i,:) );
            end
            
            d = sum(x);
        case 'chi-square,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = dist_chisquare ( h1(i,:) , h2(i,:) );
                x(i) = clip_range(x(i), [0 1]) * (cof1(i)*cof2(i)/cof_prob);
            end
            
            d = sum(x);
        case 'intersection,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_intersection ( h1(i,:) , h2(i,:) );
            end
            
            d = 1 - sum(x);
        case 'bhattacharyya,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_bhattacharyya ( h1(i,:) , h2(i,:) );
            end
            
            d = sum(x);
        case 'kl-divergance,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = dist_kl ( h1(i,:) , h2(i,:) );
                x(i) = (cof1(i)*cof2(i)/cof_prob)*min (1 , x(i));
            end
            d = sum(x);
        case 'diffusion,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = dist_diffusion ( h1(i,:) , h2(i,:) );
                x(i) = (cof1(i)*cof2(i)/cof_prob)*clip_range(x(i), [0 1]);
            end
            d = sum(x);
        case 'match,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_match ( h1(i,:) , h2(i,:) );
            end
            
            d = sum(x);
        case 'kolmogorov smirnov,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_ks ( h1(i,:) , h2(i,:) );
            end
            
            d = sum(x);
        case 'jeffry div,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_jeffrey ( h1(i,:) , h2(i,:) );
            end
            
            d = sum(x);
        case 'cramer von mises,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_cvm ( h1(i,:) , h2(i,:) );
            end
            
            d = sum(x);
        case 'quadratic,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_quadratic ( h1(i,:) , h2(i,:) , q);
            end
            
            d = sum(x);
        case 'quadratic-chi,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = dist_qc ( h1(i,:) , h2(i,:) , q );
                x(i) = clip_range(x(i), [0 1]) * (cof1(i)*cof2(i)/cof_prob);
            end
            d = sum(x);
        case 'emd hat,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_emd_hat ( h1(i,:) , h2(i,:) , q);
            end
            
            d = sum(x);
            
        case 'cosine,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                x(i) = (cof1(i)*cof2(i)/cof_prob)*dist_cosine ( h1(i,:) , h2(i,:));
            end
            
            d = sum(x);
    end

end