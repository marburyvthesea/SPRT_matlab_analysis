function [euclideanErrorsTable] = calcEuclideanErrorPerMouse(errorsTable)

% Initialize an empty table to store the euclidean errors
euclideanErrorsTable = table();
% Get the list of all variable names in the table
varNames = errorsTable.Properties.VariableNames;
% Extract the unique mouse/body part combinations
mouse_body_parts = unique(regexprep(varNames, {'^xError_', '^yError_'}, ''));
% Loop through each unique mouse/body part combination
for i = 1:length(mouse_body_parts)
    % Extract the current mouse/body part combination
    currentCombo = mouse_body_parts{i};
    
    % Find the corresponding xError and yError columns
    xError_col = errorsTable{:, sprintf('xError_%s', currentCombo)};
    yError_col = errorsTable{:, sprintf('yError_%s', currentCombo)};
    
    % Calculate the Euclidean error
    euclideanError = sqrt(xError_col.^2 + yError_col.^2);
    
    % Store the Euclidean error in the new table
    euclideanErrorsTable.(sprintf('euclideanError_%s', currentCombo)) = euclideanError;
end

end 



