function [dataTable] = calcEuclidDistColumnPairs(coordinatePairs,dataTable)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% Initialize the new columns with NaN values
for k = 1:size(coordinatePairs, 1)
    colName = strcat(coordinatePairs{k, 1}(1:end-2), '_delta');
    dataTable.(colName) = nan(height(dataTable), 1);
end

% Calculate Euclidean distance between successive frames
for k = 1:size(coordinatePairs, 1)
    xCol = coordinatePairs{k, 1};
    yCol = coordinatePairs{k, 2};
    
    % Compute Euclidean distance between successive frames
    delta = sqrt(diff(dataTable.(xCol)).^2 + diff(dataTable.(yCol)).^2);
    
    % Assign the calculated delta to the new column
    colName = strcat(coordinatePairs{k, 1}(1:end-2), '_delta');
    dataTable.(colName)(2:end) = delta; % Start from the second frame
end


end