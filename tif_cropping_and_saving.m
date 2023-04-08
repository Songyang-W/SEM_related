% Name: TIFF Image Cropping and Saving
% Description: This MATLAB code reads TIFF images from a specified folder, crops them based on the number of rows to crop from the top (if enabled), and saves the cropped images to a subfolder called "cropped_images" within the same folder as the original TIFF images. The cropped images are saved with a new file name that includes the row and column information extracted from the original TIFF file name.
% Input parameters:
%   - folderPath: Folder containing TIFF files
%   - tileSize: Tile size (assuming square tiles)
%   - overlap: Overlap size (assuming same overlap in X and Y direction)
%   - crop: Flag to indicate if cropping is enabled
%   - numRowsToCrop: Number of rows to crop from the top (default is 0)
% Output: Cropped images saved in the "cropped_images" subfolder
% Specify input parameters
% Set number of rows to crop from the top (default is 0)
numRowsToCrop = 450; % Change to desired value if needed
folderPath = pwd;

% Set tile size and overlap parameters
tile_size = 10240; % Tile size (assuming square tiles)
overlap_percentage = 0.2;
overlap = tile_size*overlap_percentage; % Overlap size (in pixels)


% Calculate overlap taking into account the number of rows to crop
if numRowsToCrop
    overlapY = overlap -tile_size;
    overlapX = overlap; % Keep overlap in X direction unchanged
else
    overlapX = overlap;
    overlapY = overlap;
end

% Create subfolder for cropped images
croppedFolder = fullfile(folderPath, 'cropped_images');
if ~exist(croppedFolder, 'dir')
    mkdir(croppedFolder);
end

% Get list of TIFF files in the folder
tifFiles = dir(fullfile(folderPath, '*.tif'));
numFiles = numel(tifFiles);

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
    
    % Calculate crop indices
    if numRowsToCrop
        cropStartY = numRowsToCrop + 1;
        cropEndY = size(image, 1);
    else
        cropStartY = 1;
        cropEndY = size(image, 1);
    end
    cropStartX = 1;
    cropEndX = size(image, 2);
    
    % Crop image
    croppedImage = image(cropStartY:cropEndY, cropStartX:cropEndX, :);
    
    % Save cropped image to subfolder
    croppedName = sprintf(tifName);
    croppedPath = fullfile(croppedFolder, croppedName);
    imwrite(croppedImage, croppedPath);
end
