function [mean_x, mean_y, std_x, std_y, sem_x, sem_y] = extractAvgIndivReachTraj(combinedTable)
%UNTITLED20 Summary of this function goes here
%   Detailed explanation goes here
% Identify columns that match the "L_finger_x", "L_finger_y", "R_finger_x", "R_finger_y" patterns
L_finger_x_cols = combinedTable(:, startsWith(combinedTable.Properties.VariableNames, 'L_finger_x'));
L_finger_y_cols = combinedTable(:, startsWith(combinedTable.Properties.VariableNames, 'L_finger_y'));
R_finger_x_cols = combinedTable(:, startsWith(combinedTable.Properties.VariableNames, 'R_finger_x'));
R_finger_y_cols = combinedTable(:, startsWith(combinedTable.Properties.VariableNames, 'R_finger_y'));

%% 
% Combine the columns into separate tables
indivCoordinateReachColumns_x = table2array([L_finger_x_cols, R_finger_x_cols]); 
indivCoordinateReachColumns_y = table2array([L_finger_y_cols, R_finger_y_cols]);

mean_x = mean(indivCoordinateReachColumns_x, 2, 'omitnan'); 
mean_y = mean(indivCoordinateReachColumns_y, 2, 'omitnan');

std_x = nanstd(indivCoordinateReachColumns_x, 0, 2);
std_y = nanstd(indivCoordinateReachColumns_y, 0, 2);

sem_x = std_x/sqrt(length(indivCoordinateReachColumns_x)); 
sem_y = std_y/sqrt(length(indivCoordinateReachColumns_y)); 

end