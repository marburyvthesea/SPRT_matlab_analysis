function [avgXTrajectory, avgYTrajectory, stdXTrajectory, stdYTrajectory] = calculateTrajectoryStatistics(combinedTable)
    % Initialize arrays to store all x and y coordinates
    xCoordsAll = [];
    yCoordsAll = [];

    % Get all variable names in the table
    allVarNames = combinedTable.Properties.VariableNames;

    % Loop through the variable names to extract x and y coordinates
    for i = 1:2:length(allVarNames)
        % Assuming x and y columns are in pairs and labeled as 'idx1_x', 'idx1_y', etc.
        xColumn = combinedTable.(allVarNames{i});
        yColumn = combinedTable.(allVarNames{i+1});
        
        % Append to arrays
        xCoordsAll = [xCoordsAll, xColumn];
        yCoordsAll = [yCoordsAll, yColumn];
    end

    % Calculate average and standard deviation for x and y trajectories
    avgXTrajectory = mean(xCoordsAll, 2, 'omitnan');
    avgYTrajectory = mean(yCoordsAll, 2, 'omitnan');
    stdXTrajectory = std(xCoordsAll, 0, 2, 'omitnan');
    stdYTrajectory = std(yCoordsAll, 0, 2, 'omitnan');
end
