#!/bin/bash

# Remove and create the final.csv file
user=$(whoami)

# Path to the directory containing the results
benchmark_folder="/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/Benchmarks"
mkdir -p /home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/Part_2/step_1
filename="/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/Part_2/step_1/benchmarks.csv"
if [ -f $filename ] || [ -f ${filename}.txt ]; then
    rm -f $filename
    rm -f ${filename}.txt

fi
touch $filename
touch ${filename}.txt

# Add headers to the CSV
echo "Directory,Command,Result" >> $filename

# Directories to be looped through
DIRS=("specbzip" "spechmmer" "speclibm" "specmcf" "specsjeng")

# List of values to search for in the stats.txt files
values=("sim_seconds" "system.cpu.cpi" "system.cpu.icache.overall_miss_rate::total" "system.cpu.dcache.overall_miss_rate::total" "system.l2.overall_miss_rate::total")

# Loop through directories
for i in "${DIRS[@]}"; do
    echo "$i" >> ${filename}.txt
    # Loop through values to search for in stats.txt
    for command in "${values[@]}"; do
        # Search for the command in the file and extract only the numeric value
        result=$(grep "$command" "$benchmark_folder/$i/stats.txt" | awk '{print $2}')  # Extract second column (numeric value)

        if [ -n "$result" ]; then
            # If there's a result, write it as a CSV line
            echo "\"$i\",\"$command\",\"$result\"" >> $filename
            echo "$command: $result" >> ${filename}.txt  
        else
            # If no result, log that no result was found
            echo "\"$i\",\"$command\",\"No result found\"" >> $filename
            echo "$command: No result found" >> ${filename}.txt
        fi
    done
done

