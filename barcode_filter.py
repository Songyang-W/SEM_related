import cv2
import sys

# Get the input image file name from command-line argument
if len(sys.argv) > 1:
    image_file = sys.argv[1]
else:
    print("Usage: python this_code.py <image_file>")
    sys.exit(1)

# Load the input image
image = cv2.imread(image_file)

# Check if image is loaded successfully
if image is None:
    print("Error: Failed to load image")
    sys.exit(1)

# Convert to HSB color space
hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

# Extract the Hue, Saturation, and Brightness components
hue = hsv[:,:,0]
saturation = hsv[:,:,1]
brightness = hsv[:,:,2]

# Define the threshold values for Hue, Saturation, and Brightness
hue_threshold_min = 0
hue_threshold_max = 255
saturation_threshold_min = 0
saturation_threshold_max = 255
brightness_threshold_min = 108
brightness_threshold_max = 255

# Apply thresholds to the Hue, Saturation, and Brightness components
hue_mask = cv2.inRange(hue, hue_threshold_min, hue_threshold_max)
saturation_mask = cv2.inRange(saturation, saturation_threshold_min, 
saturation_threshold_max)
brightness_mask = cv2.inRange(brightness, brightness_threshold_min, 
brightness_threshold_max)

# Combine the masks to create a final binary mask
combined_mask = cv2.bitwise_and(hue_mask, cv2.bitwise_and(saturation_mask, 
brightness_mask))

# Invert the binary mask
inverted_mask = 255 - combined_mask

# Save the filtered and inverted image
filtered_inverted_image = cv2.bitwise_and(image, image, 
mask=inverted_mask)
cv2.imwrite(image_file.split('.')[0] + '_filtered_inverted.png', 
filtered_inverted_image)


