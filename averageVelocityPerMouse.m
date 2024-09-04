
% Get the list of column names
colNames = velocity_cols_d10_f.Properties.VariableNames;
% Extract the mouse identifiers from the column names
mouseIDs = regexp(colNames, '_\d{3}_', 'match');
% Flatten the nested cell arrays
mouseIDs = cellfun(@(x) x{1}, mouseIDs, 'UniformOutput', false);
mouseIDs = strrep(mouseIDs, '_', '');  % Remove underscores
% Get the unique mouse IDs
uniqueMouseIDs = unique(mouseIDs);
% Initialize a new table to store the averages
averagedTable = table();
% Loop through each unique mouse ID
for i = 1:length(uniqueMouseIDs)
    % Find the columns corresponding to the current mouse ID
    currentMouse = uniqueMouseIDs{i};
    colsForMouse = contains(colNames, ['_' currentMouse '_']);
    
    % Extract the relevant columns and calculate the average
    dataForMouse = velocity_cols_d10_f{:, colsForMouse};
    meanDataForMouse = mean(dataForMouse, 2, 'omitnan');  % Calculate the average across columns
    
    % Store the result in the new table
    averagedTable.(sprintf('avg_velocity_%s', currentMouse)) = meanDataForMouse;
end
% Display the resulting averaged table
disp(averagedTable);
