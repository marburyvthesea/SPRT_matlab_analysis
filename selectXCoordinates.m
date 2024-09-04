function xCoordTable = selectXCoordinates(combinedTable, bodyPartName)
    % Define the pattern to match x coordinate columns
    pattern = strcat(bodyPartName, '_x_');

    % Get the list of all variable names (columns) in the combined table
    allVars = combinedTable.Properties.VariableNames;

    % Find the columns that match the pattern
    xCoordColumns = allVars(contains(allVars, pattern));

    % Create a new table with just the x coordinate columns
    xCoordTable = combinedTable(:, xCoordColumns);
end
