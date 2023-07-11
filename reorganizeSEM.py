import os
import sys
import numpy as np
import cv2
import npimage

def filter_image(image_path):
    # Read and filter the image
    I = cv2.flip(cv2.imread(image_path, cv2.IMREAD_GRAYSCALE), 0)
    I_ds = cv2.resize(I, (int(I.shape[1]/100), int(I.shape[0]/100)))
    return I_ds, I

def create_folder_if_not_exists(folder_path):
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)

def save_filtered_image(image, save_path):
    cv2.imwrite(save_path, image)

def create_mask(image, save_path):
    mask = image == 0
    cv2.imwrite(save_path, mask.astype(np.uint8))
    #npimage.save(save_path,mask)

def calculate_histogram(image):
    hist_output, _ = np.histogram(image.flatten(), bins=np.arange(257))
    hist_output = np.vstack((np.arange(256), hist_output)).T
    return hist_output

# Define the path to the directory containing the original images
# directory = "W:/Projects/Connectomics/Animals/jc105/SEM/SEM datasets/MPFI"
directory = "/mnt/emlodebu2_tank1/SEM/"
save_directory = "/n/data3/hms/neurobio/htem/temcagt/datasets/jc105_r214/sections"

# Get the command-line arguments
flip = sys.argv[1] == "True"
make_masks = sys.argv[2] == "True"
save_figures = sys.argv[3] == "True"
filename_in_jcform = sys.argv[4]
target_directory = sys.argv[5]

# Clear the montage_image variable
montage_image = None

# Change the current working directory
os.chdir(os.path.join(directory, target_directory))

# Read file names
file_list = os.listdir()

# Create a list to store new Tiff and histogram names
tif_names = []

rowcol_list = np.zeros((len(file_list), 2), dtype=np.int32)

for tif_index in range(len(file_list)):
    if file_list[tif_index][0] == '.' or file_list[tif_index][0] == '_' or file_list[tif_index][0] != 'T':
        continue  # Skip this file
            
    image_name = file_list[tif_index]
    row_col_info = image_name.split('-')
    row_info = row_col_info[0][6:]
    col_info = row_col_info[1].split('_')[0][1:]
            
    rowcol_list[tif_index, 0] = int(row_info)
    rowcol_list[tif_index, 1] = int(col_info)
        
# Get the total number of rows and columns
row_col_total = np.max(rowcol_list, axis=0)
row_total = row_col_total[0]
col_total = row_col_total[1]
        
# Filter the images one by one, save the filtered image and histogram
for tif_index in range(len(file_list)):
    if file_list[tif_index][0] == '.' or file_list[tif_index][0] == '_' or file_list[tif_index][0] != 'T':
        continue  # Skip this file
            
    image_name = file_list[tif_index]
    row_col_info = image_name.split('-')
    row_info = row_col_info[0][6:]
    col_info = row_col_info[1].split('_')[0][1:]
            
    # Convert row and column numbers to four digits with leading zeros
    new_row_name = "{:04d}".format(row_total+1-int(row_info))
    new_col_name = "{:04d}".format(int(col_info))
    new_tif_name = f"{new_row_name}_{new_col_name}_0_b.tif"
    new_hist_name = f"{new_row_name}_{new_col_name}_0_b.hst"
        
    # Read and filter the image
    #I_ds, I = filter_image(image_name, flip)
    
    if flip:
        I_ds, I = 255-filter_image(image_name)
        I_ds_mask, I_mask = filter_image(image_name)
    else:
        I_ds, I = filter_image(image_name)
            
    # Calculate the position of the image in the montage based on row and column information
    montage_row = row_total+1-int(row_info) + 1  # Add 1 to account for Python's 0-based indexing
    montage_col = int(col_info) + 1  # Add 1 to account for Python's 0-based indexing
            
    # Calculate the overlap between images in the montage
    overlap = 10  # Adjust the overlap value as desired
            
    # Calculate the montage size based on the image size and overlap
    image_size = I_ds.shape
    montage_size = (image_size[0] - (overlap * 2), image_size[1] - (overlap * 2))
            
    # Create a blank montage if it doesn't exist yet
    if montage_image is None:
        montage_image = np.zeros((row_total * (montage_size[0] + overlap) + overlap, col_total * (montage_size[1] + overlap) + overlap), dtype=np.uint8)
    
    # Calculate the position to place the downsampled image in the montage
    montage_pos_row = (montage_row - 1) * montage_size[0]
    montage_pos_col = (montage_col - 1) * montage_size[1]
            
    # Insert the downsampled image into the montage
    montage_image[montage_pos_row:montage_pos_row+image_size[0], montage_pos_col:montage_pos_col+image_size[1]] = I_ds
            
    # Save the filtered image
    create_folder_if_not_exists(f"{save_directory}/{filename_in_jcform}/0/{new_row_name}")
    create_folder_if_not_exists(f"{save_directory}/{filename_in_jcform}/intrasection/masks/0/{new_row_name}")
            
    if save_figures:
        save_filtered_image(I, f"{save_directory}/{filename_in_jcform}/0/{new_row_name}/{new_tif_name}")
            
    if make_masks:
        if flip:
            create_mask(I_mask, f"{save_directory}/{filename_in_jcform}/intrasection/masks/0/{new_row_name}/{new_row_name}_{new_col_name}_0_b.pbm")
        else:
            create_mask(I, f"{save_directory}/{filename_in_jcform}/intrasection/masks/0/{new_row_name}/{new_row_name}_{new_col_name}_0_b.pbm")

   
    
    # Store the new_tif_name in the tif_names list
    tif_names.append(new_tif_name)
            
    # Calculate histogram and write to file
    hist_output = calculate_histogram(I)
    with open(f"{save_directory}/{filename_in_jcform}/0/{new_row_name}/{new_hist_name}", 'w') as file_id:
        np.savetxt(file_id, hist_output, fmt='%d %d')

    print(f"finish {new_tif_name}")   
# Save the montage image
cv2.imwrite(f"{save_directory}/{filename_in_jcform}/{filename_in_jcform}_bf_render.tif", montage_image)

# Save the montage image
cv2.imwrite(f"{save_directory}/{filename_in_jcform}/{filename_in_jcform}_bf_render.tif", montage_image)
    
# Create the raw_images.lst file
with open(f"{save_directory}/{filename_in_jcform}/raw_images.lst", 'w') as file_id:
    for raw_image_index in range(len(tif_names)):
        if tif_names[raw_image_index] != "":
            file_id.write(f"{tif_names[raw_image_index]}\n")
    
# Create the size.txt file
with open(f"{save_directory}/{filename_in_jcform}/size.txt", 'w') as size_file_id:
    size_file_id.write(f"1, {row_total}, 1, {col_total}\n")
    
# Create the size file
size_str = f"{row_total} {col_total}"
with open(f"{save_directory}/{filename_in_jcform}/size", 'w') as size_file_id:
    size_file_id.write(size_str)
    
    
# Copy files
#os.system("cp D:/downloads/limits.p filteredTiff/{filename_in_jcform}/")
#os.system("cp D:/downloads/histograms.p filteredTiff/{filename_in_jcform}/")
