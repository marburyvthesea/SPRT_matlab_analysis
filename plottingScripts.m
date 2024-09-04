%% e.g. access one surrounding frame region to plot on image 
% Define the image file name
imageFileName = 'mouse547_day1_frame28106.png';
% Load the image
img = imread(imageFileName);
% Load the subset data
% Assuming exampleSubset is already defined and contains the columns 'R_finger_x' and 'R_finger_y'
crossingIdx = 1 ;
exampleSubset = filledDataMap(frames_list(crossingIdx));
xCoords = exampleSubset.L_finger_x;
yCoords = exampleSubset.L_finger_y;
% Create a figure
figure;
imshow(img);
hold on; % Allow overlaying plots on the image
% Plot the coordinates on the image
plot(xCoords, yCoords, 'ro', 'MarkerSize', 5, 'LineWidth', 1);
xlabel('X Coordinate');
ylabel('Y Coordinate');
title('Coordinates on Image');
axis on;
hold off; % Release the plot hold

%% plot individual trajectories

szTable = size(combinedTable);
rows=szTable(1,2);
firstplot=1;
numplot=rows;
to_plot = linspace(firstplot,numplot,numplot); 

cmap = lines(length(to_plot));  % You can choose other colormaps if needed
figure;
hold on;
for cI = 1:2:length(to_plot)

    crossingIdx = to_plot(cI);

    exampleSubset = combinedTable(:,cI:cI+1);
    xCoords = table2array(exampleSubset(:,1));
    yCoords = table2array(exampleSubset(:,2));
    plot(xCoords, yCoords, 'ro', 'MarkerSize', 5, 'LineWidth', 1, 'Color', cmap(cI, :));
    % Plot the coordinates as a line with a different color for each trajectory
    plot(xCoords, yCoords, 'LineWidth', 1, 'Color', cmap(cI, :));
    % Plot a vertical dashed line at x = 5, with transparency
    h = xline(375, '--r', 'LineWidth', 2);  % '--' for dashed line, 'r' for red color
    % Set the transparency of the line (Alpha)
    h.Color(4) = 0.5;  % Set the alpha (transparency) value, range is 0 (fully transparent) to 1 (fully opaque)
    %title(strcat('Frame', num2str(correctedFrameIndicies(crossingIdx))));

    % Plot row indices at each coordinate point
    for idx = 1:length(xCoords)
        % Display row indices as text
        text(xCoords(idx), yCoords(idx), num2str(idx), 'FontSize', 8, 'Color', cmap(cI, :), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end

end
xlabel('X Coordinate');
ylabel('Y Coordinate');
%title(strcat('Frame', num2str(correctedFrameIndicies(crossingIdx))));

ylim([100 500]);
xlim([100 500]);
set(gca, 'YDir', 'reverse');
axis on;
hold off;

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

xCoords = mean_x;
yCoords = mean_y;
xError = sem_x;
yError = sem_y;

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

plot(xCoords, yCoords, 'ro', 'MarkerSize', 5, 'LineWidth', 1);
% Plot the coordinates as a line with a different color for each trajectory
plot(xCoords, yCoords, 'LineWidth', 1, 'Color', cmap(1, :));
% Plot row indices at each coordinate point
% Plot a vertical dashed line at x = 5, with transparency
h = xline(375, '--r', 'LineWidth', 2);  % '--' for dashed line, 'r' for red color
% Set the transparency of the line (Alpha)
h.Color(4) = 0.5;  % Set the alpha (transparency) value, range is 0 (fully transparent) to 1 (fully opaque)
for idx = 1:length(xCoords)
    % Display row indices as text
    text(xCoords(idx), yCoords(idx), num2str(idx), 'FontSize', 8, 'Color', cmap(1, :), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end
xlabel('X Coordinate');
ylabel('Y Coordinate');
%title(strcat('Average trajectories__Mouse__', mouse, ' day__', num2str(dispDay), '__', dispReachOutcome, ...
%    '_', dispFinger));
ylim([200 450]);
xlim([200 500]);
set(gca, 'YDir', 'reverse');
axis on;
hold off;
%% plot velocity
% Example data
% d10_f_mean, d10_t_mean, d1_f_mean, d1_t_mean are the mean velocity values (e.g., 101x1 arrays)
% d10_f_sem, d10_t_sem, d1_f_sem, d1_t_sem are the standard error values (e.g., 101x1 arrays)

% Define x-axis values (assuming the data points are evenly spaced)
x = 1:length(d10_f_mean);

% Create a new figure
figure;
hold on;

% Plot d10_f data with shaded error region
plot(x, d10_f_mean, 'r', 'LineWidth', 2);
fill([x, fliplr(x)], [d10_f_mean' + d10_f_sem', fliplr(d10_f_mean' - d10_f_sem')], ...
    'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

% Plot d10_t data with shaded error region
plot(x, d10_t_mean, 'g', 'LineWidth', 2);
fill([x, fliplr(x)], [d10_t_mean' + d10_t_sem', fliplr(d10_t_mean' - d10_t_sem')], ...
    'g', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

% Plot d1_f data with shaded error region
plot(x, d1_f_mean, 'b', 'LineWidth', 2);
fill([x, fliplr(x)], [d1_f_mean' + d1_f_sem', fliplr(d1_f_mean' - d1_f_sem')], ...
    'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

% Plot d1_t data with shaded error region
plot(x, d1_t_mean, 'm', 'LineWidth', 2);
fill([x, fliplr(x)], [d1_t_mean' + d1_t_sem', fliplr(d1_t_mean' - d1_t_sem')], ...
    'm', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

% Customize the plot
xlabel('Time (or other x-axis label)');
ylabel('Mean Velocity');
title('Mean Velocity with Standard Error');
legend({'d10_f', 'd10_t', 'd1_f', 'd1_t'}, 'Location', 'Best');
grid on;
hold off;


%% plot velocity against x coordinate 

%cmap = lines(length(to_plot));  % You can choose other colormaps if needed
figure;
hold on;

plot(d10_f_combined_means.mean_x, vector_x_velocity_d10_f)

% Calculate the upper and lower bounds for the shaded region
upper_bound = vector_x_velocity + d10_f_sem;
lower_bound = vector_x_velocity - d10_f_sem;

% Define the x values
x = d10_f_combined_means.mean_x;
% Plot the shaded error region
fill([x; flipud(x)], [upper_bound; flipud(lower_bound)], ...
    'r', 'FaceAlpha', 0.9, 'EdgeColor', 'none');

xlabel('Mean X Coordinate');
ylabel('Velocity');
title('Velocity ("Vector") vs X coordinate');
h = xline(375, '--r', 'LineWidth', 2);  % '--' for dashed line, 'r' for red color
%ylim([280 380]);
%xlim([300 500]);
%set(gca, 'YDir', 'reverse');
axis on;


hold off;
%% Plot day 1 vs day 10 variance 
data1 = day1errorsCombined{:,:};  % Convert table to array
data2 = day10errorsCombined{:,:};  % Convert table to array

x1 = ones(size(data1)) * 1;  % x = 1 for data1
x2 = ones(size(data2)) * 2;  % x = 2 for data2

% Combine all x and y data
x_all = [x1, x2];
y_all = [data1, data2];

% Create the scatter plot
figure;
scatter(x_all, y_all, 'filled');

xlim([0.5 4.5]);

%% Plot differences in error between reaches on different days
% Assuming delta_d1_t_d10_f_meanPerAnimal, delta_d1_t_d10_t_meanPerAnimal,
% and delta_d1_f_d10_f_meanPerAnimal are your 1xN tables.

% Extract the data from each table and concatenate them into a matrix
data1 = delta_d1_t_d10_f_meanPerAnimal{:,:};  % Convert table to array
data2 = delta_d1_t_d10_t_meanPerAnimal{:,:};  % Convert table to array
data3 = delta_d1_f_d10_f_meanPerAnimal{:,:};  % Convert table to array
data4 = delta_d1_t_d1_f_meanPerAnimal{:,:};

% Number of data points
numPoints = length(data1);

% Generate x values for the scatter plot
x1 = ones(size(data1)) * 1;  % x = 1 for data1
x2 = ones(size(data2)) * 2;  % x = 2 for data2
x3 = ones(size(data3)) * 3;  % x = 3 for data3
x4 = ones(size(data4)) * 4;  % x = 3 for data3

% Combine all x and y data
x_all = [x1, x2, x3, x4];
y_all = [data1, data2, data3, data4];

% Create the scatter plot
figure;
scatter(x_all, y_all, 'filled');

% Customize the plot
xticks([1 2 3, 4]);  % Set the x-tick labels to match the columns
xticklabels({'delta d1 t vs d10 f', 'delta d1 t vs d10 t', 'delta d1 f vs d10 f', ...
    'delta d1 t vs d1 f'});
xlabel('Comparison');
ylabel('Value');
title('Scatterplot of Differences');

grid on;

% Optionally, adjust the x-axis and y-axis limits if needed
xlim([0.5 4.5]);



%% plot error versus velocity 

%combinedTable = combinedTable_f_10 ; 

xValues = max_Velocity_d10_t_sorted{1, :};
yValues = meanTrajError_d10_t_sorted{1, :};

% Create a scatterplot
figure;
scatter(xValues, yValues, 'filled');
xlabel('velocity (X)');
ylabel('variance (Y)');
title('Correlation between velocity(X) and variance (Y)');
grid on;

% Optionally, calculate and display the correlation coefficient
corrCoefficient = corr(xValues', yValues', 'Rows', 'complete');  % 'complete' ignores NaNs
text(min(xValues), max(yValues), sprintf('Corr: %.2f', corrCoefficient), ...
    'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
[R, P] = corrcoef(xValues, yValues, 'Rows', 'complete');  % 'complete' ignores NaNs
% Extract the correlation coefficient and p-value
corrCoefficient = R(1, 2);
pValue = P(1, 2);


%%
to_plot = [1]; 
for crossingIdx = 1:length(to_plot)

    exampleSubset = filledDataMap(frames_list(crossingIdx));
    xCoords = exampleSubset.L_finger_x;
    yCoords = exampleSubset.L_finger_y;
    velocity = velocitiesCellArray{crossingIdx, 1};
end

%% 3D plot
figure;
plot3(xCoords(2:end), yCoords(2:end), velocity, '-o', 'LineWidth', 2);
xlabel('X Coordinates');
ylabel('Y Coordinates');
zlabel('Velocity');
title('3D Plot of Trajectories and Velocity');
grid on;
ylim([280 380]);
xlim([300 500]);
set(gca, 'YDir', 'reverse');
axis on;
hold off;

% Plot row indices at each coordinate point
for idx = 1:length(xCoords)
    % Display row indices as text
    text(xCoords(idx), yCoords(idx), num2str(idx), 'FontSize', 8, 'Color', cmap(crossingIdx, :), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

%% another 3d plot

xCoords = xCoords(2:end);
yCoords = yCoords(2:end);
velocity = velocity; 

% Number of points
numPoints = length(xCoords);
% Generate a colormap with distinct colors for each point
colormapName = 'jet'; % You can choose other colormaps like 'parula', 'hsv', etc.
colors = colormap(colormapName); % Get the colormap
colors = colors(round(linspace(1, size(colors, 1), numPoints)), :); % Map indices to colormap

% Create the 2D plot
figure;
hold on;

% Plot the 2D trajectory line with a slight transparency
lineHandle = patch([xCoords nan], [yCoords nan], [zeros(size(xCoords)) nan], 'EdgeColor', 'interp', 'FaceColor', 'none');
lineHandle.EdgeAlpha = 0.5;  % Set transparency (0 = fully transparent, 1 = fully opaque)

plot(xCoords, yCoords, '-', 'Color', [0.7 0.7 0.7], 'LineWidth', 5);  % Plot the line in a neutral color

for i = 1:numPoints
    % Plot the 2D trajectory with color-coded points
    plot(xCoords(i), yCoords(i), 'o', 'Color', colors(i, :), 'MarkerFaceColor', colors(i, :), 'MarkerSize', 5);
end
ylim([280 380]);
xlim([300 500]);
set(gca, 'YDir', 'reverse');
%%
% Add color-coded dots in 3D space above the 2D projection
for i = 1:numPoints
    % Plot a colored dot at each (x, y, velocity) point
    plot3(xCoords(i), yCoords(i), velocity(i), 'o', 'Color', colors(i, :), 'MarkerFaceColor', colors(i, :), 'MarkerSize', 5);
end
%%
% Set view to 3D to properly visualize the cylindrical bars
%view(45, 30);  % Adjust the azimuth and elevation angles as needed
view(3)
% Set some additional properties for better visualization
axis tight;
box on;


