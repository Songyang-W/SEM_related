clear all; clc; close all;

% Get a list of all files with name starting with 'MosaicBatchLog'
filelist = dir('MosaicBatchLog*');

% Set the display flag to 0 to suppress display messages
display_flag = 0;

% Open a text file for writing
fid = fopen('output.txt', 'w');

% Loop through all files in the directory
for i = 1:length(filelist)
    % Call the function to extract timestamps
    [time_used, start_time, end_time] = Extract_Timestamps(filelist(i).name, display_flag);
    total_time_used(i) = time_used;

    % Write the timestamps to the text file
    fprintf(fid, 'File %s:\n', filelist(i).name);
    fprintf(fid, 'Start Date: %s\n', datestr(start_time, 'dd-mmm-yyyy'));
    fprintf(fid, 'Start Time: %s\n', datestr(start_time, 'HH:MM:SS PM'));
    fprintf(fid, 'End Date: %s\n', datestr(end_time, 'dd-mmm-yyyy'));
    fprintf(fid, 'End Time: %s\n', datestr(end_time, 'HH:MM:SS PM'));
    fprintf(fid, 'Total Duration: %s\n\n', datestr(time_used, 'HH:MM:SS'));
end

% Close the text file
fclose(fid);

% Display the total time spent across all files
total_time_spent = sum(total_time_used);
fprintf('Total Time Spent: %s\n', datestr(total_time_spent, 'dd-HH:MM:SS'));
