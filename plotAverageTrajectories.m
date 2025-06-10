%% plot average trajectory 
to_plot = [1,2,3,4,5,6,7,8,9,10];
%finalTable = reachMetrics_560_d1_t_L_finger;
%dispDay = 1;
%dispReachOutcome = 't';
%dispFinger = 'L';

cmap = lines(length(to_plot));  % You can choose other colormaps if needed
%xCoords = finalTable.avg_X_coor;
%yCoords = finalTable.avg_Y_coor;
%xError = finalTable.xError;
%yError = finalTable.yError;

xCoords = d1_t_combined_means.mean_x;
yCoords = d1_t_combined_means.mean_y;
xError = d1_t_combined_means.sem_x;
yError = d1_t_combined_means.sem_y;

figure;
hold on;
%xCoords = avgXTrajectory;
%yCoords = avgYTrajectory;
%xError = finalTable.xError;
%yError = finalTable.yError;

% Define the transparency value for the edge (alpha)
edgeAlpha = 0.5;  % 0 is fully transparent, 1 is fully opaque
faceAlpha = 0.2;  % Transparency for the face

% Loop through each point to plot the error ellipses
for i = 1:length(xCoords)
    if ~isnan(xCoords(i)) && ~isnan(yCoords(i)) && ~isnan(xError(i)) && ~isnan(yError(i))
        % Define the position and size of the ellipse
        pos = [xCoords(i) - xError(i), yCoords(i) - yError(i), 2*xError(i), 2*yError(i)];
    
        % Create the edge color with transparency
        edgeColorWithAlpha = [cmap(1, :), edgeAlpha];

        % Plot the ellipse with the specified position and curvature
        rectangle('Position', pos, 'Curvature', [1, 1], ...
              'EdgeColor', edgeColorWithAlpha, 'LineWidth', 1.5, ...
              'FaceColor', [cmap(1, :), faceAlpha]);
    end
end

%plot(xCoords, yCoords, 'ro', 'MarkerSize', 5, 'LineWidth', 1);
% Plot the coordinates as a line with a different color for each trajectory
plot(xCoords, yCoords, 'LineWidth', 1, 'Color', cmap(1, :));
% Plot row indices at each coordinate point
% Plot a vertical dashed line at x = 5, with transparency
h = xline(375, '--r', 'LineWidth', 2);  % '--' for dashed line, 'r' for red color
% Set the transparency of the line (Alpha)
h.Color(4) = 0.5;  % Set the alpha (transparency) value, range is 0 (fully transparent) to 1 (fully opaque)
%for idx = 1:length(xCoords)
    % Display row indices as text
%    text(xCoords(idx), yCoords(idx), num2str(idx), 'FontSize', 8, 'Color', cmap(1, :), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
%end
xlabel('X Coordinate');
ylabel('Y Coordinate');
%title(strcat('Average trajectories__Mouse__', mouse, ' day__', num2str(dispDay), '__', dispReachOutcome, ...
%    '_', dispFinger));
ylim([200 450]);
xlim([200 500]);
set(gca, 'YDir', 'reverse');
axis on;
hold off;