%%
function [total_time_used,start_time,end_time] = Extract_Timestamps(filename,display)
%%
%
% This Matlab code extracts timestamps from a log file and calculates the duration of time covered by those timestamps.
% The log file can contain arbitrary text, but the code expects timestamps to be in the format of "mm/dd/yyyy - hh:mm:ss AM/PM".
% The code outputs the start and end times, and the duration of time covered by the timestamps in seconds.

%
%%
% Read the log file
% Read the log file
fid = fopen(filename);
log = textscan(fid, '%s', 'Delimiter', '\n');
log = log{1};
fclose(fid);


% Extract start and end times from log file
start_time = [];
end_time = [];
for i = 1:numel(log)
    % Check if line contains start or end time information
    if contains(log{i}, 'Starting mosaic') || contains(log{i}, 'Mosaic was cancelled by user')||contains(log{i}, 'Mosaic completed')
        % Extract time information from line
        time_str = log{i}(end-10:end);
        % Convert to datetime format
        time = datetime(time_str, 'InputFormat', 'hh:mm:ss a');

        % Check if this is the first start time or the most recent end time
        if isempty(start_time)
            start_time = time;
            start_time_index = i;
        elseif contains(log{i}, 'Mosaic was cancelled by user')||contains(log{i}, 'Mosaic completed')
            end_time = time;
            end_time_index = i;
        end
    end
end



% Extract start date from first line of log file
start_date = datetime(log{start_time_index+16}(1:12),'InputFormat','MMM dd, yyyy');
% Extract end date from last line of log file
end_date = datetime(log{end_time_index-1}(1:12), 'InputFormat', 'MMM dd, yyyy');

% Correct the start time and end time's dates
start_time.Month = start_date.Month;
start_time.Day = start_date.Day;
end_time.Month = end_date.Month;
end_time.Day = end_date.Day;
total_time_used = end_time - start_time;

if display
    disp(['Start Date: ' datestr(start_date)]);
    disp(['Start Time: ' datestr(start_time, 'HH:MM:SS PM')]);
    disp(['End Date: ' datestr(end_date)]);
    disp(['End Time: ' datestr(end_time, 'HH:MM:SS PM')]);

    disp(['Total Duration: ' datestr(total_time_used,'HH:MM:SS')])
end
end
