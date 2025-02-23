#!/bin/bash

# Ask for the number of files to concatenate
read -p "How many files do you want to concatenate at a time? " num_files

# Ask for the prefix for output files
read -p "What prefix do you want to use for the output files? " prefix

# Check if inputs are valid
if ! [[ "$num_files" =~ ^[0-9]+$ ]] || [ "$num_files" -lt 1 ]; then
    echo "Error: The number of files must be a positive integer."
    exit 1
fi

if [ -z "$prefix" ]; then
    echo "Error: The prefix cannot be empty."
    exit 1
fi

# Counter for the join number
count=1

# Create a temporary list of all MP4 files
ls *.mp4 > all_files.txt

# Read files in groups based on user input
while read -r file; do
    # Create a list file for ffmpeg
    echo "file '$file'" >> concat_list.txt
    
    # If we've read the desired number of files, concatenate them
    if [ $(wc -l < concat_list.txt) -eq $num_files ]; then
        # Concatenate files with ffmpeg
        ffmpeg -f concat -safe 0 -i concat_list.txt -c copy "${prefix}-${count}.mp4"

        # Increment the counter
        ((count++))

        # Clean up the temporary list file
        rm concat_list.txt
    fi
done < all_files.txt

# Handle any remaining files
if [ -f concat_list.txt ]; then
    ffmpeg -f concat -safe 0 -i concat_list.txt -c copy "${prefix}-${count}.mp4"
    rm concat_list.txt
fi

# Clean up the list of all files
rm all_files.txt

echo "Concatenation completed. Files have been created with the prefix '${prefix}'."
