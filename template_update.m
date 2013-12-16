function new_template = template_update ( method , old_template , new_entry , frame_no)

    % first template
    if (isempty(old_template))
        new_template = new_entry;
        return;
    end
    
    switch (method)
        case 'none'
            new_template = old_template;
        case 'nerd'
            new_template = new_entry;
        case 'moving average'
            new_template = 0.9*old_template + 0.1*new_entry;
        case 'last 5'
            % enqueue the new_entry
            % calculate average of all queue elements
        case 'average all'
            % TO BE CHECKED
            n = frame_no;
            new_template = (1/n) *((n-1)*old_template + new_entry);
    end
    
end