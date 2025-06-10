function dataTable = addStandardDeviationColumns(dataTable, distanceColumns)
% Function to compute the standard deviation relative to the mean for
    % each displacement column and append these as new columns to dataTable
    % 
    % Inputs:
    %   dataTable - The table containing displacement columns
    %   distanceColumns - Cell array of column names for which to compute standard deviation
    %
    % Outputs:
    %   dataTable - Updated table with additional standard deviation columns

    % Loop through each column in distanceColumns
    for i = 1:length(distanceColumns)
        % Get the column name
        deltaCol = distanceColumns{i};
        
        % Check if column exists in dataTable
        if ismember(deltaCol, dataTable.Properties.VariableNames)
            % Get displacement values
            displacements = dataTable.(deltaCol);
            
            % Compute mean and standard deviation of non-NaN values
            meanVal = nanmean(displacements);
            stdDev = nanstd(displacements);
            
            % Compute relative standard deviation (SD/mean)
            relativeStdDev = (displacements - meanVal) / stdDev;
            
            % Create new column name for the relative standard deviation
            newColName = strcat(deltaCol, '_rel_std_dev');
            
            % Append new column to dataTable
            dataTable.(newColName) = relativeStdDev;
        else
            warning('Column %s does not exist in dataTable.', deltaCol);
        end
    end
end