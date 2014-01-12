function sim = hoc_similarity ( method, h1 , h2 , cof1 , cof2 )

    if (length(h1) ~= length(h2))
        sim = -1;
        disp ('Histogram sizes do not match');
        return;
    end

    % figure; bar([h1' h2'],'grouped'); xlim([0 length(h1)]);

    sim = 0;
    switch (method)
        case 'L1'
            d = dist_l1 ( h1 , h2 );
            sim = 1 - d/2;
        case 'L2'
            d = dist_l2 ( h1 , h2 );
            sim = 1 - d/2;
        case 'correlation'
            sim = dist_correlation ( h1, h2 );
        case 'chi-square'
            d = dist_chisquare ( h1 , h2 );
            sim = 1 - clip_range(d, [0 1]);
        case 'intersection'
            sim = dist_intersection ( h1 , h2 );
        case 'bhattacharyya'
            d = dist_bhattacharyya ( h1 , h2 );
            sim = 1 - d;
        case 'kl-divergance'
            d = dist_kl ( h1 , h2 );
            sim = max(0,1 - d);
        case 'diffusion'
            d = dist_diffusion ( h1 , h2 );
            sim = max(0,1 - d);
        case 'L1,avg'
            for i = 1:size(h1,1)
                d(i) = dist_l1 ( h1(i,:) , h2(i,:) );
            end
            sim = 1 - mean(d)/2;
        case 'L2,avg'
            for i = 1:size(h1,1)
                d(i) = dist_l2 ( h1(i,:) , h2(i,:) );
            end
            sim = 1 - mean(d)/2;
        case 'correlation,avg'
            for i = 1:size(h1,1)
                s(i) = dist_correlation ( h1(i,:) , h2(i,:) );
            end
            sim = mean(s);
        case 'chi-square,avg'
            for i = 1:size(h1,1)
                d(i) = dist_chisquare ( h1(i,:) , h2(i,:) );
                d(i) = clip_range(d(i), [0 1]);
            end
            sim = 1 - mean(d);
        case 'intersection,avg'
            for i = 1:size(h1,1)
                s(i) = dist_intersection ( h1(i,:) , h2(i,:) );
            end
            sim = mean(s);
        case 'bhattacharyya,avg'
            for i = 1:size(h1,1)
                d(i) = dist_bhattacharyya ( h1(i,:) , h2(i,:) );
            end
            sim = 1 - mean(d);
        case 'kl-divergance,avg'
            for i = 1:size(h1,1)
                d(i) = dist_kl ( h1(i,:) , h2(i,:) );
                d(i) = min (1 , d(i));
            end
            sim = 1 - mean(d);
        case 'diffusion,avg'
            for i = 1:size(h1,1)
                d(i) = dist_diffusion ( h1(i,:) , h2(i,:) );
                d(i) = clip_range(d(i), [0 1]);
            end
            sim = 1 - mean(d);
        case 'L1,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                d(i) = (cof1(i)*cof2(i)/cof_prob)*dist_l1 ( h1(i,:) , h2(i,:) );
            end
            
            sim = 1 - sum(d)/2;
        case 'L2,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                d(i) = (cof1(i)*cof2(i)/cof_prob)*dist_l2 ( h1(i,:) , h2(i,:) );
            end
            
            sim = 1 - sum(d)/2;
        case 'correlation,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                s(i) = (cof1(i)*cof2(i)/cof_prob)*dist_correlation ( h1(i,:) , h2(i,:) );
            end
            
            sim = sum(s);
        case 'chi-square,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                d(i) = dist_chisquare ( h1(i,:) , h2(i,:) );
                d(i) = clip_range(d(i), [0 1]) * (cof1(i)*cof2(i)/cof_prob);
            end
            
            sim = 1 - sum(d);
        case 'intersection,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                s(i) = (cof1(i)*cof2(i)/cof_prob)*dist_intersection ( h1(i,:) , h2(i,:) );
            end
            
            sim = sum(s);
        case 'bhattacharyya,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                d(i) = (cof1(i)*cof2(i)/cof_prob)*dist_bhattacharyya ( h1(i,:) , h2(i,:) );
            end
            
            sim = 1 - sum(d);
        case 'kl-divergance,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                d(i) = dist_kl ( h1(i,:) , h2(i,:) );
                d(i) = (cof1(i)*cof2(i)/cof_prob)*min (1 , d(i));
            end
            sim = 1 - sum(d);
        case 'diffusion,wei'
            cof_prob = cof1'*cof2;
            for i = 1:size(h1,1)
                d(i) = dist_diffusion ( h1(i,:) , h2(i,:) );
                d(i) = (cof1(i)*cof2(i)/cof_prob)*clip_range(d(i), [0 1]);
            end
            sim = 1 - sum(d);
    end

end