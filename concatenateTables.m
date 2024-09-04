function concatenatedTable = concatenateTables(varNamesArray)
    concatenatedTable = table();  % Initialize an empty table
    
    for i = 1:length(varNamesArray)
        % Get the variable name from the cell array
        varName = varNamesArray{i};
        
        % Ensure the variable exists in the workspace
        if evalin('base', sprintf('exist(''%s'', ''var'')', varName))
            % Retrieve the table from the base workspace
            currentTable = evalin('base', varName);
            
            disp(varName);

            % Concatenate the tables horizontally
            concatenatedTable = [concatenatedTable, currentTable];
        
        else
            warning('Variable %s does not exist in the workspace.', varName);
        end
    end
end
