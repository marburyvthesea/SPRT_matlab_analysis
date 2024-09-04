function [combinedTable] = concatVelocityAndError(velocityTable, errorTable)

% Get the list of column names for both tables
colNames_velocity = velocityTable.Properties.VariableNames;
colNames_errors = errorTable.Properties.VariableNames;
% Standardize the variable names in meanErrors_d1_t by removing the trailing "_t" or "_f"
colNames_errors_standard = regexprep(colNames_errors, '_[tf]$', '');
% Update the variable names in meanErrors_d1_t
errorTable.Properties.VariableNames = colNames_errors_standard;
% Extract the mouse and finger identifiers from the end of the column names
sharedIdentifiers_velocity = regexp(colNames_velocity, '(\d{3}_(L_finger|R_finger))$', 'tokens', 'once');
sharedIdentifiers_errors = regexp(colNames_errors_standard, '(\d{3}_(L_finger|R_finger))$', 'tokens', 'once');
% Flatten the cell arrays
sharedIdentifiers_velocity = cellfun(@(x) x{1}, sharedIdentifiers_velocity, 'UniformOutput', false);
sharedIdentifiers_errors = cellfun(@(x) x{1}, sharedIdentifiers_errors, 'UniformOutput', false);
%%
% Find the indices in the velocity table that match those in the error table
[~, idx_velocity] = ismember(sharedIdentifiers_velocity, sharedIdentifiers_errors);
% Find the indices in the error table that match those in the velocity table
[~, idx_errors] = ismember(sharedIdentifiers_errors, sharedIdentifiers_velocity);
%%
% Reorder the columns in meanErrors_d1_t to match the order in meanOverallVelocity_d1_t
meanErrors_ordered = errorTable(:, idx_errors(idx_errors > 0));
meanOverallVelocity_ordered = velocityTable(:, idx_velocity(idx_velocity > 0));
%%
% Remove the differing leading portions of the variable names
meanErrors_ordered.Properties.VariableNames = sharedIdentifiers_errors(idx_errors > 0);
meanOverallVelocity_ordered.Properties.VariableNames = sharedIdentifiers_velocity(idx_velocity > 0);
%%
combinedTable = [meanOverallVelocity_ordered; meanErrors_ordered];
% Display the combined table
disp(combinedTable);

end
