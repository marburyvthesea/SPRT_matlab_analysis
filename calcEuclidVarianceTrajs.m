function [euclideanErrorsTableReaches] = calcEuclidVarianceTrajs(diff_table)

euclideanErrorsTableReaches = table();
varNames = diff_table.Properties.VariableNames;
rIdx_vars = regexprep(varNames, {'^L_finger_x_','^L_finger_y_', '^R_finger_x_', '^R_finger_y_'}, '');

for reach=1:length(rIdx_vars)
    x_reach = strcat('x_', rIdx_vars{reach});
    y_reach = strcat('y_', rIdx_vars{reach});
    for var=1:length(varNames)
        if contains(varNames(var), x_reach)
            x_data = diff_table.(sprintf(varNames{var}));
        elseif contains(varNames(var), y_reach)
            y_data = diff_table.(sprintf(varNames{var}));
        end
    end
    % Calculate the Euclidean error
    euclideanError = sqrt(x_data.^2 + y_data.^2);

    % Store the Euclidean error in the new table
    euclideanErrorsTableReaches.(sprintf(rIdx_vars{reach})) = euclideanError;

end
end

