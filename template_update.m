function new_template = template_update ( method , old_template , new_entry , frame_no)
    
    if (strcmp(method,'clear'))
        clear q_counter;
        clear q_hoc;
        clear mem;
        return;
    end

    % first template
    if (isempty(old_template))
        new_template = new_entry;
        return;
    end
    
    persistent q_counter;
    persistent q_hoc;
    persistent mem;
    
    switch (method)
        case 'none'
            new_template = old_template;
        case 'nerd'
            new_template = new_entry;
        case 'moving average'
            new_template = 0.9*old_template + 0.1*new_entry;
        case 'last 5'
            q_size = 5;
            if (frame_no == 2)
                q_counter = 2;
                q_hoc(1,:,:) = old_template; 
                q_hoc(2,:,:) = new_entry;
            else
                if (q_counter < q_size)
                    q_hoc(q_counter + 1,:,:) = new_entry;
                    q_counter = q_counter + 1;
                else
                    q_hoc = q_hoc(2:end,:,:);
                    q_hoc(q_counter,:,:) = new_entry;
                end
            end
            new_template = squeeze(mean(q_hoc,1));
            if (size(new_template,2) ~= size(old_template,2))
                new_template = new_template';
            end
                
        case 'update with memory'
            alpha = 0.1; %short term memory forgetting rate
            beta = 0.4; %long term memory forgetting rate
            long_interval = 10;
                        
            if ( isempty(mem) )
                mem = old_template;
            end
            
            if ( mod(frame_no,long_interval) == 0 )
                mem = (1-beta)*mem + beta*new_entry;
            end
            
            new_template = 0.5*(mem + (1-alpha)*old_template + alpha*new_entry);
            
        case 'average all'
            n = frame_no;
            new_template = (1/n) *((n-1)*old_template + new_entry);
            
        case 'bhat'
            for i = size(new_entry,1)
                coeff(i) = dist_bhattacharyya(new_entry(i,:),old_template(i,:));
            end
            coeff = exp(-10*coeff);
            coeff_comp = ones(size(coeff)) - coeff;
            new_template = coeff_comp*old_template + coeff*new_entry;
    end
    
end