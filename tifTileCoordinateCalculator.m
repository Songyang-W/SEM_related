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
clc;clear all;close all
folderPath = pwd;
% Set flag for cropping

% Set number of rows to crop from the top (default is 0)
numRowsToCrop = 200; % Change to desired value if needed

% Set tile size and overlap parameters
tile_size = 10240; % Tile size (assuming square tiles)
overlap_percentage = 0.2;
overlap = tile_size*overlap_percentage; % Overlap size (in pixels)

% Calculate overlap taking into account the number of rows to crop
% Calculate overlap taking into account the number of rows to crop
if numRowsToCrop
    overlapY = overlap -numRowsToCrop;
    overlapX = overlap; % Keep overlap in X direction unchanged
else
    overlapX = overlap;
    overlapY = overlap;
end

% Get list of TIFF files in the folder
tifFiles = dir(fullfile(folderPath, '*.tif'));
numFiles = numel(tifFiles);

% Open output text file for writing
txtFileName = 'output1.txt'; % Change this to your desired output file name
fid = fopen(txtFileName, 'w'); % Use 'w' flag to overwrite the file

% Process each TIFF file
for i = 1:numFiles
    % Load TIFF image
    tifName = tifFiles(i).name;
    tifPath = fullfile(folderPath, tifName);
    image = imread(tifPath);

    % Extract row and column information from TIFF file name
    [~, tifNameWithoutExt, ~] = fileparts(tifName);
    splitName = split(tifNameWithoutExt, '_');
    rowAndCol = split(splitName{2}, '-c');
    row = str2double(rowAndCol{1}(2:end));
    col = str2double(rowAndCol{2}(2:end));
    % Calculate X, Y, Z coordinates
    x = (col - 1) * (tile_size - overlapX);
    y = (row - 1) * (tile_size - overlapY);
    z = 0;

    % Write coordinates to text file
    fprintf(fid, '%s\t%d\t%d\t%d\n', tifName, x, y, z);
end

% Close the output text file
fclose(fid);