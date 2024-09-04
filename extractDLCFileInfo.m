function fileMap = extractDLCFileInfo(folderName)
    % Initialize the map to store filenames
    fileMap = containers.Map('KeyType', 'char', 'ValueType', 'any');
    
    % Get a list of all csv files in the folder
    files = dir(fullfile(folderName, '*.csv'));
    
    % Process each file
    for i = 1:length(files)
        filename = files(i).name;
        
        % Extract the T** and 3-digit number using regular expressions
        tokens = regexp(filename, '_(T\d{2})-(\d{3})_', 'tokens');
        
        if ~isempty(tokens)
            key = [tokens{1}{1}, '-', tokens{1}{2}];  % Combine T** and 3-digit number
            
            % Store the filename in the map
            fileMap(key) = filename;
        end
    end
end