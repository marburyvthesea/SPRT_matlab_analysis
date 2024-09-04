function dataMap = selectRegionsFromDLC(dataMap, frames_list, numSubsetFramesToSave, correctedTable)
    % Ensure dataMap is a containers.Map
    if isempty(dataMap)
        dataMap = containers.Map('KeyType', 'double', 'ValueType', 'any');
    end
    
    desiredLength = numSubsetFramesToSave * 2 + 1;
    % Iterate through each frame number in frames_list
    for i = 1:length(frames_list)
        reachFrame = frames_list(i);    
        
        % Calculate the range of rows to extract
        startFrame = max(1, reachFrame - numSubsetFramesToSave);
        endFrame = min(height(correctedTable), reachFrame + numSubsetFramesToSave);
        
        % Extract the subset of rows for the current frame
        subsetTable = correctedTable(startFrame:endFrame, :);
        
        if height(subsetTable) < desiredLength
            % Calculate how many rows of NaNs need to be added
            numRowsToAdd = desiredLength - height(subsetTable);
            
            % Create a table of NaNs with the appropriate number of rows
            nanTable = array2table(NaN(numRowsToAdd, width(subsetTable)), ...
                                   'VariableNames', subsetTable.Properties.VariableNames);
            
            % Append the NaN rows to the end of subsetTable
            subsetTable = [subsetTable; nanTable];
        end

        % Store the subset table in the map with the frame index as the key
        dataMap(reachFrame) = subsetTable;
    end
end