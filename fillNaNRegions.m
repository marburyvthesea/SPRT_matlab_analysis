function filledDataMap = fillNaNRegions(dataMapInput, frames_listInput, bodyPartNameInput)
    % Initialize the filled data map as a copy of the original data map
    filledDataMap = containers.Map('KeyType', 'double', 'ValueType', 'any');

    for crossingIdx = 1:length(frames_listInput)
        % Retrieve trajectories for each reach period 
        xCoords = dataMapInput(frames_listInput(crossingIdx)).(sprintf('%s_x', bodyPartNameInput));
        yCoords = dataMapInput(frames_listInput(crossingIdx)).(sprintf('%s_y', bodyPartNameInput));
        
        % Fill NaNs in xCoords
        xCoords = fillNaNs(xCoords);
        % Fill NaNs in yCoords
        yCoords = fillNaNs(yCoords);
        
        % Create a table to store the filled coordinates
        filledTable = table(xCoords, yCoords, 'VariableNames', {sprintf('%s_x', bodyPartNameInput), sprintf('%s_y', bodyPartNameInput)});
        
        % Store the table in the filled data map
        filledDataMap(frames_listInput(crossingIdx)) = filledTable;
        
    end
end

