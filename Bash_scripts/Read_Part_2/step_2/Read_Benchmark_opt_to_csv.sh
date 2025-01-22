fuser=$(whoami)

specs=("specbzip" "spechmmer" "speclibm" "specmcf" "specsjeng")

version=2

Benchmarks_results_opt=/home/$fuser/Desktop/git/gem5_1/Architecture_Assignment_Gem5/Benchmarks_results/Benchmarks_results_v${version}

tests=("l1i_size" "l1i_assoc" "l1d_size" "l1d_assoc" "l2_size" "l2_assoc" "cacheline_size")

results_folder=/home/$fuser/Desktop/git/gem5_1/Architecture_Assignment_Gem5/csv_opt_v${version}

mkdir -p $results_folder


for test in "${tests[@]}"; do
    # If the files exist, remove them, and create new empty files
    rm -f $results_folder/${test}_v${version}.csv
    rm -f $results_folder/${test}_v${version}.txt
    touch $results_folder/${test}_v${version}.csv
    touch $results_folder/${test}_v${version}.txt
    
    for spec in "${specs[@]}"; do
        # Get the output for the test
        output=$(find $Benchmarks_results_opt/$spec/results_opt -name "*$test*" -type d | sort -n | xargs -I {} find {} -name "stats.txt" | xargs -I {} cat {} | grep cpi | awk '{print $2}')
        
        # Prepare CSV format: convert output to comma-separated values
        output_csv=$(echo "$output" | tr '\n' ',' | sed 's/,$//')  # Remove the trailing comma
        
        # Write to CSV file (spec followed by the cpi values)
        echo "$spec,$output_csv" >> $results_folder/${test}_v${version}.csv
        
        # Write to Text file (spec followed by the cpi values on the same line)
        echo "$spec: $output" | tr '\n' ' ' >> $results_folder/${test}_v${version}.txt
        echo "" >> $results_folder/${test}_v${version}.txt  # Add a newline after each benchmark
    done
done
