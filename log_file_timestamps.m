% Specify the path to the log file
logFilePath = 'path/to/log/file.txt';

% Open the log file
fid = fopen(logFilePath, 'r');

% Initialize variables
startTime = 0;
endTime = 0;
timestamps = [];

% Loop through each line of the log file
while ~feof(fid)
    % Read the current line
    currentLine = fgets(fid);
    
    % Check if the current line contains a timestamp
    if contains(currentLine, ':')
        % Extract the timestamp from the line
        timestamp = extractBetween(currentLine, ':', ' PM');
        
        % Convert the timestamp to seconds since midnight
        timestampSeconds = datenum(timestamp, 'HH:MM:SS PM') - floor(datenum(timestamp, 'HH:MM:SS PM'));
        
        % Check if this is the first timestamp encountered
        if isempty(timestamps)
            startTime = timestampSeconds;
        end
        
        % Add the timestamp to the list
        timestamps = [timestamps, timestampSeconds];
        
        % Update the end time
        endTime = timestampSeconds;
    end
end

% Close the log file
fclose(fid);

% Calculate the duration in seconds
duration = endTime - startTime;

% Print the duration to the console
fprintf('Duration: %d seconds\n', duration);
