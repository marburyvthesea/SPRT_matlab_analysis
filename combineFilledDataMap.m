function combinedTable = combineFilledDataMap(filledDataMap, frames_list)
    % Initialize an empty table to hold all combined data
    combinedTable = table();

    % Iterate through each frame in frames_list
    for i = 1:length(frames_list)
        frameKey = frames_list(i);
        
        if isKey(filledDataMap, frameKey)
            exampleSubset = filledDataMap(frameKey);
            
            % Rename variables to include the frame key for differentiation
            exampleSubset = renamevars(exampleSubset, ...
                exampleSubset.Properties.VariableNames, ...
                strcat(exampleSubset.Properties.VariableNames, '_', num2str(frameKey)));
            
            % Concatenate the current exampleSubset table horizontally
            combinedTable = [combinedTable, exampleSubset];
        end
    end
end
