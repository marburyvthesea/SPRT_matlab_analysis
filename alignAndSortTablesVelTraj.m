function [max_Velocity_d1_t_sorted, meanTrajError_d1_t_sorted] = alignAndSortTablesVelTraj(max_Velocity_d1_t, meanTrajError_d1_t)
    % Extract the variable names from both tables
    velocityVarNames = max_Velocity_d1_t.Properties.VariableNames;
    errorVarNames = meanTrajError_d1_t.Properties.VariableNames;
    
    % Initialize cell arrays to store the parsed identifiers
    velocityIdentifiers = cell(1, length(velocityVarNames));
    errorIdentifiers = cell(1, length(errorVarNames));
    
    % Extract identifiers from velocity table
    for i = 1:length(velocityVarNames)
        tokens = regexp(velocityVarNames{i}, 'velocity_frameIdx_(\d+)_\d{3}_(L_finger|R_finger)', 'tokens');
        if ~isempty(tokens)
            velocityIdentifiers{i} = [tokens{1}{1}, '_', tokens{1}{2}];
        end
    end
    
    % Extract identifiers from error table
    for i = 1:length(errorVarNames)
        tokens = regexp(errorVarNames{i}, '(\d+)_\d{3}_(L_finger|R_finger)_diff', 'tokens');
        if ~isempty(tokens)
            errorIdentifiers{i} = [tokens{1}{1}, '_', tokens{1}{2}];
        end
    end
    
    % Find the intersection of identifiers and their corresponding indices
    [commonIdentifiers, velocityIdx, errorIdx] = intersect(velocityIdentifiers, errorIdentifiers, 'stable');
    
    % Sort the columns of both tables according to the common identifiers
    max_Velocity_d1_t_sorted = max_Velocity_d1_t(:, velocityIdx);
    meanTrajError_d1_t_sorted = meanTrajError_d1_t(:, errorIdx);
    
       % Remove columns with any 0 values in the sorted tables
    columnsToKeep = true(1, length(commonIdentifiers));  % Initialize all columns to be kept
    for i = 1:length(commonIdentifiers)
        if any(max_Velocity_d1_t_sorted{:, i} == 0) || any(meanTrajError_d1_t_sorted{:, i} == 0)
            columnsToKeep(i) = false;  % Mark columns for removal if any 0s are found
        end
    end
    
    % Filter the columns to keep only those without any 0 values
    max_Velocity_d1_t_sorted = max_Velocity_d1_t_sorted(:, columnsToKeep);
    meanTrajError_d1_t_sorted = meanTrajError_d1_t_sorted(:, columnsToKeep);

    % Display a message if any identifiers didn't match
    if length(commonIdentifiers) ~= length(velocityIdentifiers) || length(commonIdentifiers) ~= length(errorIdentifiers)
        disp('Warning: Not all columns could be aligned.');
    end
    
    % Append "_sorted" to the names of the sorted tables
    max_Velocity_d1_t_sorted.Properties.Description = 'max_Velocity_d1_t_sorted';
    meanTrajError_d1_t_sorted.Properties.Description = 'meanTrajError_d1_t_sorted';
end