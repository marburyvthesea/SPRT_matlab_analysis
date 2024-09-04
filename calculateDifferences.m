function differenceTable = calculateDifferences(t_1, t_2)
    % Get the list of column names from both tables
    names_t = t_1.Properties.VariableNames;
    names_f = t_2.Properties.VariableNames;

    % Find the overlapping (shared) column names
    sharedNames = intersect(names_t, names_f);

    % Initialize an empty table to store the differences
    differenceTable = table();

    % Loop through each shared name and calculate the difference
    for i = 1:length(sharedNames)
        % Extract the data from both tables
        data_t = t_1.(sharedNames{i});
        data_f = t_2.(sharedNames{i});
        
        % Calculate the difference
        delta = data_t - data_f;
        
        % Store the difference in the new table with 'delta_' prepended to the name
        differenceTable.(sprintf('delta_%s', sharedNames{i})) = delta;
    end
end

