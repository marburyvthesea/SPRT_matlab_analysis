%% load all csv files in folder that follow naming convenstion
% e.g for
% '20221019-12-41-58_T01-547_DMKDLC_resnet50_SPRTAug15shuffle1_1000000.csv',
% the training day is "1" and the animal # is 547

DLC_FileMap = extractDLCFileInfo('/Users/johnmarshall/Documents/MATLAB/SPRT_Analysis/00_analysis/DLC_trajectories'); 

%% select and load csv file by using animal # and training day
trainingDay = 10 ;
mouse = '581' ;

%csvFileName = '20221019-12-41-58_T01-547_DMKDLC_resnet50_SPRTAug15shuffle1_1000000.csv';
tDay = strcat('T', num2str(trainingDay, '%02d')); 
csvFileName = DLC_FileMap(strcat(tDay, '-', mouse)); 
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
% perform some cleanup of DLC trajectory data
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

%find outliers in distance columns 
distanceColumns = {'R_finger_delta', 'R_wrist_delta', 'L_finger_delta', ... 
    'L_wrist_delta', 'Nose_delta', 'Food_delta'};
dataTable = addStandardDeviationColumns(dataTable, distanceColumns);
% now for data points where the standard deviation exceeds a given threshold
% (e.g. stdThreshold=4) replace the corresponsing coordinates with an
% average of the points preceeding the deviation from the threshold and
% those following
stdThreshold=4; 
correctedTable = correctOutlierCoordinates(dataTable, distanceColumns, stdThreshold);
correctedTable = calcEuclidDistColumnPairs(coordinatePairs, correctedTable);
correctedTable = addStandardDeviationColumns(correctedTable, distanceColumns);
%% select frames representing paw crossing panel 
% Define the values to match
% Filter the table for this mouse and day based on reach outcome 
reachOutcome = 't' ;
% filtered_rows = (DLC_trajs.Mouse == mouse) & (DLC_trajs.Day == trainingDay) & (DLC_trajs.Reach == reachOutcome);
filtered_rows = (DLC_trajs.Mouse == str2num(mouse)) & (DLC_trajs.Day == trainingDay) & strcmp(DLC_trajs.Reach, reachOutcome); 
% Extract the values from the frame column where the conditions are met
frames_list = DLC_trajs.frame(filtered_rows);
% Display the result
disp('List of frame values:');
disp(frames_list);
%% select regions of DLC table from frameNumList
numSubsetFramesToSave = 50;
% Create a containers.Map to store the subsets of the table
dataMap = containers.Map('KeyType', 'double', 'ValueType', 'any');
% Iterate through each frame number in frames_list
dataMap = selectRegionsFromDLC(dataMap, frames_list, numSubsetFramesToSave, correctedTable); 
%% Create videos to check accuracy
videoFile = '/Users/johnmarshall/Documents/MATLAB/SPRT_Analysis/00_analysis/LabelledVideos/20221028-16-45-16_T10-581_DMKDLC_resnet50_SPRTAug15shuffle1_1000000_labeled.mp4' ; 
%createReachPeriodVideosTrialType(videoFile, mouse, trainingDay, numSubsetFramesToSave, frames_list, reachOutcome)
%% iterate over relevant body parts, do the cleanup, align to crossings, save final metrics for each body part 
% select relevant part
bodyPartsToCheck = {'L_finger', 'R_finger'};
for bodyPartIdx = 1:length(bodyPartsToCheck)
    disp(bodyPartIdx)
    bodyPart = bodyPartsToCheck{1,bodyPartIdx};
    disp(bodyPart)
    
    filledDataMap = fillNaNRegions(dataMap, frames_list, bodyPart);
    
    combinedTable = combineFilledDataMap(filledDataMap, frames_list); 
    save(strcat(mouse, '_', tDay, '_', reachOutcome, '_', bodyPart, '_', 'correctedTrajectories.mat'), 'combinedTable');
    %saveDataMap(filledDataMap, strcat(mouse, '_', tDay, '_', reachOutcome, '_', 'correctedTrajectories.mat'))
    % do some work to align to the first time the paw crosses the panel
    xCoordTable = selectXCoordinates(combinedTable, bodyPart);
    xValue = 375; 
    crossingIndices = findCrossingIndices(xCoordTable, xValue);
    correctedFrameIndiciesNonUnique = frames_list-(50-cell2mat(struct2cell(crossingIndices))); 
    correctedFrameIndicies = unique(correctedFrameIndiciesNonUnique);
    % Remove NaN entries
    correctedFrameIndicies = correctedFrameIndicies(~isnan(correctedFrameIndicies));
    correctedFrameIndicies
  
    if ~isempty(correctedFrameIndicies)

    % redo selection from original full dataset 
    % select regions of DLC table from frameNumList
    numSubsetFramesToSave = 50;
    % Create a containers.Map to store the subsets of the table
    dataMapAligned = containers.Map('KeyType', 'double', 'ValueType', 'any');
    % Iterate through each frame number in frames_list
    dataMapAligned = selectRegionsFromDLC(dataMap, correctedFrameIndicies, numSubsetFramesToSave, correctedTable); 
    
    % Create videos to check accuracy
    createReachPeriodVideosTrialType(videoFile, mouse, trainingDay, numSubsetFramesToSave, correctedFrameIndicies, reachOutcome)
    
    % replace missing values with linear interpolation 
    % select relevant part
    filledDataMap = fillNaNRegions(dataMapAligned, correctedFrameIndicies, bodyPart);
    combinedTable = combineFilledDataMap(filledDataMap, correctedFrameIndicies); 
    save(strcat(mouse, '_', tDay, '_', reachOutcome, '_', bodyPart, '_', 'correctedTrajectories.mat'), 'combinedTable');
    %saveDataMap(filledDataMap, strcat(mouse, '_', tDay, '_', reachOutcome, '_', 'correctedTrajectories.mat'))
    % calculate velocity of an input body part
    velocitiesTable = calculateInstantaneousVelocity(bodyPart, filledDataMap, ... 
        correctedFrameIndicies) ;
    [averageMaxValue, stdMaxValue] = calculateMaxStatistics(velocitiesTable);
    % calculate "average" trajectories and standard deviation
    [avgXTrajectory, avgYTrajectory, stdXTrajectory, stdYTrajectory] = calculateTrajectoryStatistics(combinedTable);

    xError = stdXTrajectory/sqrt(length(correctedFrameIndicies));
    yError = stdYTrajectory/sqrt(length(correctedFrameIndicies));
    % save data
    trajectoryErrorTable = table(avgXTrajectory, avgYTrajectory, xError, yError, ...
    'VariableNames', {'avg_X_coor', 'avg_Y_coor', 'xError', 'yError'});
    % Add a row of NaNs to the start of velocityTable
    nanRow = array2table(NaN(1, width(velocitiesTable)), 'VariableNames', velocitiesTable.Properties.VariableNames);
    velocityTableWithNaN = [nanRow; velocitiesTable];
    % Concatenate combinedTable, velocityTable, and trajectoryErrorTable horizontally
    finalTable = [combinedTable, velocityTableWithNaN, trajectoryErrorTable];

    % Rename for saving
    tableName = sprintf('reachMetrics_%s_d%d_%s_%s', mouse, trainingDay, reachOutcome, bodyPart);
    eval([tableName ' = finalTable;']);
end 
end
%%
intermediateVariables = {'averageMaxValue', 'averageTrajectory', ...
    'avgXTrajectory', ...
    'avgYTrajectory', 'baseColumns', 'bodyPartName', ...
    'cI','cmap','combinedHeaders','combinedTable', ...
    'coordinatePairs', ...
    'correctedFrameIndicies','correctedTable', ...
    'crossingIdx','crossingIndices', ...
    'csvFileName','dataMap', ...
    'dataRows','dataTable', ...
    'distanceColumns','edgeAlpha', ...
    'edgeColorWithAlpha', ...
    'exampleSubset', ...
    'faceAlpha','filledDataMap', ...
    'filtered_rows', ...
    'firstplot','frames_list','h','headerRow2', ...
    'headerRow3','i', ...
    'idx','likelihoodThreshold', ...
    'mouse','nanRow', ...
    'numSubsetFramesToSave', ...
    'numplot','pos','rawData', ...
    'reachOutcome','rows','stdMaxValue', ...
    'stdThreshold','stdTrajectory', ...
    'stdXTrajectory', ...
    'stdYTrajectory','szTable','tDay','tableName','to_plot', ...
    'trainingDay','trajectoryErrorTable', ...
    'velocitiesTable', 'velocityTableWithNaN','xCoordTable', ... 
    'xCoords','xError', ...
    'xValue', 'yCoords', 'yError'};

clear(intermediateVariables{:});


