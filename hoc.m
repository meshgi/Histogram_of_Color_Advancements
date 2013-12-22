function h = hoc ( method, img, ctrs , r )
    
    h = [];
    switch (method)
        case {'conventional','clustering'}
            h = hoc_normal (img,ctrs);

        case {'conventional,g2,avg','clustering,g2,avg'}
            % 2x2 grid, and the average hoc is representative of all
            box = [0,0,size(img,2),size(img,1)];
            for i = 1:2
                for j = 1:2
                    bb = bb_grid(box,2,i,j);
                    hg((i-1)*2+j,:) = hoc_normal (bb_content(img,bb),ctrs);
                end
            end
            h = mean(hg);
            
        case {'conventional,g3,avg','clustering,g3,avg','conventional,g3,wei','clustering,g3,wei'}
            
            g = 3;
            box = [0,0,size(img,2),size(img,1)];
            for i = 1:g
                for j = 1:g
                    bb = bb_grid(box,g,i,j);
                    hg((i-1)*g+j,:) = hoc_normal (bb_content(img,bb),ctrs);
                end
            end
            h = mean(hg);
            
        case {'conventional,g5,avg','clustering,g5,avg','conventional,g5,wei','clustering,g5,wei'}
            
            g = 5;
            box = [0,0,size(img,2),size(img,1)];
            for i = 1:g
                for j = 1:g
                    bb = bb_grid(box,g,i,j);
                    hg((i-1)*g+j,:) = hoc_normal (bb_content(img,bb),ctrs);
                end
            end
            h = mean(hg);
            
        case {'conventional,g2,wei','clustering,g2,wei'}
            % 2x2 grid, and the weigted hoc is representative of all
            g = 2;
            box = [0,0,size(img,2),size(img,1)];
            for i = 1:g
                for j = 1:g
                    bb = bb_grid(box,g,i,j);
                    hg((i-1)*g+j,:) = hoc_normal (bb_content(img,bb),ctrs);
                end
            end
            r = r / sum(r);
            h = sum(repmat(r,1,size(hg,2)).*hg);
            
            
            
            
    end
    
    
    if ( isempty(h))
        h = (1/length(ctrs)) * ones (1,length(ctrs));
    end
end
