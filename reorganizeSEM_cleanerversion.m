% This script will filter the images, save the filtered Tiff and
% histogram in new folders named "filteredTiff" and "histogram"
% respectively, which will be created in the same directory as where the
% original images are present.

clc;clear all;close all;
list_of_files={};
%%
for i =1:20
%     
cd(strcat("W:\Projects\Connectomics\Animals\jc105\SEM\SEM datasets\MPFI\",list_of_files{i,1}))
   % cd(strcat("G:\SEM datasets\MPFI\",list_of_files{i,1}))
    filename_in_jcform = list_of_files{i,2};
    % Read file names
    filelist=dir;
    % Calculate the overlap between images in the montage
    overlap = 10;  % Adjust the overlap value as desired
    flip = 0;

    % Create an empty cell array to store the newtifName values
    tifNames = {};
    % Get row and column information from the file names
    for i = 1:length(filelist)
        if filelist(i).name(1) == '.' || filelist(i).name(1) == '_'||filelist(i).name(1)~='T'
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
    if ~exist(['filteredTiff/',filename_in_jcform,'/0'], 'dir')
        mkdir(['filteredTiff/',filename_in_jcform,'/0'])
    end

    % Filter the images one by one, save the filtered image and histogram
    for i = 1:length(filelist)


        if filelist(i).name(1) == '.' || filelist(i).name(1) == '_'||filelist(i).name(1)~='T'
            continue % skip this file
        end
        image_name = filelist(i).name;
        rowcolInfo = strsplit(image_name,'-');
        rowInfo = rowcolInfo{1}(7:end);
        colcell=strsplit(rowcolInfo{2},'_');
        colInfo = colcell{1}(2:end);

        % Convert row and column numbers to four digits with leading zeros
%         newrowName = num2str(str2num(rowInfo), '%04.f');
        newrowName = num2str(row_total+1-str2num(rowInfo), '%04.f');
        newcolName = num2str(str2num(colInfo), '%04.f');
        newtifName = strcat(newrowName,'_',newcolName,'_0_b.tif');
        newhistName = strcat(newrowName,'_',newcolName,'_0_b.hst');

        % Read and filter the image
        I = flipud(imread(image_name));
        if flip
            filtered_image = 255-I;
        else
            filtered_image = I;
        end
        I_ds = imresize(I, 1/100);

        % Calculate the position of the image in the montage based on row and column information
        montageRow = row_total+1-str2num(rowInfo) + 1;  % Add 1 to account for MATLAB's 1-based indexing
        montageCol = str2num(colInfo) + 1;  % Add 1 to account for MATLAB's 1-based indexing

        % Calculate the overlap between images in the montage
        overlap = 10;  % Adjust the overlap value as desired

        % Calculate the montage size based on the image size and overlap
        imageSize = size(I_ds);
        montageSize = imageSize - (overlap * 2);

        % Create a blank montage if it doesn't exist yet
        if ~exist('montageImage', 'var')
            montageImage = uint8(zeros(row_total * montageSize(1), col_total * montageSize(2)));
        end

        % Calculate the position to place the downsampled image in the montage
        montagePosRow = (montageRow - 1) * montageSize(1) + 1;
        montagePosCol = (montageCol - 1) * montageSize(2) + 1;

        % Insert the downsampled image into the montage
        montageImage(montagePosRow:montagePosRow+imageSize(1)-1, montagePosCol:montagePosCol+imageSize(2)-1) = I_ds;
    



        % Save the filtered image
        if ~exist(['filteredTiff/',filename_in_jcform,'/0/',newrowName] ,'dir')
            mkdir(['filteredTiff/',filename_in_jcform,'/0/',newrowName])
        end
%         imwrite(filtered_image,strcat('filteredTiff/',filename_in_jcform,'/0/',newrowName,'/',newtifName),'tiff');
        % Store the newtifName in the tifNames cell array
        tifNames{i} = newtifName;
        % Calculate histogram and write to file
        Bin_Info = histogram(filtered_image,'BinEdges',0:1:256);
        hist_output = [Bin_Info.BinEdges(1:end-1);Bin_Info.Values];
        fileID = fopen(['filteredTiff/',filename_in_jcform,'/0/',newrowName,'/',newhistName],'w');
        fprintf(fileID,'%d %d\n',hist_output);
        fclose(fileID);
    end
    close

    imwrite(montageImage,['filteredTiff/',filename_in_jcform,'/',filename_in_jcform,'_bf_render.tif']);
    fileID = fopen(['filteredTiff/',filename_in_jcform,'/raw_images.lst'], 'w');
    for i = 1:length(tifNames)
        if ~isempty(tifNames{i})
        fprintf(fileID, '%s\n', tifNames{i});
        end
    end
    fclose(fileID);

    % Create the size.txt file
    sizeFileID = fopen(['filteredTiff/',filename_in_jcform,'/size.txt'], 'w');
    fprintf(sizeFileID, '1, %d, 1, %d\n', row_total, col_total);
    fclose(sizeFileID);

    % Create the size file
    sizeStr = sprintf('%d %d', row_total, col_total);
    sizeFileID = fopen(['filteredTiff/',filename_in_jcform,'/size'], 'w');
    fprintf(sizeFileID, '%s', sizeStr);
    fclose(sizeFileID);

    % Create the skip.txt file
    skipFileID = fopen(['filteredTiff/',filename_in_jcform,'/skip.txt'], 'w');
    fclose(skipFileID);

    copyfile('D:\downloads\limits.p', ['filteredTiff/',filename_in_jcform,'/']);
    copyfile('D:\downloads\histograms.p', ['filteredTiff/',filename_in_jcform,'/']);
end

