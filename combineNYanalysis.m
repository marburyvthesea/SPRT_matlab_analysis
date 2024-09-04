
%get unique values for "mouse" in "mouse" column of DLC_trajs

mice = unique(DLC_trajs.Mouse) ; 

reachOutcome = 'f' ;
trainingDay = 1 ;
tableName = sprintf('maxSpeedNY_%s_%d', reachOutcome, trainingDay);
speedTable = table();
assignin('base', tableName, speedTable);

for mouseIdx = 1:length(mice)
% Define the values to match
% Filter the table for this outcome and day 
    % filtered_rows = (DLC_trajs.Mouse == mouse) & (DLC_trajs.Day == trainingDay) & (DLC_trajs.Reach == reachOutcome);
    filtered_rows = ((DLC_trajs.Day == trainingDay) & strcmp(DLC_trajs.Reach, reachOutcome) & (DLC_trajs.Mouse == mice(mouseIdx))); 
    % Extract the values from the frame column where the conditions are met
    frames_list = DLC_trajs.frame(filtered_rows);
    speedArray = DLC_trajs.speed(filtered_rows);
    % Assuming your cell array is named 'cellArray'
    maxValues = cellfun(@max, speedArray);
    maxValue = mean(maxValues, 'omitnan');
    varName = matlab.lang.makeValidName(string(mice(mouseIdx)));
    speedTable.(varName) = maxValue;
end


assignin('base', tableName, speedTable);