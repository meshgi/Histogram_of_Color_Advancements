function d = dist_jeffrey ( h1 , h2 )

    d = 0;
    m = (h1+h2)/2;

    for i = 1:length(h1)
       if (m(i)==0) 
           % h1(i) = h2(i) = 0
           continue;
       end
       x1 = h1(i) * log(h1(i)/m(i));
       if (~isnan(x1))
           d = d + x1;
       end
       
       x2 = h2(i) * log(h2(i)/m(i));
       if (~isnan(x2))
           d = d + x2;
       end
       
    end

end