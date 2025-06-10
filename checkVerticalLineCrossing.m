function doesCross = checkVerticalLineCrossing(xCoordsInput ...
    , yCoordsInput, lineX)
    % Function to check if a set of coordinates crosses a vertical line
    % 
    % Inputs:
    %   xCoords - Vector of x coordinates
    %   yCoords - Vector of y coordinates
    %   lineX - x-coordinate of the vertical line
    %
    % Outputs:
    %   doesCross - Boolean indicating if the coordinates cross the vertical line

    % Initialize the crossing status
    doesCross = false;
    
    % Ensure xCoords and yCoords are column vectors
    xCoordsInput = xCoordsInput(:);
    yCoordsInput = yCoordsInput(:);

    % Check for crossings
    for i = 1:length(xCoordsInput) - 1
        % Current and next x coordinates
        x1 = xCoordsInput(i);
        x2 = xCoordsInput(i + 1);
        
        % Check if lineX is between x1 and x2
        if (x1 < lineX && x2 > lineX) || (x1 > lineX && x2 < lineX)
            doesCross = true;
            break;
        end
    end
end