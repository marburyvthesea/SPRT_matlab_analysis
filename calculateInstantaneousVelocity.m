function velocityTable = calculateInstantaneousVelocity(bodyPartNameInput, dataMapInput, frames_listInput)
    % Initialize a table to store velocities for each reach period
    velocityTable = table();

    for crossingIdx = 1:length(frames_listInput)
        % Retrieve the current frame index
        frameIdx = frames_listInput(crossingIdx);
        
        % Retrieve trajectories for each reach period 
        xCoords = dataMapInput(frameIdx).(sprintf('%s_x', bodyPartNameInput));
        yCoords = dataMapInput(frameIdx).(sprintf('%s_y', bodyPartNameInput));
        
        % Calculate velocity
        if length(xCoords) > 1
            velocities = zeros(length(xCoords) - 1, 1);
            for i = 1:length(velocities)
                dx = xCoords(i + 1) - xCoords(i);
                dy = yCoords(i + 1) - yCoords(i);
                velocities(i) = sqrt(dx^2 + dy^2);
            end
            
            % Create a column name for the table based on the frame index
            colName = sprintf('velocity_frameIdx_%d', frameIdx);
            
            % Add the velocities as a new column to the table
            velocityTable.(colName) = velocities;
        end
    end
end