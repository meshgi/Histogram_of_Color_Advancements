function [bbs,ss_idx] = make_scaled_bbs ( w , h , W , H )
k = uint16(1);
tic;

    % same scale
    w1 = w;
    h1 = h;
    for i = 0:10:W-w1-1
        for j = 0:10:H-h1-1
            bbs(k,:) = [j,i,h1,w1];
            k = k+1;
        end
    end
    
    ss_idx = k - 1; % same scale idx

	% x2 scale
    w1 = w*2;
    h1 = h*2;
    for i = 0:10:W-w1-1
        for j = 0:10:H-h1-1
            bbs(k,:) = [j,i,h1,w1];
            k = k+1;
        end
    end

    % +10 scale
    w1 = w+10;
    h1 = h+10;
    for i = 0:10:W-w1-1
        for j = 0:10:H-h1-1
            bbs(k,:) = [j,i,h1,w1];
            k = k+1;
        end
    end

    % x0.5 scale
    w1 = floor(w/2);
    h1 = floor(h/2);
    if ( w1 > 5 && h1 > 5 )
        for i = 0:10:W-w1-1
            for j = 0:10:H-h1-1
                bbs(k,:) = [j,i,h1,w1];
                k = k+1;
            end
        end
    end

    % -10 scale
    w1 = w-10;
    h1 = h-10;
    if ( w1 > 5 && h1 > 5 )
        for i = 0:10:W-w1-1
            for j = 0:10:H-h1-1
                bbs(k,:) = [j,i,h1,w1];
                k = k+1;
            end
        end
    end
    
disp (['making boxes takes ' num2str(toc) ' seconds']);
end