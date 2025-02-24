# MP4 File Joiner

## Description

This Bash script automates the process of joining MP4 files in groups using ffmpeg. It's particularly useful for combining multiple video segments into longer videos without re-encoding, which preserves the original quality.

## Features

- Automatically detects all MP4 files in the current directory
- Joins files in groups of three
- Uses ffmpeg for lossless concatenation
- Automatically names output files (Join-1.mp4, Join-2.mp4, etc.)
- Cleans up temporary files after processing

## Requirements

- Bash shell
- ffmpeg

## Installation

1. Clone this repository or download the script file.
2. Make sure the script is executable:



## Usage

1. Place the script in the same directory as your MP4 files.
2. Run the script:


3. The script will process all MP4 files in the current directory and create new joined files.

## How it works

1. The script creates a list of all MP4 files in the current directory.
2. It reads these files in groups of three.
3. For each group, it creates a temporary list file for ffmpeg.
4. It uses ffmpeg to concatenate the three files into a new file named "Join-X.mp4", where X is a number that increments with each group.
5. It cleans up temporary files after each concatenation and at the end of the script.

## Notes

- The script will process all MP4 files in the directory. Make sure you only have the files you want to join in the directory.
- If the total number of files is not divisible by 3, the last group may have fewer than 3 files.
- The original files are not modified or deleted.

## License

[MIT License](LICENSE)

## Contributing

Contributions, issues, and feature requests are welcome. Feel free to check [issues page](https://github.com/ledokter/mp4-file-joiner/issues) if you want to contribute.

## Author

Ledokter

