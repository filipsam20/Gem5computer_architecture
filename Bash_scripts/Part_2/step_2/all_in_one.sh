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
# user=$(whoami)

# gem5_path=/home/$user/Desktop/gem5
# Benchmarks_results=/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/Benchmarks_results
# se_path=${gem5_path}/configs/example/se.py
# log_path=/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/logs/Bechmarks_opt

user=$(whoami)
default_version=0
gem5_path=/home/$user/Desktop/gem5
benchmark=$3
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

select_benchmark () {
    case $1 in
    "specbzip")
    data_c="$gem5_path/spec_cpu2006/401.bzip2/src/specbzip"
    data_o="$gem5_path/spec_cpu2006/401.bzip2/data/input.program 10"
    ;;
    "specmcf")
    data_c="$gem5_path/spec_cpu2006/429.mcf/src/specmcf"
    data_o="$gem5_path/spec_cpu2006/429.mcf/data/inp.in"
    ;;
    "spechmmer")
    data_c="$gem5_path/spec_cpu2006/456.hmmer/src/spechmmer"
    data_o="--fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 $gem5_path/spec_cpu2006/456.hmmer/data/bombesin.hmm"
    ;;
    "specsjeng")
    data_c="$gem5_path/spec_cpu2006/458.sjeng/src/specsjeng"
    data_o="$gem5_path/spec_cpu2006/458.sjeng/data/test.txt"
    ;;
    "speclibm")
    data_c="$gem5_path/spec_cpu2006/470.lbm/src/speclibm"
    data_o="20 $gem5_path/spec_cpu2006/470.lbm/data/lbm.in 0 1 $gem5_path/spec_cpu2006/470.lbm/data/100_100_130_cf_a.of"
    ;;
    esac
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

print_elements() {
    local index_l1i_size=$1
    local index_l1i_assoc=$2
    local index_l1d_size=$3
    local index_l1d_assoc=$4
    local index_l2_size=$5
    local index_l2_assoc=$6
    local index_cacheline_size=$7
    local index_list=("$1" "$2" "$3" "$4" "$5" "$6" "$7")
    return_list=()
    # Assign values to variables based on the indices
    if [ "$index_l1i_size" = "a" ]; then
        return_list+="${l1i_sizes[@]}"
    else
        return_list+="${l1i_sizes[$index_l1i_size]}"
    fi

    if [ "$index_l1i_assoc" = "a" ]; then
        return_list+="${l1i_assocs[@]}"
    else
        return_list+="${l1i_assocs[$index_l1i_assoc]}"
    fi

    if [ "$index_l1d_size" = "a" ]; then
        return_list+="${l1d_sizes[@]}"
    else    
        return_list+="${l1d_sizes[$index_l1d_size]}"
    fi

    if [ "$index_l1d_assoc" = "a" ]; then
        return_list+="${l1d_assocs[@]}"
    else
        return_list+="${l1d_assocs[$index_l1d_assoc]}"
    fi

    if [ "$index_l2_size" = "a" ]; then
        return_list+="${l2_sizes[@]}"
    else
        return_list+="${l2_sizes[$index_l2_size]}"
    fi

    if [ "$index_l2_assoc" = "a" ]; then
        return_list+="${l2_assocs[@]}"
    else
        return_list+="${l2_assocs[$index_l2_assoc]}"
    fi

    if [ "$index_cacheline_size" = "a" ]; then
        return_list+="${cacheline_sizes[@]}"
    else
        return_list+="${cacheline_sizes[$index_cacheline_size]}"
    fi

}

default=("1" "0" "2" "0" "2" "1" "2")

run_bench(){
    if [[ "$1" == "a" ]]; then
        test=("$@")
        test[0]=a
        echo "Test for L1_I size"
        echo "Test input: ${test[@]}"
        #get_elements echo $(echo ${default[@]})
        get_elements $(echo ${test[@]})

        index=0

        for l1i_size in "${l1i_sizes[@]}"; do 
            stdout_log="$log_path/${benchmark}/stdout/${benchmark}_l1i_size_${index}_out.log"
            stderr_log="$log_path/${benchmark}/stderr/${benchmark}_l1i_size_${index}_err.log"
            output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_l1i_size_$index"
            print_elements $(echo ${test[@]})
            mkdir -p $output_dir
            rm -f $output_dir/conf.txt
            touch $output_dir/conf.txt
            echo "${test[@]}" >> $output_dir/conf.txt
            echo "${return_list[@]}" > $output_dir/conf.txt
            run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
                $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
                $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
                > "$stdout_log" 2> "$stderr_log"

            index=$((index + 1))
        done

        wait_for_all_jobs

        echo "Test 1: L1i Size complete."
    elif [[ "$2" == "a" ]]; then
        test=("$@")
        test[1]=a
        echo "Test for L1_I assoc"
        echo "Test input: ${test[@]}"
        get_elements $(echo ${test[@]})
        
        index=0
        for l1i_assoc in "${l1i_assocs[@]}"; do 
            stdout_log="$log_path/${benchmark}/stdout/${benchmark}_l1i_assoc_${index}_out.log"
            stderr_log="$log_path/${benchmark}/stderr/${benchmark}_l1i_assoc_${index}_err.log"
            output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_l1i_assoc_$index"
            print_elements $(echo ${test[@]})
            mkdir -p $output_dir
            rm -f $output_dir/conf.txt
            touch $output_dir/conf.txt
            echo "${test[@]}" >> $output_dir/conf.txt
            echo "${return_list[@]}" > $output_dir/conf.txt
            run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
                $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
                $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
                > "$stdout_log" 2> "$stderr_log"

            index=$((index + 1))
        done

        wait_for_all_jobs

        echo "Test 2: L1i associetivity complete."
    elif [[ "$3" == "a" ]]; then
        test=("$@")
        test[2]=a
        echo "Test for L1_d size"
        echo "Test input: ${test[@]}"
        get_elements $(echo ${test[@]})
        index=0
        for l1d_size in "${l1d_sizes[@]}"; do 
            stdout_log="$log_path/${benchmark}/stdout/${benchmark}_l1d_size_${index}_out.log"
            stderr_log="$log_path/${benchmark}/stderr/${benchmark}_l1d_size_${index}_err.log"
            output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_l1d_size_$index"
            print_elements $(echo ${test[@]})
            mkdir -p $output_dir
            rm -f $output_dir/conf.txt
            touch $output_dir/conf.txt
            echo "${return_list[@]}" > $output_dir/conf.txt
            echo "${test[@]}" >> $output_dir/conf.txt
            run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
                $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
                $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
                > "$stdout_log" 2> "$stderr_log"

            index=$((index + 1))
        done

        wait_for_all_jobs

        echo "Test 3: L1d size complete."

    elif [[ "$4" == "a" ]]; then
        test=("$@")
        test[3]=a
        echo "Test for L1d assoc"
        echo "Test input: ${test[@]}"
        get_elements $(echo ${test[@]})
        
        index=0
        for l1d_assoc in "${l1d_assocs[@]}"; do 
            stdout_log="$log_path/${benchmark}/stdout/${benchmark}_l1d_assoc_${index}_out.log"
            stderr_log="$log_path/${benchmark}/stderr/${benchmark}_l1d_assoc_${index}_err.log"
            output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_l1d_assoc_$index"
            print_elements $(echo ${test[@]})
            mkdir -p $output_dir
            rm -f $output_dir/conf.txt
            touch $output_dir/conf.txt
            echo "${return_list[@]}" > $output_dir/conf.txt
            echo "${test[@]}" >> $output_dir/conf.txt
            run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
                $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
                $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
                > "$stdout_log" 2> "$stderr_log"

            index=$((index + 1))
        done

        wait_for_all_jobs

        echo "Test 4: L1d assoc complete."

    elif [[ "$5" == "a" ]]; then
        test=("$@")
        test[4]=a
        echo "Test for L2 size"
        echo "Test input: ${test[@]}"
        get_elements $(echo ${test[@]})

        index=0
        for l2_size in "${l2_sizes[@]}"; do 
            stdout_log="$log_path/${benchmark}/stdout/${benchmark}_l2_size_${index}_out.log"
            stderr_log="$log_path/${benchmark}/stderr/${benchmark}_l2_size_${index}_err.log"
            output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_l2_size_$index"
            print_elements $(echo ${test[@]})
            mkdir -p $output_dir
            rm -f $output_dir/conf.txt
            touch $output_dir/conf.txt
            echo "${return_list[@]}" > $output_dir/conf.txt
            echo "${test[@]}" >> $output_dir/conf.txt
            run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
                $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
                $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
                > "$stdout_log" 2> "$stderr_log"

            index=$((index + 1))
        done

        wait_for_all_jobs

        echo "Test 5: L2 size complete."

    elif [[ "$6" == "a" ]]; then
        test=("$@")
        test[5]=a
        echo "Test for L2 assoc"
        echo "Test input: ${test[@]}"
        get_elements $(echo ${test[@]})

        index=0
        for l2_assoc in "${l2_assocs[@]}"; do 
            stdout_log="$log_path/${benchmark}/stdout/${benchmark}_l2_assoc_${index}_out.log"
            stderr_log="$log_path/${benchmark}/stderr/${benchmark}_l2_assoc_${index}_err.log"
            output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_l2_assoc_$index"
            print_elements $(echo ${test[@]})
            mkdir -p $output_dir
            rm -f $output_dir/conf.txt
            touch $output_dir/conf.txt
            echo "${return_list[@]}" > $output_dir/conf.txt
            echo "${test[@]}" >> $output_dir/conf.txt
            run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
                $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
                $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
                > "$stdout_log" 2> "$stderr_log"

            index=$((index + 1))
        done

        wait_for_all_jobs

        echo "Test 6: L2 assoc complete."

    else
        test=("$@")
        test[6]=a
        echo "Test for cacheline size"
        echo "Test input: ${test[@]}"
        get_elements $(echo ${test[@]})

        index=0
        for cacheline_size in "${cacheline_sizes[@]}"; do 
            stdout_log="$log_path/${benchmark}/stdout/${benchmark}_cacheline_size_${index}_out.log"
            stderr_log="$log_path/${benchmark}/stderr/${benchmark}_cacheline_size_${index}_err.log"
            output_dir="${Benchmarks_results}/${benchmark}/results_opt/${benchmark}_cacheline_size_$index"
            print_elements $(echo ${test[@]})
            mkdir -p $output_dir
            rm -f $output_dir/conf.txt
            touch $output_dir/conf.txt
            echo "${return_list[@]}" > $output_dir/conf.txt
            echo "${test[@]}" >> $output_dir/conf.txt
            run_command ${gem5_path}/build/ARM/gem5.opt -d "$output_dir" "$se_path" \
                $cpu_type $cpu_clock --caches --l2cache $l1i_size $l1i_assoc $l1d_size $l1d_assoc \
                $l2_size $l2_assoc $cacheline_size -c "$data_c" -o "$data_o" -I $num_instructions \
                > "$stdout_log" 2> "$stderr_log"

            index=$((index + 1))
        done

        wait_for_all_jobs

        echo "Test 7: cacheline size complete."
    fi
}

select_benchmark $benchmark
run_bench "$4" "$5" "$6" "$7" "$8" "$9" "${10}"