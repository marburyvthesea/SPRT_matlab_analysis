%% find midpoints of reach 

%% select and load DLC csv file
csvFileName = '20221019-12-41-58_T01-547_DMKDLC_resnet50_SPRTAug15shuffle1_1000000.csv';

% Read the CSV file into a cell array
rawData = readcell(csvFileName, 'Delimiter', ','); % Use readcell instead of readtable

% Extract the 2nd and 3rd rows: headers and column names
headerRow2 = rawData(2, :);
headerRow3 = rawData(3, :);

% Combine the 2nd and 3rd rows to create new column names
combinedHeaders = strcat(headerRow2, '_', headerRow3);

% Replace hyphens with underscores in the column names
combinedHeaders = strrep(combinedHeaders, '-', '_');

% Extract the data rows (excluding the header rows)
dataRows = rawData(4:end, :);

% Create a new table with the combined headers
dataTable = cell2table(dataRows, 'VariableNames', combinedHeaders);

% Display the first few rows of the table
disp(head(dataTable));

%% perform some cleanup of DLC trajectory data

% list of coordinate pairs to use 
baseColumns = {'R_finger', 'R_wrist', 'L_finger', ...
    'L_wrist', 'L_wrist', 'Nose', 'Food'    
};
%remove indices with low likelihood of bodypart detection 
likelihoodThreshold = .95 ;
dataTable = replaceCoordinatesBelowLikelihood(dataTable, baseColumns, likelihoodThreshold);
coordinatePairs = {
    'R_finger_x', 'R_finger_y'; 'R_wrist_x', 'R_wrist_y';
    'L_finger_x', 'L_finger_y'; 'L_wrist_x', 'L_wrist_y';
    'Nose_x', 'Nose_y'; 'Food_x', 'Food_y'
};
% add columns with euclidean distances in successive frames to dataTable 
dataTable = calcEuclidDistColumnPairs(coordinatePairs,dataTable);

%% find outliers in distance columns 
distanceColumns = {'R_finger_delta', 'R_wrist_delta', 'L_finger_delta', ... 
    'L_wrist_delta', 'Nose_delta', 'Food_delta'};
dataTable = addStandardDeviationColumns(dataTable, distanceColumns);
% now for data points where the standard deviation exceeds a given threshold
% (e.g. stdThreshold=4) replace the corresponsing coordinates with an
% average of the points preceeding the deviation from the threshold and
% those following
stdThreshold=10; 
correctedTable = correctOutlierCoordinates(dataTable, distanceColumns, stdThreshold);

correctedTable = calcEuclidDistColumnPairs(coordinatePairs, correctedTable);
correctedTable = addStandardDeviationColumns(correctedTable, distanceColumns);


%% find x threshold crossings

xCoords = correctedTable.L_finger_x;
yCoords = correctedTable.L_finger_y;

%use checkVerticalLineCrossing function
%x position of vertical line 
lineX = 375;
% Initialize a list to store indices of crossings
crossingIndices = [];
% Iterate through the coordinates by index pairs
for i = 1:length(xCoords) - 1
    % Define the subset of coordinates between the current and next index
    subsetX = [xCoords(i), xCoords(i + 1)];
    subsetY = [yCoords(i), yCoords(i + 1)];
    % Check if this subset crosses the vertical line
    doesCross = checkVerticalLineCrossing(subsetX, subsetY, lineX);    
    % If it crosses, store the index and report
    if doesCross
        crossingIndices = [crossingIndices; i];
        fprintf('Crossing detected between indices %d and %d.\n', i, i + 1);
    end
end
% Display all crossing indices
disp('Indices where the object crosses the vertical line:');
disp(crossingIndices);


%% select subsets of trajectory data where frame crossing is detected 
numSubsetFramesToSave = 50;
frames_list = crossingIndices ;

% Create a containers.Map to store the subsets of the table
dataMap = containers.Map('KeyType', 'double', 'ValueType', 'any');

% Iterate through each frame number in frames_list
for i = 1:length(frames_list)
    reachFrame = frames_list(i);
    
    % Calculate the range of rows to extract
    startFrame = max(1, reachFrame - numSubsetFramesToSave);
    endFrame = min(height(correctedTable), reachFrame + numSubsetFramesToSave);

    % Extract the subset of rows for the current frame
    subsetTable = correctedTable(startFrame:endFrame, :);
    
    % Store the subset table in the map with the frame index as the key
    dataMap(reachFrame) = subsetTable;
end
%% e.g. access one surrounding frame region to plot on image 
% Define the image file name
imageFileName = 'mouse547_day1_frame28106.png';
% Load the image
img = imread(imageFileName);
% Load the subset data
% Assuming exampleSubset is already defined and contains the columns 'R_finger_x' and 'R_finger_y'
crossingIdx = 1 ;
exampleSubset = dataMap(frames_list(crossingIdx));
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

%% make videos of these reach period to check detection accuracy

videoFile = '20221019-12-41-58_T01-547_DMK.avi';  % Replace with your video file path
%this is just for labelling the videos
target_mouse = 547 ; 
target_day = 1; 

% Define the number of surrounding frames to include
numFramesToLoad = 50;  % Number of frames to load around reachFrame

% Create a VideoReader object
vidObj = VideoReader(videoFile);

% Iterate through each frame number in frames_list
for i = 1:length(frames_list)
    reachFrame = frames_list(i);
    
    % Check if the frame number is within the range of the video
    if reachFrame > vidObj.NumFrames
        warning('Frame number %d exceeds the total number of frames in the video.', reachFrame);
        continue;
    end
    
    % Calculate the range of frames to read
    startFrame = max(1, reachFrame - numFramesToLoad);
    endFrame = min(vidObj.NumFrames, reachFrame + numFramesToLoad);

    % Preallocate cell array to hold frames
    frames = cell(endFrame - startFrame + 1, 1);

    % Read frames around reachFrame
    for j = startFrame:endFrame
        frames{j - startFrame + 1} = read(vidObj, j);
    end

    % Create and save the video file containing surrounding frames
    outputVideoFile = sprintf('mouse%d_day%d_frame%d_surrounding.avi', target_mouse, target_day, reachFrame);
    outputVidObj = VideoWriter(outputVideoFile, 'Uncompressed AVI');  % Create VideoWriter object
    open(outputVidObj);

    % Write frames to the new video file
    for k = 1:numel(frames)
        writeVideo(outputVidObj, frames{k});
    end

    % Close the VideoWriter object
    close(outputVidObj);

    % Save the specific frame as an image
    specificFrame = read(vidObj, reachFrame);
    outputImageFile = sprintf('mouse%d_day%d_frame%d.png', target_mouse, target_day, reachFrame);
    imwrite(specificFrame, outputImageFile);

    % Display the specific frame as an image
    figure;
    imshow(specificFrame);
    title(['Frame ' num2str(reachFrame)]);


end

%%
%% display videos of reach period in GUI 
videoFile = '20221019-12-41-58_T01-547_DMK.avi';  % Replace with your video file path
target_mouse = 547 ; 
target_day = 1; 
numFramesToLoad = 50;  
frames_list = crossingIndices ;
%reviewVideoFrames(videoFile, frames_list, numFramesToLoad, target_mouse, target_day);

