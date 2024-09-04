% Function to rename columns by appending mouse number
function renamedTable = renameColumnsWithMouseAndBodyPart(tableVar, mouseNum, bodyPart)
    % Get the current variable names in the table
    varNames = tableVar.Properties.VariableNames;
    
    % Create new variable names by appending mouse number and body part
    renamedVarNames = strcat(varNames, '_', mouseNum, '_', bodyPart);
    
    % Assign the new variable names to the table
    tableVar.Properties.VariableNames = renamedVarNames;
    
    % Return the renamed table
    renamedTable = tableVar;
end


