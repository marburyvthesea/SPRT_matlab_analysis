% Loop over each variable and save it to a CSV file
for i = 1:length(varsList)
    % Get the variable from the workspace
    currentVar = evalin('base', varsList{i});
    
    % Generate a file name based on the variable name
    fileName = sprintf('%s.csv', varsList{i});
    
    % Save the table to a CSV file
    writetable(currentVar, fileName);
end
