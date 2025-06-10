function coords = fillNaNs(coords)
    % Find indices of NaNs
    nanIndices = isnan(coords);
    % If there are no NaNs, return the original coordinates
    if ~any(nanIndices)
        return;
    end
    
    % Find the start and end indices of consecutive NaNs
    nanStarts = find(diff([0; nanIndices; 0]) == 1);
    nanEnds = find(diff([0; nanIndices; 0]) == -1) - 1;

    % Iterate over each NaN region and fill with interpolated values
    for k = 1:length(nanStarts)
        startIdx = nanStarts(k) - 1; % Index before the NaN region
        endIdx = nanEnds(k) + 1; % Index after the NaN region
        
        if startIdx < 1 || endIdx > length(coords)
            continue; % Skip if the region is out of bounds
        end
        
        % Calculate the linear interpolation
        delta = (coords(endIdx) - coords(startIdx)) / (endIdx - startIdx);
        for idx = startIdx+1:endIdx-1
            coords(idx) = coords(idx - 1) + delta;
        end
    end
end