function correctedTable = correctOutlierCoordinates(dataTable, distanceColumns, stdThreshold)
    % Function to correct coordinates where standard deviation exceeds a threshold
    %
    % Inputs:
    %   dataTable - The table containing coordinate and standard deviation columns
    %   distanceColumns - Cell array of column names for displacement standard deviation
    %   stdThreshold - Threshold value for standard deviation
    %
    % Outputs:
    %   correctedTable - Table with corrected coordinates
    
    % Initialize corrected table as a copy of the original dataTable with
    % subset of columns 
    
    correctedTable = dataTable ;

% Iterate over each base distance column name
    for i = 1:length(distanceColumns)
        % Base column name for displacement
        baseCol = distanceColumns{i};
        
        % Construct the corresponding standard deviation column name
        stdDevCol = strcat(baseCol, '_rel_std_dev');
        
        % Construct coordinate column names
        % Iterate over each base distance column name
    for i = 1:length(distanceColumns)
        % Base column name for displacement
        baseCol = distanceColumns{i};
        
        % Construct the corresponding standard deviation column name
        stdDevCol = strcat(baseCol, '_rel_std_dev');
        
        % Construct coordinate column names
        baseColCoor = strrep(stdDevCol, '_delta_rel_std_dev', '');
        xCol = strcat(baseColCoor, '_x');
        yCol = strcat(baseColCoor, '_y');
        
        % Construct likelihood column name
        likelihoodCol = strcat(baseColCoor, '_likelihood');

        % Check if both standard deviation and coordinate columns exist
        if ismember(stdDevCol, correctedTable.Properties.VariableNames) && ...
           ismember(xCol, correctedTable.Properties.VariableNames) && ...
           ismember(yCol, correctedTable.Properties.VariableNames) && ...
           ismember(likelihoodCol, correctedTable.Properties.VariableNames)

            % Identify rows where standard deviation exceeds the threshold
            exceedingIndices = find(correctedTable.(stdDevCol) > stdThreshold);
            
            if ~isempty(exceedingIndices)
                % Iterate over indices where the standard deviation exceeds the threshold
                for idx = exceedingIndices'
                    % Ensure there are valid preceding and following points
                    if idx > 1 && idx < height(correctedTable)
                        % Average of preceding and following points
                        prevIdx = idx - 1;
                        nextIdx = idx + 1;
                        
                        % Compute the average coordinates
                        avgX = (correctedTable.(xCol)(prevIdx) + correctedTable.(xCol)(nextIdx)) / 2;
                        avgY = (correctedTable.(yCol)(prevIdx) + correctedTable.(yCol)(nextIdx)) / 2;
                        
                        % Replace the coordinates at the index with the average
                        correctedTable.(xCol)(idx) = avgX;
                        correctedTable.(yCol)(idx) = avgY;

                        % Update the likelihood column to 'outliercorrected'
                        correctedTable.(likelihoodCol)(idx) = NaN;

                    end
                end
            end
        else
            warning('Column %s, %s, or %s does not exist in dataTable.', stdDevCol, xCol, yCol);
        end
    end
        xCol = strcat(baseCol, '_x');
        yCol = strcat(baseCol, '_y');
        
        % Check if both standard deviation and coordinate columns exist
        if ismember(stdDevCol, correctedTable.Properties.VariableNames) && ...
           ismember(xCol, correctedTable.Properties.VariableNames) && ...
           ismember(yCol, correctedTable.Properties.VariableNames)
           
            % Identify rows where standard deviation exceeds the threshold
            exceedingIndices = find(correctedTable.(stdDevCol) > stdThreshold);
            
            if ~isempty(exceedingIndices)
                % Iterate over indices where the standard deviation exceeds the threshold
                for idx = exceedingIndices'
                    % Ensure there are valid preceding and following points
                    if idx > 1 && idx < height(correctedTable)
                        % Average of preceding and following points
                        prevIdx = idx - 1;
                        nextIdx = idx + 1;
                        
                        % Compute the average coordinates
                        avgX = (correctedTable.(xCol)(prevIdx) + correctedTable.(xCol)(nextIdx)) / 2;
                        avgY = (correctedTable.(yCol)(prevIdx) + correctedTable.(yCol)(nextIdx)) / 2;
                        
                        % Replace the coordinates at the index with the average
                        correctedTable.(xCol)(idx) = avgX;
                        correctedTable.(yCol)(idx) = avgY;
                    end
                end
            end
        else
            warning('Column %s, %s, or %s does not exist in dataTable.', stdDevCol, xCol, yCol);
        end
    end

baseCols = strrep(distanceColumns, '_delta', '');
xCols = strcat(baseCols, '_x');
yCols = strcat(baseCols, '_y');
likelihoodCols = strcat(baseCols, '_likelihood');
correctedTable = correctedTable(:, [xCols, yCols, likelihoodCols]);

end