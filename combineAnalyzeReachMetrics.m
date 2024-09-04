% Get all variable names in the workspace
allVariables = who;

% Define the patterns for each category
trainingDayPatterns = {'d1', 'd10'};  % List of training day patterns to check
reachOutcomePatterns = {'t', 'f'};  % List of reach outcome patterns to check

% Initialize arrays to store variable names
d1_t_vars = {};
d1_f_vars = {};
d10_t_vars = {};
d10_f_vars = {};

% Loop through each variable name in the workspace
for i = 1:length(allVariables)
    varName = allVariables{i};
    
    % Skip the variables themselves (d1_t_vars, d1_f_vars, etc.)
    if strcmp(varName, 'd1_t_vars') || strcmp(varName, 'd1_f_vars') || ...
       strcmp(varName, 'd10_t_vars') || strcmp(varName, 'd10_f_vars')
        continue;
    end
    
    % Check for each training day and reach outcome pattern
    for j = 1:length(trainingDayPatterns)
        for k = 1:length(reachOutcomePatterns)
            % Construct the regular expression pattern
            pattern = sprintf('_%s_%s_', trainingDayPatterns{j}, reachOutcomePatterns{k});
            
            % Use regexp for exact matching
            if ~isempty(regexp(varName, pattern, 'once'))
                % Assign the variable name to the correct array based on the pattern
                if strcmp(trainingDayPatterns{j}, 'd1') && strcmp(reachOutcomePatterns{k}, 't')
                    d1_t_vars{end+1} = varName;
                elseif strcmp(trainingDayPatterns{j}, 'd1') && strcmp(reachOutcomePatterns{k}, 'f')
                    d1_f_vars{end+1} = varName;
                elseif strcmp(trainingDayPatterns{j}, 'd10') && strcmp(reachOutcomePatterns{k}, 't')
                    d10_t_vars{end+1} = varName;
                elseif strcmp(trainingDayPatterns{j}, 'd10') && strcmp(reachOutcomePatterns{k}, 'f')
                    d10_f_vars{end+1} = varName;
                end
            end
        end
    end
end

% Display the results
disp('Variables for d1_t:');
disp(d1_t_vars);
disp('Variables for d1_f:');
disp(d1_f_vars);
disp('Variables for d10_t:');
disp(d10_t_vars);
disp('Variables for d10_f:');
disp(d10_f_vars);

%% Rename columns names in tables for all mice
% Get all variables in the workspace
allVars = who;

% Filter for table variables that start with "reachMetrics"
tableVars = allVars(startsWith(allVars, 'reachMetrics_'));

% Loop over each table variable, extract the mouse number, and rename columns
for i = 1:length(tableVars)
    % Get the variable name
    varName = tableVars{i};
    
    % Extract the mouse number and body part from the variable name
    tokens = regexp(varName, 'reachMetrics_(\d+)_d\d+_[tf]_(R_finger|L_finger)', 'tokens');
    mouseNum = tokens{1}{1};
    bodyPart = tokens{1}{2};
    
    % Retrieve the table from the workspace
    currentTable = eval(varName);
    
    % Rename the columns with the mouse number and body part appended
    renamedTable = renameColumnsWithMouseAndBodyPart(currentTable, mouseNum, bodyPart);
    
    % Assign the renamed table back to the variable in the workspace
    assignin('base', varName, renamedTable);
end
]
%% extract per animal avg and error
%[avg_coors_table_d1_t, errors_table_d1_t] = extractErrorsAndAverages(d1_t_vars); 
[avg_coors_table_d1_t, errors_table_d1_t, finger_coords_table_d1_t] = extractErrorsAndAveragesTrajectories(d1_t_vars);
[avg_coors_table_d1_f, errors_table_d1_f, finger_coords_table_d1_f] = extractErrorsAndAveragesTrajectories(d1_f_vars); 
[avg_coors_table_d10_t, errors_table_d10_t, finger_coords_table_d10_t] = extractErrorsAndAveragesTrajectories(d10_t_vars); 
[avg_coors_table_d10_f, errors_table_d10_f, finger_coords_table_d10_f] = extractErrorsAndAveragesTrajectories(d10_f_vars); 

% differences in x,y coors on individual reaches to mean for mouse/category
diff_table_d1_t = calculateDifferencesBtwTrajMean(finger_coords_table_d1_t, avg_coors_table_d1_t);
diff_table_d1_f = calculateDifferencesBtwTrajMean(finger_coords_table_d1_f, avg_coors_table_d1_f);
diff_table_d10_t = calculateDifferencesBtwTrajMean(finger_coords_table_d10_t, avg_coors_table_d10_t);
diff_table_d10_f = calculateDifferencesBtwTrajMean(finger_coords_table_d10_f, avg_coors_table_d10_f);

% euclidean differences indiv trajs
euclideanErrorsTableReaches_d1_t = calcEuclidVarianceTrajs(diff_table_d1_t);
euclideanErrorsTableReaches_d1_f = calcEuclidVarianceTrajs(diff_table_d1_f);
euclideanErrorsTableReaches_d10_t = calcEuclidVarianceTrajs(diff_table_d10_t);
euclideanErrorsTableReaches_d10_f = calcEuclidVarianceTrajs(diff_table_d10_f);

% calculate euclidean error per mouse 
euclideanErrorsTable_d1_t = calcEuclideanErrorPerMouse(errors_table_d1_t);
euclideanErrorsTable_d1_f = calcEuclideanErrorPerMouse(errors_table_d1_f);
euclideanErrorsTable_d10_t = calcEuclideanErrorPerMouse(errors_table_d10_t);
euclideanErrorsTable_d10_f = calcEuclideanErrorPerMouse(errors_table_d10_f);

% pooled by day (all reach categories)
% correct duplicate variable names 
euclideanErrorsTable_d1_t.Properties.VariableNames = strcat(euclideanErrorsTable_d1_t.Properties.VariableNames, '_t');
euclideanErrorsTable_d1_f.Properties.VariableNames = strcat(euclideanErrorsTable_d1_f.Properties.VariableNames, '_f');
euclideanErrorsTable_d10_t.Properties.VariableNames = strcat(euclideanErrorsTable_d10_t.Properties.VariableNames, '_t');
euclideanErrorsTable_d10_f.Properties.VariableNames = strcat(euclideanErrorsTable_d10_f.Properties.VariableNames, '_f');
day1errorsCombined = [mean(euclideanErrorsTable_d1_t), mean(euclideanErrorsTable_d1_f)];
day10errorsCombined = [mean(euclideanErrorsTable_d10_t), mean(euclideanErrorsTable_d10_f)];

%% calculate differences
%day 1 vs day 10
delta_d1_t_d10_f = calculateDifferences(euclideanErrorsTable_d1_t, euclideanErrorsTable_d10_f);
delta_d1_t_d10_f_meanPerAnimal = mean(delta_d1_t_d10_f, "omitnan"); 
mean(delta_d1_t_d10_f_meanPerAnimal, 2)

delta_d1_t_d10_t = calculateDifferences(euclideanErrorsTable_d1_t, euclideanErrorsTable_d10_t);
delta_d1_t_d10_t_meanPerAnimal = mean(delta_d1_t_d10_t, "omitnan"); 
mean(delta_d1_t_d10_t_meanPerAnimal, 2)

delta_d1_f_d10_f = calculateDifferences(euclideanErrorsTable_d1_f, euclideanErrorsTable_d10_f);
delta_d1_f_d10_f_meanPerAnimal = mean(delta_d1_f_d10_f, "omitnan"); 
mean(delta_d1_f_d10_f_meanPerAnimal, 2)

%day 1 vs day 1
delta_d1_t_d1_f = calculateDifferences(euclideanErrorsTable_d1_t, euclideanErrorsTable_d1_f);
delta_d1_t_d1_f_meanPerAnimal = mean(delta_d1_t_d10_f, "omitnan"); 
mean(delta_d1_t_d1_f_meanPerAnimal, 2)

%% Extract and average individual trajectories across all mice  
d10_f_combined = concatenateTables(d10_f_vars);
d10_t_combined = concatenateTables(d10_t_vars);
d1_f_combined = concatenateTables(d1_f_vars);
d1_t_combined = concatenateTables(d1_t_vars);

[mean_x, mean_y, std_x, std_y, sem_x, sem_y] = extractAvgIndivReachTraj(d10_f_combined);
d10_f_combined_means = table(mean_x, mean_y, std_x, std_y, sem_x, sem_y);
[mean_x, mean_y, std_x, std_y, sem_x, sem_y] = extractAvgIndivReachTraj(d1_f_combined);
d1_f_combined_means = table(mean_x, mean_y, std_x, std_y, sem_x, sem_y);
[mean_x, mean_y, std_x, std_y, sem_x, sem_y] = extractAvgIndivReachTraj(d10_t_combined);
d10_t_combined_means = table(mean_x, mean_y, std_x, std_y, sem_x, sem_y);
[mean_x, mean_y, std_x, std_y, sem_x, sem_y] = extractAvgIndivReachTraj(d1_t_combined);
d1_t_combined_means = table(mean_x, mean_y, std_x, std_y, sem_x, sem_y);

%% extract velocity columns 

velocity_cols_d10_f = d10_f_combined(:, contains(d10_f_combined.Properties.VariableNames, 'velocity'));
velocity_cols_d10_t = d10_t_combined(:, contains(d10_t_combined.Properties.VariableNames, 'velocity'));
velocity_cols_d1_f = d1_f_combined(:, contains(d1_f_combined.Properties.VariableNames, 'velocity'));
velocity_cols_d1_t = d1_t_combined(:, contains(d1_t_combined.Properties.VariableNames, 'velocity'));

% mean and error 

d10_f_mean = mean(velocity_cols_d10_f, 2, 'omitnan').mean;
d10_t_mean = mean(velocity_cols_d10_t, 2, 'omitnan').mean;
d1_f_mean = mean(velocity_cols_d1_f , 2, 'omitnan').mean;
d1_t_mean = mean(velocity_cols_d1_t, 2, 'omitnan').mean;

d10_f_nanstd = nanstd(velocity_cols_d10_f, 0, 2).var;
d10_t_nanstd = nanstd(velocity_cols_d10_t, 0, 2).var;
d1_f_nanstd = nanstd(velocity_cols_d1_f, 0, 2).var;
d1_t_nanstd = nanstd(velocity_cols_d1_t, 0, 2).var;

d10_f_sem = d10_f_nanstd/sqrt(length(velocity_cols_d10_f.Properties.VariableNames)); 
d10_t_sem = d10_t_nanstd/sqrt(length(velocity_cols_d10_t.Properties.VariableNames)); 
d1_f_sem = d1_f_nanstd/sqrt(length(velocity_cols_d1_f.Properties.VariableNames)); 
d1_t_sem = d1_t_nanstd/sqrt(length(velocity_cols_d1_t.Properties.VariableNames)); 

% 
movement_direction = determineMovementDirection(d10_f_combined_means.mean_x);
vector_x_velocity_d10_f = d10_f_mean.*movement_direction; 

movement_direction = determineMovementDirection(d10_t_combined_means.mean_x);
vector_x_velocity_d10_t = d10_t_mean.*movement_direction; 

movement_direction_d1_f = determineMovementDirection(d1_f_combined_means.mean_x);
vector_x_velocity_d1_f = d1_f_mean.*movement_direction; 

movement_direction_d1_t = determineMovementDirection(d1_t_combined_means.mean_x);
vector_x_velocity_d1_t = d1_t_mean.*movement_direction; 
%% correlate velocity with variance by trajectory 
% scaling factor 
%d1_t 0.11 mm/pixel 
%get max
maxVelocity_d1_t = max(velocity_cols_d1_t);
%get mean
meanTrajError_d1_t = mean(euclideanErrorsTableReaches_d1_t, 1, 'omitnan');
%sort to plot
[max_Velocity_d1_t_sorted, meanTrajError_d1_t_sorted] = alignAndSortTablesVelTraj(maxVelocity_d1_t, meanTrajError_d1_t);
max_Velocity_d1_t_sorted_mm = max_Velocity_d1_t_sorted./.11;
meanTrajError_d1_t_sorted_mm = meanTrajError_d1_t_sorted./.11;
%d1_f
%get max
maxVelocity_d1_f = max(velocity_cols_d1_f);
%get mean
meanTrajError_d1_f = mean(euclideanErrorsTableReaches_d1_f, 1, 'omitnan');
%sort to plot
[max_Velocity_d1_f_sorted, meanTrajError_d1_f_sorted] = alignAndSortTablesVelTraj(maxVelocity_d1_f, meanTrajError_d1_f);
max_Velocity_d1_f_sorted_mm = max_Velocity_d1_f_sorted./.11;
meanTrajError_d1_f_sorted_mm = meanTrajError_d1_f_sorted./.11; 
%d10_f
%get max
maxVelocity_d10_f = max(velocity_cols_d10_f);
%get mean
meanTrajError_d10_f = mean(euclideanErrorsTableReaches_d10_f, 1, 'omitnan');
%sort to plot 
[max_Velocity_d10_f_sorted, meanTrajError_d10_f_sorted] = alignAndSortTablesVelTraj(maxVelocity_d10_f , meanTrajError_d10_f); 
max_Velocity_d10_f_sorted_mm = max_Velocity_d10_f_sorted./.11;
meanTrajError_d10_f_sorted_mm = meanTrajError_d10_f_sorted./.11;
%d10_t
%get max
maxVelocity_d10_t = max(velocity_cols_d10_t);
%get mean
meanTrajError_d10_t = mean(euclideanErrorsTableReaches_d10_t, 1, 'omitnan');
%sort to plot 
[max_Velocity_d10_t_sorted, meanTrajError_d10_t_sorted] = alignAndSortTablesVelTraj(maxVelocity_d10_t , meanTrajError_d10_t);
max_Velocity_d10_t_sorted_mm = max_Velocity_d10_t_sorted./.11;
meanTrajError_d10_t_sorted_mm = meanTrajError_d10_t_sorted./.11; 

%% correlate velocity with variance by mouse  

meanVelocity_d1_t = avgColumnsByMouse(velocity_cols_d1_t);
meanOverallVelocity_d1_t = mean(meanVelocity_d1_t, 1, 'omitnan');
maxVelocity_d1_t = max(meanVelocity_d1_t);
meanErrors_d1_t = mean(euclideanErrorsTable_d1_t); 
d1_t_combined_mean = concatVelocityAndError(meanOverallVelocity_d1_t, meanErrors_d1_t); 
d1_t_combined_max = concatVelocityAndError(maxVelocity_d1_t, meanErrors_d1_t); 

meanVelocity_d1_f = avgColumnsByMouse(velocity_cols_d1_f);
meanOverallVelocity_d1_f = mean(meanVelocity_d1_f, 1, 'omitnan');
maxVelocity_d1_f = max(meanVelocity_d1_f);
meanErrors_d1_f = mean(euclideanErrorsTable_d1_f);
d1_f_combined_mean = concatVelocityAndError(meanOverallVelocity_d1_f, meanErrors_d1_f); 
d1_f_combined_max = concatVelocityAndError(maxVelocity_d1_f, meanErrors_d1_f); 

meanVelocity_d10_t = avgColumnsByMouse(velocity_cols_d10_t);
meanOverallVelocity_d10_t = mean(meanVelocity_d10_t, 1, 'omitnan');
maxVelocity_d10_t = max(meanVelocity_d10_t);
meanErrors_d10_t = mean(euclideanErrorsTable_d10_t);
d10_t_combined_mean = concatVelocityAndError(meanOverallVelocity_d10_t, meanErrors_d10_t); 
d10_t_combined_max = concatVelocityAndError(maxVelocity_d10_t, meanErrors_d10_t); 

meanVelocity_d10_f = avgColumnsByMouse(velocity_cols_d10_f);
meanOverallVelocity_d10_f = mean(meanVelocity_d10_f, 1, 'omitnan');
maxVelocity_d10_f = max(meanVelocity_d10_f);
meanErrors_d10_f = mean(euclideanErrorsTable_d10_f);
d10_f_combined_mean = concatVelocityAndError(meanOverallVelocity_d10_f, meanErrors_d10_f);
d10_f_combined_max = concatVelocityAndError(maxVelocity_d10_f, meanErrors_d10_f);

%%



