function [averageTrajectory, stdTrajectory] = calculateAverageTrajectory(bodyPartNameInput, dataMapInput, frames_listInput)
    % Get the length of the trajectories from the first entry
    exampleTrajectory = dataMapInput(frames_listInput(1)).(sprintf('%s_x', bodyPartNameInput));
    trajLength = length(exampleTrajectory);

    % Initialize arrays to store all trajectories
    allXCoords = zeros(length(frames_listInput), trajLength);
    allYCoords = zeros(length(frames_listInput), trajLength);

    % Retrieve and store trajectories for each reach period
    for crossingIdx = 1:length(frames_listInput)
        allXCoords(crossingIdx, :) = dataMapInput(frames_listInput(crossingIdx)).(sprintf('%s_x', bodyPartNameInput));
        allYCoords(crossingIdx, :) = dataMapInput(frames_listInput(crossingIdx)).(sprintf('%s_y', bodyPartNameInput));
    end

    % Calculate the average and standard deviation for each point
    avgX = nanmean(allXCoords, 1);
    avgY = nanmean(allYCoords, 1);
    stdX = nanstd(allXCoords, 0, 1);
    stdY = nanstd(allYCoords, 0, 1);

    % Combine average trajectories into one array
    averageTrajectory = [avgX', avgY'];
    % Combine standard deviations into one array
    stdTrajectory = [stdX', stdY'];
end