function updatedTable = replaceCoordinatesBelowLikelihood(dataTable, baseColumns, likelihoodThreshold)
    % Function to replace coordinates with NaN if likelihood is below a given threshold
    %
    % Inputs:
    %   dataTable - The table containing coordinate and likelihood columns
    %   distanceColumns - Cell array of base column names for coordinates (without '_x', '_y', '_likelihood')
    %   likelihoodThreshold - Threshold value for likelihood
    %
    % Outputs:
    %   updatedTable - Table with coordinates replaced by NaN where likelihood is below threshold
    
    % Copy the original table to update it
    updatedTable = dataTable;
    
    % Iterate over each base distance column name
    for i = 1:length(baseColumns)
        % Base column name for coordinates
        baseCol = baseColumns{i};
        
        % Construct coordinate column names
        xCol = strcat(baseCol, '_x');
        yCol = strcat(baseCol, '_y');
        
        % Construct likelihood column name
        likelihoodCol = strcat(baseCol, '_likelihood');
        
        % Check if all necessary columns exist
        if ismember(xCol, dataTable.Properties.VariableNames) && ...
           ismember(yCol, dataTable.Properties.VariableNames) && ...
           ismember(likelihoodCol, dataTable.Properties.VariableNames)
           
            % Find indices where likelihood is below the threshold
            lowLikelihoodIndices = dataTable.(likelihoodCol) < likelihoodThreshold;
            
            % Replace coordinates with NaN where likelihood is below the threshold
            updatedTable.(xCol)(lowLikelihoodIndices) = NaN;
            updatedTable.(yCol)(lowLikelihoodIndices) = NaN;
        else
            warning('Column %s, %s, or %s does not exist in dataTable.', xCol, yCol, likelihoodCol);
        end
    end
end