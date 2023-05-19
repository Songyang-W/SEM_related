% Set the folder path where the files are located
folderPath = 'C:\Users\Cam\Downloads\filecloud-selected-20230519145951';

% Get a list of all files in the folder
fileList = dir(fullfile(folderPath, 'MosaicBatchLog-*'));

% Preallocate output variables
output = cell(numel(fileList), 2);

% Iterate over each file
for i = 1:numel(fileList)
    % Extract the date from the file name
    fileName = fileList(i).name;
    dateStr = extractBetween(fileName, 'MosaicBatchLog-', '-');

    % Convert the date to the desired format
    datetimeObj = datetime(dateStr, 'InputFormat', 'ddMMMyyyy');
    dateNum = yyyymmdd(datetimeObj);

    % Read the 6th line of the text file
    filePath = fullfile(folderPath, fileName);
    fid = fopen(filePath, 'r');
    for j = 1:6
        line = fgetl(fid);
    end
    fclose(fid);

    % Extract the time from the line and convert it to the desired format
    timeStr = extractBetween(line, ' at ', ' PM');
    timeStr = strrep(timeStr, ':', '');
    
    if isempty(timeStr)
        timeStr = extractBetween(line, ' at ', ' AM');
        timeStr = strrep(timeStr, ':', '');
        timeNum = str2double(timeStr);
    else
        timeNum = str2double(timeStr)+120000;
    end

    % Store the results in the output variable
    output{i, 1} = extractBetween(line, 'Starting mosaic of site "', '"');
    output{i, 2} = sprintf('%d%d%d', dateNum, timeNum);
end

% Display the output as a table
outputTable = cell2table(output, 'VariableNames', {'Column1', 'Column2'});
disp(outputTable);
