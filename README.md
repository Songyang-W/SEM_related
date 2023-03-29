# SEM_related

go wiki for more info


The Extract_Timestamps function takes a single input argument, which is the filename of a log file. The log file can contain arbitrary text, but the function expects timestamps to be in the format of "mm/dd/yyyy - hh:mm:ss AM/PM".

The function extracts the start and end times from the log file based on certain keywords in the log, such as "Starting mosaic", "Mosaic was cancelled by user", or "Mosaic completed". It then calculates the duration of time covered by those timestamps in seconds.

The function first reads the log file using the fopen and textscan functions to obtain a cell array of strings representing each line of the log file. It then iterates through the cell array and extracts the timestamps from the relevant lines of the log file.

The function uses the datetime function to convert the timestamp strings to datetime format, and then corrects the start time and end time's dates based on the dates extracted from the log file.

Finally, the function displays the start and end times and the total duration in a human-readable format using the datestr function, and returns the total duration in seconds.

Overall, the Extract_Timestamps function is a useful tool for extracting and calculating timestamps from a log file in MATLAB.




