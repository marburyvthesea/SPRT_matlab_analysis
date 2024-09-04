function saveDataMap(filledDataMap, fileName)
    % Convert containers.Map to struct for saving
    mapStruct = struct();
    keysList = keys(filledDataMap);
    for i = 1:length(keysList)
        key = keysList{i};
        mapStruct.(key) = filledDataMap(key);
    end
    
    % Save the struct to a .mat file
    save(fileName, 'mapStruct');
end