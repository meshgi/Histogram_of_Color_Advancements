function sim = hoc_similarity ( method, h1 , h2 )

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
    end

end