function new_template = template_update ( method , old_template , new_entry , frame_no)

    % first template
    if (isempty(old_template))
        new_template = new_entry;
        return;
    end
    
    
    persistent q_counter;
    persistent q_hoc;
    
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
                q_hoc = [old_template; new_entry];
            else
                if (q_counter < q_size)
                    q_hoc = [q_hoc ; new_entry];
                    q_counter = q_counter + 1;
                else
                    q_hoc = [q_hoc(2:end,:) ; new_entry];
                end
            end
            new_template = mean(q_hoc);
                
        case 'update with memory'
            alpha = 0.1; %short term memory forgetting rate
            beta = 0.4; %long term memory forgetting rate
            long_interval = 10;
                        
            if ( isempty(q_hoc) )
                q_hoc = old_template;
            end
            
            if ( mod(frame_no,long_interval) == 0 )
                q_hoc = (1-beta)*q_hoc + beta*new_entry;
            end
            
            new_template = 0.5*(q_hoc + (1-alpha)*old_template + alpha*new_entry);
            
        case 'average all'
            % TO BE CHECKED
            n = frame_no;
            new_template = (1/n) *((n-1)*old_template + new_entry);
    end
    
end