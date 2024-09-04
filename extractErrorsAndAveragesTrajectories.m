function [avg_coors_table, errors_table, finger_coords_table] = extractErrorsAndAveragesTrajectories(varsList)
    % Initialize empty tables to store the combined data
    avg_coors_table = table();  % To store 'avg_X_coor' and 'avg_Y_coor'
    errors_table = table();     % To store 'xError' and 'yError'
    finger_coords_table = table();  % To store 'L_finger_x', 'L_finger_y', 'R_finger_x', 'R_finger_y'

    % Loop through each variable name in varsList
    for i = 1:length(varsList)
        % Get the table from the workspace
        currentTable = evalin('base', varsList{i});
        
        % Extract columns that start with 'avg_X_coor' or 'avg_Y_coor'
        avg_coors = currentTable(:, startsWith(currentTable.Properties.VariableNames, 'avg_X_coor') | ...
                                    startsWith(currentTable.Properties.VariableNames, 'avg_Y_coor'));
        
        % Extract columns that start with 'xError' or 'yError'
        errors = currentTable(:, startsWith(currentTable.Properties.VariableNames, 'xError') | ...
                                   startsWith(currentTable.Properties.VariableNames, 'yError'));
        
        % Extract columns that start with 'L_finger_x', 'L_finger_y', 'R_finger_x', or 'R_finger_y'
        finger_coords = currentTable(:, startsWith(currentTable.Properties.VariableNames, 'L_finger_x') | ...
                                            startsWith(currentTable.Properties.VariableNames, 'L_finger_y') | ...
                                            startsWith(currentTable.Properties.VariableNames, 'R_finger_x') | ...
                                            startsWith(currentTable.Properties.VariableNames, 'R_finger_y'));
        
        % Append the extracted columns to the combined tables
        avg_coors_table = [avg_coors_table, avg_coors];
        errors_table = [errors_table, errors];
        finger_coords_table = [finger_coords_table, finger_coords];
    end
end
