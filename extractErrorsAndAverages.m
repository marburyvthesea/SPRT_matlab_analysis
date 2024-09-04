function [avg_coors_table, errors_table] = extractErrorsAndAverages(varsList)
% Initialize empty tables to store the combined data
avg_coors_table = table();  % To store 'avg_X_coor' and 'avg_Y_coor'
errors_table = table();     % To store 'xError' and 'yError'

% Loop through each variable name in d10_f_vars
for i = 1:length(varsList)
    % Get the table from the workspace
    %disp(varsList{i})
    currentTable = evalin('base', varsList{i});
    
    % Extract columns that start with 'avg_X_coor' or 'avg_Y_coor'
    avg_coors = currentTable(:, startsWith(currentTable.Properties.VariableNames, 'avg_X_coor') | ...
                                startsWith(currentTable.Properties.VariableNames, 'avg_Y_coor'));
    
    % Extract columns that start with 'xError' or 'yError'
    errors = currentTable(:, startsWith(currentTable.Properties.VariableNames, 'xError') | ...
                               startsWith(currentTable.Properties.VariableNames, 'yError'));
    
    % Append the extracted columns to the combined tables
    avg_coors_table = [avg_coors_table, avg_coors];
    errors_table = [errors_table, errors];
end
end