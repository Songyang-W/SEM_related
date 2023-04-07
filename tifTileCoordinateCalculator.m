%------------------------------------------------------------------------
% MATLAB code for extracting row and column information from TIFF files
% and calculating X, Y, Z coordinates for tile alignment
% File: tifTileInfoExtractor.m
%
% Description:
% This code extracts row and column information from a collection of TIFF
% files in a folder, where the TIFF files are named with the convention
% "Tile_r{row}-c{column}_..." to indicate their row and column position.
% The code calculates the X, Y, Z coordinates of the top-left corner of
% each tile based on the row and column information, as well as user-defined
% tile size and overlap parameters. The output is written to a text file,
% listing the TIFF file names along with their corresponding X, Y, Z
% coordinates, in a format that can be used for rough alignment of the tiles.
%
% Usage:
% 1. Set the tile size and overlap parameters in the code.
% 2. Place this code in the same folder as the TIFF files to be processed.
% 3. Run the code in MATLAB to extract the tile information and generate
%    the output text file.
%
% Note: Please replace the folder path, tile size, and overlap parameters
%       in the code with your actual values before running the code.
%
%------------------------------------------------------------------------
% Author: [Songyang]
% Date: [04/07/2023]
% Define tile size and overlap
tile_size = 10240; % Tile size (assuming square tiles)
overlap_percentage = 0.18;
overlap = tile_size*overlap_percentage; % Overlap size (in pixels)

% Get list of TIFF files in the folder
folder_path = 'D:\downloads\SEM four tiles MPFI'; % Replace with your folder path
tif_files = dir(fullfile(folder_path, '*.tif'));
num_files = numel(tif_files);

% Loop through each TIFF file
output_file = fopen('output.txt', 'w'); % Open output file for writing
for i = 1:num_files
    tif_file = tif_files(i);
    tif_name = tif_file.name;
    tif_path = fullfile(folder_path, tif_name);
    
    % Extract row and column information from file name
    row_col_info = sscanf(tif_name, 'Tile_r%d-c%d_');
    row = row_col_info(1);
    col = row_col_info(2);
    
    % Calculate X, Y, Z coordinates
    x = (col - 1) * (tile_size - overlap);
    y = (row - 1) * (tile_size - overlap);
    z = 0;
    
    % Write output to file
    fprintf(output_file, '%s\t%d\t%d\t%d\n', tif_name, x, y, z);
end

fclose(output_file); % Close output file
