#!/bin/bash

# Counter for the join number
count=1

# Create a temporary list of all MP4 files
ls *.mp4 > all_files.txt

# Read files in groups of 3
while read -r file1 && read -r file2 && read -r file3; do
    # Create a list file for ffmpeg
    echo "file '$file1'" > concat_list.txt
    echo "file '$file2'" >> concat_list.txt
    echo "file '$file3'" >> concat_list.txt

    # Concatenate files with ffmpeg
    ffmpeg -f concat -safe 0 -i concat_list.txt -c copy "Comp-$count.mp4"

    # Increment the counter
    ((count++))

    # Clean up the temporary list file
    rm concat_list.txt
done < all_files.txt

# Clean up the list of all files
rm all_files.txt
