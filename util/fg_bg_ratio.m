function r = fg_bg_ratio ( method , msk )
    r = [];

    switch (method)
        case {'conventional,g2','clustering,g2','conventional,g2,wei','clustering,g2,wei'}
            g = 2;
            box = [0,0,size(msk,2),size(msk,1)];
            for i = 1:g
                for j = 1:g
                    bb = bb_grid(box,g,i,j);
                    r((i-1)*g+j,:) =  calc_ratio(bb_content(msk,bb));
                end
            end
            
        case {'conventional,g3','clustering,g3','conventional,g3,wei','clustering,g3,wei'}
            g = 3;
            box = [0,0,size(msk,2),size(msk,1)];
            for i = 1:g
                for j = 1:g
                    bb = bb_grid(box,g,i,j);
                    r((i-1)*g+j,:) =  calc_ratio(bb_content(msk,bb));
                end
            end
            
        case {'conventional,g5','clustering,g5','conventional,g5,wei','clustering,g5,wei'}
            g = 5;
            box = [0,0,size(msk,2),size(msk,1)];
            for i = 1:g
                for j = 1:g
                    bb = bb_grid(box,g,i,j);
                    r((i-1)*g+j,:) =  calc_ratio(bb_content(msk,bb));
                end
            end
            
    end

end


function r = calc_ratio (msk)
    r = sum(msk(:));
    r = double(r) / numel(msk);
end