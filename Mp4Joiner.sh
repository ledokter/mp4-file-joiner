#!/bin/bash

# Ask for the number of files to concatenate at a time
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

# Function to get a unique filename
get_unique_filename() {
    local base_name="$1"
    local extension="${base_name##*.}"
    local name_without_extension="${base_name%.*}"
    local counter=1
    local new_name="$base_name"
    
    while [[ -f "$new_name" ]]; do
        new_name="${name_without_extension}_${counter}.${extension}"
        ((counter++))
    done
    
    echo "$new_name"
}

# Process files
find . -maxdepth 1 -name "*.mp4" -print0 | sort -z | while IFS= read -r -d '' file; do
    # Escape single quotes in the filename and surround with single quotes
    escaped_file=$(printf "%s" "${file#./}" | sed "s/'/'\\\\''/g")
    echo "file '${escaped_file}'" >> concat_list.txt
    
    # If we've read the desired number of files, concatenate them
    if [ $(wc -l < concat_list.txt) -eq $num_files ]; then
        output_file="${prefix}-${count}.mp4"
        unique_output_file=$(get_unique_filename "$output_file")
        ffmpeg -y -f concat -safe 0 -i concat_list.txt -c copy "$unique_output_file"

        # Increment the counter
        ((count++))

        # Clean up the temporary list file
        rm concat_list.txt
    fi
done

# Handle any remaining files
if [ -f concat_list.txt ]; then
    output_file="${prefix}-${count}.mp4"
    unique_output_file=$(get_unique_filename "$output_file")
    ffmpeg -y -f concat -safe 0 -i concat_list.txt -c copy "$unique_output_file"
    rm concat_list.txt
fi

echo "Concatenation completed. Files have been created with the prefix '${prefix}'."
