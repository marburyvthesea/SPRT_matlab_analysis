function [avgByMouse] = avgColumnsByMouse(inputTable)

% Get the list of column names
colNames = inputTable.Properties.VariableNames;

% Extract the mouse identifiers and finger type from the column names
mouseFingerIDs = regexp(colNames, '_\d{3}_(L_finger|R_finger)', 'match');

% Flatten the nested cell arrays
mouseFingerIDs = cellfun(@(x) x{1}, mouseFingerIDs, 'UniformOutput', false);

% Get the unique mouse/finger ID combinations
uniqueMouseFingerIDs = unique(mouseFingerIDs);

% Initialize a new table to store the averages
avgByMouse = table();

% Loop through each unique mouse/finger ID combination
for i = 1:length(uniqueMouseFingerIDs)
    % Find the columns corresponding to the current mouse/finger ID combination
    currentCombo = uniqueMouseFingerIDs{i};
    colsForCombo = contains(colNames, currentCombo);
    
    % Extract the relevant columns and calculate the average
    dataForCombo = inputTable{:, colsForCombo};
    meanDataForCombo = mean(dataForCombo, 2, 'omitnan');  % Calculate the average across columns
    
    % Store the result in the new table
    % Create a descriptive column name
    newColumnName = sprintf('avg_velocity_%s', strrep(currentCombo, '_', '_'));
    avgByMouse.(newColumnName) = meanDataForCombo;
end

% Display the resulting averaged table
disp(avgByMouse);

end 
