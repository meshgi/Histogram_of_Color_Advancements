function h = hoc ( method, img , msk)
    switch (method)
        case 'conventional'
            [h ctrs] = hoc_conventional (img,msk);
    end
   
    
    if ( isempty(h))
        h = 1/512 * ones (1,512);
    end
    
    hist_vis (h , ctrs);
    
end
