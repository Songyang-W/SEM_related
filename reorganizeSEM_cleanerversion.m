% This script will filter the images, save the filtered Tiff and
% histogram in new folders named "filteredTiff" and "histogram"
% respectively, which will be created in the same directory as where the
% original images are present.

clc;clear all;close all;

% Read file names
filelist=dir;


% Get row and column information from the file names
for i = 1:length(filelist)
    if filelist(i).name(1) == '.' || filelist(i).name(1) == '_'
        continue % skip this file
    end

    TileName = filelist(i).name;
    rowcolInfo = strsplit(TileName,'-');
    rowInfo = rowcolInfo{1}(7:end);
    colcell=strsplit(rowcolInfo{2},'_');
    colInfo = colcell{1}(2:end);
    rowcolList(i,1) = str2num(rowInfo);
    rowcolList(i,2) = str2num(colInfo);
end

% Get total number of rows and columns
row_col_total=max(rowcolList);
row_total = row_col_total(1);
col_total = row_col_total(2);

% Create folder to save filtered images and histogram
if ~exist('../filteredTiff/0', 'dir')
    mkdir('../filteredTiff/0')
end

% Filter the images one by one, save the filtered image and histogram
for i = 1:length(filelist)

    if filelist(i).name(1) == '.' || filelist(i).name(1) == '_'
        continue % skip this file
    end
    image_name = filelist(i).name;
    rowcolInfo = strsplit(image_name,'-');
    rowInfo = rowcolInfo{1}(7:end);
    colcell=strsplit(rowcolInfo{2},'_');
    colInfo = colcell{1}(2:end);

    % Convert row and column numbers to four digits with leading zeros
    newrowName = num2str(str2num(rowInfo), '%04.f');
    newcolName = num2str(str2num(colInfo), '%04.f');
    newtifName = strcat(newrowName,'_',newcolName,'_0_b.tif');
    newhistName = strcat(newrowName,'_',newcolName,'_0_b.hst');

    % Read and filter the image
    I = imread(image_name);
    filtered_image = 255-I;

    % Save the filtered image
    if ~exist(['../filteredTiff/0/',newrowName] ,'dir')
        mkdir(['../filteredTiff/0/',newrowName])
    end
    imwrite(filtered_image,strcat('../filteredTiff/0/',newrowName,'/',newtifName),'tiff');

    % Calculate histogram and write to file
    Bin_Info = histogram(filtered_image,'BinEdges',0:1:256);
    hist_output = [Bin_Info.BinEdges(1:end-1);Bin_Info.Values];
    fileID = fopen(['../filteredTiff/0/',newrowName,'/',newhistName],'w');
    fprintf(fileID,'%f %f\n',hist_output);
    fclose(fileID);
end
close