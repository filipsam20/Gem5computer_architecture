#!/usr/bin/bash

# Function to show help message
show_help() {
    echo "Usage: $0 <file1> <file2> [<output_file>]"
    echo
    echo "This script compares two files using the 'diff' command with the -y option."
    echo "If you want to save the results to a file, you can specify the output file name."
    echo
    echo "Example:"
    echo "$0 file1.txt file2.txt"
    echo "$0 file1.txt file2.txt results.txt"
    echo
}

# Check if the --help or -h option is provided
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
    exit 0
fi

# Check if at least two files are provided as input
if [ "$#" -lt 2 ]; then
    echo "Error: You must provide at least two files for comparison."
    show_help
    exit 1
fi

# Store the file names
file1="$1"
file2="$2"
output_file="$3"

# Check if the files exist
if [ ! -f "$file1" ]; then
    echo "File '$file1' not found!"
    exit 1
fi

if [ ! -f "$file2" ]; then
    echo "File '$file2' not found!"
    exit 1
fi

# Use diff to compare the two files
echo "Comparing files: $file1 and $file2"
echo "-----------------------------------------------------"
diff_output=$(diff -y "$file1" "$file2" | grep '|')

# Display the result on the screen and save to a file if specified
if [ -z "$output_file" ]; then
    # If no output file is provided, print the result on the screen
    echo "$diff_output"
else
    # If an output file is provided, save the result to that file
    echo "$diff_output" > "$output_file"
    echo "The results have been saved to '$output_file'."
fi
