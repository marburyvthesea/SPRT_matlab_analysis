function movement_direction = determineMovementDirection(mean_x)
    % Determine the differences between consecutive x coordinates
    diff_x = diff(mean_x);
    
    % Initialize the movement direction array with ones
    movement_direction = ones(size(mean_x));  % Default first element is 1
    
    % Assign 1 for forward movement, -1 for backward movement
    movement_direction(2:end) = sign(diff_x);
end
