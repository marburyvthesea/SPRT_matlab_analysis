function crossingIndices = findCrossingIndices(xCoordTable, xValue)
    % Initialize a structure to hold crossing indices for each column
    crossingIndices = struct();

    % Iterate through each column in the xCoordTable
    for col = 1:width(xCoordTable)
        % Get the current column of x-coordinates
        xCoords = xCoordTable{:, col};

        % Find the first index where the crossing occurs
        crossingIdx = find((xCoords(1:end-1) < xValue & xCoords(2:end) >= xValue) | ...
                           (xCoords(1:end-1) > xValue & xCoords(2:end) <= xValue), 1);

        % Store the index in the output structure with the column name
        if ~isempty(crossingIdx)
            crossingIndices.(xCoordTable.Properties.VariableNames{col}) = crossingIdx;
        else
            crossingIndices.(xCoordTable.Properties.VariableNames{col}) = NaN;  % No crossing found
        end
    end
end
