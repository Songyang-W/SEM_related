import sys
import os

# Get the input file name from the command line
input_file_name = sys.argv[1]

# Set the output file name
output_file_name = os.path.splitext(input_file_name)[0] + "_output.txt"

# Read the input file
with open(input_file_name, "r") as file:
    lines = file.readlines()

# Create a dictionary to store the rows and their corresponding filenames
row_dict = {}

# Loop through each line in the input file
for line in lines:
    # Strip any whitespace from the line
    line = line.strip()
    # Get the row number from the filename
    row = int(line.split("_")[0])
    # Get the column number from the filename
    col = int(line.split("_")[1])
    # Check if the row is already in the dictionary
    if row not in row_dict:
        # If not, add the row and the first filename to the dictionary
        row_dict[row] = [line]
    else:
        # If the row is already in the dictionary, append the filename to the row's list
        row_dict[row].append(line)

# Open the output file
with open(output_file_name, "w") as file:
    # Loop through each row in the dictionary
    for row in row_dict.keys():
        # Write the first two filenames for the row to the output file
        file.write(f"{row_dict[row][0]}\n{row_dict[row][1]}\n")

