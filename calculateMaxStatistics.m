function [averageMaxValue, stdMaxValue] = calculateMaxStatistics(velocityTable)
    % Get the number of columns in the table
    numColumns = width(velocityTable);
    
    % Initialize an array to hold the maximum values for each column
    maxValues = zeros(numColumns, 1);
    
    % Iterate through each column in the table
    for i = 1:numColumns
        % Get the current velocity column
        currentVelocities = velocityTable{:, i};
        
        % Ensure the column is not empty and contains numeric data
        if ~isempty(currentVelocities) && isnumeric(currentVelocities)
            % Find the maximum value of the current column
            maxValues(i) = max(currentVelocities, [], 'omitnan');
        else
            % Assign NaN if the column is empty or non-numeric
            maxValues(i) = NaN;
        end
    end

    % Calculate the average maximum value, ignoring NaNs
    averageMaxValue = nanmean(maxValues);
    
    % Calculate the standard deviation of the maximum values, ignoring NaNs
    stdMaxValue = nanstd(maxValues);
end

