function h = hoc ( method, img, ctrs)
    
    h = [];
    switch (method)
        case 'conventional'
            h = hoc_normal (img,ctrs);
        case 'clustering'
            h = hoc_normal (img,ctrs);
        case 'conventional,g2'
            
    end
   
    
    if ( isempty(h))
        h = (1/length(ctrs)) * ones (1,length(ctrs));
    end
end
