function r = fg_bg_ratio ( method , msk )
    r = [];

    switch (method)
        case 'conventional,g2,wei'
            g = 2;
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