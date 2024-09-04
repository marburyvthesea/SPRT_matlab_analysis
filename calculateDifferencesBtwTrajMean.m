function diff_table = calculateDifferencesBtwTrajMean(finger_coords_table, avg_coors_table)
    % Initialize an empty table to store the differences
    diff_table = table();
    
    % Get the variable names from finger_coords_table
    finger_var_names = finger_coords_table.Properties.VariableNames;
    
    % Loop through each column in finger_coords_table
    for i = 1:length(finger_var_names)
        % Get the current variable name
        currentVar = finger_var_names{i};
        
        % Extract the mouse number and L_finger/R_finger identifier
        tokens = regexp(currentVar, '_\d+_(\d+)_(L_finger|R_finger)', 'tokens');
        if isempty(tokens)
            continue; % Skip if the pattern doesn't match
        end
        mouseNum = tokens{1}{1};
        fingerType = tokens{1}{2};
        
        % Determine if the column is x or y based on the prefix
        if contains(currentVar, 'x')
            coordType = 'x';
        elseif contains(currentVar, 'y')
            coordType = 'y';
        else
            continue; % Skip if not x or y
        end
        
        % Construct the corresponding variable name in avg_coors_table
        avg_var_name = sprintf('avg_%s_coor_%s_%s', upper(coordType), mouseNum, fingerType);
        
        % Check if the corresponding variable exists in avg_coors_table
        if ~ismember(avg_var_name, avg_coors_table.Properties.VariableNames)
            warning('Variable %s not found in avg_coors_table.', avg_var_name);
            continue;
        end
        
        % Calculate the difference between the columns
        diff_values = finger_coords_table{:, currentVar} - avg_coors_table{:, avg_var_name};
        
        %% Create a new variable name for the difference
        diff_var_name = [currentVar, '_diff'];
        
        % Add the difference to the new table
        diff_table.(diff_var_name) = diff_values;
    end
end
