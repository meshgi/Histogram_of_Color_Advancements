function d = hoc_dist ( method, h1 , h2 )

if (length(h1) ~= length(h2))
    d = -1;
    disp ('Histogram sizes do not match');
    return;
end

% figure; bar([h1' h2'],'grouped'); xlim([0 length(h1)]);

d = 0;
switch (method)
    case 'sse'
        d = dist_sse ( h1 , h2 );
end

end