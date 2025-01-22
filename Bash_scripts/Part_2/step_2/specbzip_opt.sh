#!/usr/bin/bash
# Test values
# L1 i-cache sizes 16kB 32kB 64kB 128kB
# L1 d-cache sizes 16kB 32kB 64kB 128kB

# L1 i-cache assoc 2 4 8 16
# L1 d-cache assoc 2 4 8 16

# L2 sizes 512kB 1024kB 2048kB 4096kB
# L2 assoc  4 8 16 32 64 128

# cacheline size 16 32 64 128 256 512

# Default values

# L1 i-cache sizes 32kB 
# L1 d-cache sizes 64kB

# L1 i-cache assoc 2
# L1 d-cache assoc 2

# L2 sizes 2048kB
# L2 assoc 8

# cacheline size 64

#Variables
user=$(whoami)
benchmark="specbzip"
default_version=0
gem5_path=/home/$user/Desktop/gem5
Benchmarks_results=/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/Benchmarks_results/Benchmarks_results_v${2:-default_version}
se_path=${gem5_path}/configs/example/se.py
log_path=/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/logs/Bechmarks_opt_v${2:-default_version}

mkdir -p $log_path $Benchmarks_results $log_path/$benchmark/stderr $log_path/$benchmark/stdout

default_instr=100000000
num_instructions="${1:-default_instr}"
max_parallel=4

declare -i running_jobs=0
declare -i index=0
declare -a pids



cpu_type="--cpu-type=MinorCPU"
cpu_clock="--cpu-clock=1GHz"

data_c="$gem5_path/spec_cpu2006/401.bzip2/src/specbzip"
data_o="$gem5_path/spec_cpu2006/401.bzip2/data/input.program 10"



# Function to run a command and manage concurrency
run_command() {
    "$@" &  # Run command in the background
    pids+=($!)  # Store the PID of the background process
    running_jobs=$((running_jobs + 1))

    # Wait if the number of running jobs reaches the limit
    if (( running_jobs >= max_parallel )); then
        wait -n  # Wait for the first job to finish
        running_jobs=$((running_jobs - 1))
    fi
}

# Function to wait for all background processes to finish
wait_for_all_jobs() {
    while (( running_jobs > 0 )); do
        wait -n
        running_jobs=$((running_jobs - 1))
    done
}


l1i_sizes=("--l1i_size=16kB" "--l1i_size=32kB" "--l1i_size=64kB" "--l1i_size=128kB")
l1i_assocs=("--l1i_assoc=2" "--l1i_assoc=4" "--l1i_assoc=8" "--l1i_assoc=16")

l1d_sizes=("--l1d_size=16kB" "--l1d_size=32kB" "--l1d_size=64kB" "--l1d_size=128kB")
l1d_assocs=("--l1d_assoc=2" "--l1d_assoc=4" "--l1d_assoc=8" "--l1d_assoc=16")

l2_sizes=("--l2_size=512kB" "--l2_size=1024kB" "--l2_size=2048kB" "--l2_size=4096kB")
l2_assocs=("--l2_assoc=4" "--l2_assoc=8" "--l2_assoc=16" "--l2_assoc=32" "--l2_assoc=64")

cacheline_sizes=("--cacheline_size=16" "--cacheline_size=32" "--cacheline_size=64" "--cacheline_size=128" "--cacheline_size=256")

get_elements() {
    local index_l1i_size=$1
    local index_l1i_assoc=$2
    local index_l1d_size=$3
    local index_l1d_assoc=$4
    local index_l2_size=$5
    local index_l2_assoc=$6
    local index_cacheline_size=$7

    # Assign values to variables based on the indices
    if [ "$index_l1i_size" = "a" ]; then
        l1i_sizes=("${l1i_sizes[@]}")
    else
        l1i_size="${l1i_sizes[$index_l1i_size]}"
    fi

    if [ "$index_l1i_assoc" = "a" ]; then
        l1i_assocs=("${l1i_assocs[@]}")
    else
        l1i_assoc="${l1i_assocs[$index_l1i_assoc]}"
    fi

    if [ "$index_l1d_size" = "a" ]; then
        l1d_sizes=("${l1d_sizes[@]}")
    else    
        l1d_size="${l1d_sizes[$index_l1d_size]}"
    fi

    if [ "$index_l1d_assoc" = "a" ]; then
        l1d_assocs=("${l1d_assocs[@]}")
    else
        l1d_assoc="${l1d_assocs[$index_l1d_assoc]}"
    fi

    if [ "$index_l2_size" = "a" ]; then
        l2_sizes=("${l2_sizes[@]}")
    else
        l2_size=("${l2_sizes[$index_l2_size]}")
    fi

    if [ "$index_l2_assoc" = "a" ]; then
        l2_assocs=("${l2_assocs[@]}")
    else
        l2_assoc="${l2_assocs[$index_l2_assoc]}"
    fi

    if [ "$index_cacheline_size" = "a" ]; then
        cacheline_sizes=("${cacheline_sizes[@]}")
    else
        cacheline_size=("${cacheline_sizes[$index_cacheline_size]}")
    fi
}


# Function to read the .ini file and extract values from the [Tests] section
read_ini() {
    local ini_file=$1
    local test_section_started=false

    # Read through the ini file and process lines
    while IFS= read -r line; do
        # Skip empty lines or comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Detect the [Tests] section
        if [[ "$line" == "[Tests]" ]]; then
            test_section_started=true
            continue
        fi

        # If inside the [Tests] section, process each test case
        if $test_section_started; then
            # Split the line into an array of indices
            read -r l1i_index l1d_index l2_index cacheline_index <<< "$line"

            # Call get_elements function with the extracted indices
            get_elements "$l1i_index" "$l1d_index" "$l2_index" "$cacheline_index"
        fi
    done < "$ini_file"
}

default=("1" "0" "2" "0" "2" "1" "2")

# test_1=("${default[@]}")
# test_1[0]=a
# echo "Test for L1_I size"
# echo "Test input: ${test_1[@]}"
# #get_elements echo $(echo ${default[@]})
# get_elements $(echo ${test_1[@]})

# index=0

# for l1i_size in "${l1i_sizes[@]}"; do 
#     stdout_log="$log_path/${benchmark}/stdout/${benchmark}_l1i_size_${index}_out.log"
#     stderr_log="$log_path/${benchmark}/stderr/${benchmark}_l1i_size_${index}_err.log"
#     output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_l1i_size_$index"

#     run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
#         $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
#         $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
#         > "$stdout_log" 2> "$stderr_log"

#     index=$((index + 1))
# done

# wait_for_all_jobs

# echo "Test 1: L1i Size complete."

# test=("${default[@]}")
# test[1]=a
# echo "Test for L1_I assoc"
# echo "Test input: ${test[@]}"
# get_elements $(echo ${test[@]})

# index=0
# for l1i_assoc in "${l1i_assocs[@]}"; do 
#     stdout_log="$log_path/${benchmark}/stdout/${benchmark}_l1i_assoc_${index}_out.log"
#     stderr_log="$log_path/${benchmark}/stderr/${benchmark}_l1i_assoc_${index}_err.log"
#     output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_l1i_assoc_$index"

#     run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
#         $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
#         $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
#         > "$stdout_log" 2> "$stderr_log"

#     index=$((index + 1))
# done

# wait_for_all_jobs

# echo "Test 2: L1i associetivity complete."

# test=("${default[@]}")
# test[2]=a
# echo "Test for L1_d size"
# echo "Test input: ${test[@]}"
# get_elements $(echo ${test[@]})

# index=0
# for l1d_size in "${l1d_sizes[@]}"; do 
#     stdout_log="$log_path/${benchmark}/stdout/${benchmark}_l1d_size_${index}_out.log"
#     stderr_log="$log_path/${benchmark}/stderr/${benchmark}_l1d_size_${index}_err.log"
#     output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_l1d_size_$index"

#     run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
#         $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
#         $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
#         > "$stdout_log" 2> "$stderr_log"

#     index=$((index + 1))
# done

# wait_for_all_jobs

# echo "Test 3: L1d size complete."

# test=("${default[@]}")
# test[3]=a
# echo "Test for L1d assoc"
# echo "Test input: ${test[@]}"
# get_elements $(echo ${test[@]})

# index=0
# for l1d_assoc in "${l1d_assocs[@]}"; do 
#     stdout_log="$log_path/${benchmark}/stdout/${benchmark}_l1d_assoc_${index}_out.log"
#     stderr_log="$log_path/${benchmark}/stderr/${benchmark}_l1d_assoc_${index}_err.log"
#     output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_l1d_assoc_$index"

#     run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
#         $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
#         $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
#         > "$stdout_log" 2> "$stderr_log"

#     index=$((index + 1))
# done

# wait_for_all_jobs

# echo "Test 4: L1d assoc complete."

# test=("${default[@]}")
# test[2]=3
# test[4]=a
# echo "Test for L2 size"
# echo "Test input: ${test[@]}"
# get_elements $(echo ${test[@]})

# index=0
# for l2_size in "${l2_sizes[@]}"; do 
#     stdout_log="$log_path/${benchmark}/stdout/${benchmark}_l2_size_${index}_out.log"
#     stderr_log="$log_path/${benchmark}/stderr/${benchmark}_l2_size_${index}_err.log"
#     output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_l2_size_$index"

#     run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
#         $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
#         $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
#         > "$stdout_log" 2> "$stderr_log"

#     index=$((index + 1))
# done

# wait_for_all_jobs

# echo "Test 5: L2 size complete."


# test=("${default[@]}")
# test[5]=a
# echo "Test for L2 assoc"
# echo "Test input: ${test[@]}"
# get_elements $(echo ${test[@]})

# index=0
# for l2_assoc in "${l2_assocs[@]}"; do 
#     stdout_log="$log_path/${benchmark}/stdout/${benchmark}_l2_assoc_${index}_out.log"
#     stderr_log="$log_path/${benchmark}/stderr/${benchmark}_l2_assoc_${index}_err.log"
#     output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_l2_assoc_$index"

#     run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
#         $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
#         $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
#         > "$stdout_log" 2> "$stderr_log"

#     index=$((index + 1))
# done

# wait_for_all_jobs

# echo "Test 6: L2 assoc complete."


test=("${default[@]}")
test[6]=a
test[2]=3
test[4]=3
echo "Test for cacheline size"
echo "Test input: ${test[@]}"
get_elements $(echo ${test[@]})

index=0
for cacheline_size in "${cacheline_sizes[@]}"; do 
    stdout_log="$log_path/${benchmark}/stdout/${benchmark}_cacheline_size_${index}_out.log"
    stderr_log="$log_path/${benchmark}/stderr/${benchmark}_cacheline_size_${index}_err.log"
    output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_cacheline_size_$index"

    run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
        $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
        $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
        > "$stdout_log" 2> "$stderr_log"

    index=$((index + 1))
done

wait_for_all_jobs

echo "Test 7: cacheline size complete."