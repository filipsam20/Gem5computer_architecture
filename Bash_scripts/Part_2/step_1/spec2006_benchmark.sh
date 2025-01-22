#!/usr/bin/bash

# Spec2006 Benchmark Tests with Different Configurations
user=$(whoami)
gem5_path="/home/$user/Desktop/gem5"
spec_results="/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/Benchmarks_custom_Spec2006"
spec_default_results="/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/Benchmarks"
spec_cpu2006="$gem5_path/spec_cpu2006"
operations=100000000
std_log_path=/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/logs/Benchmarks_custom_spec2006/stdout
std_err_log_path=/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/logs/Benchmarks_custom_spec2006/stderr

# Function to run gem5 with specific parameters
run_gem5() {
    local result_dir=$1
    local optimazation=$2
    local benchmark_c=$3
    local benchmark_o=$4

    $gem5_path/build/ARM/gem5.opt -d "$result_dir" $gem5_path/configs/example/se.py \
        --cpu-type=MinorCPU \
        --caches \
        --l2cache \
        $optimazation \
        -c $benchmark_c \
        -o "$benchmark_o" \
        -I $operations > $std_log_path/$(basename $result_dir)_out.log 2> $std_err_log_path/$(basename $result_dir)_err.log
}


specbzip_c="$gem5_path/spec_cpu2006/401.bzip2/src/specbzip"
specbzip_o="$gem5_path/401.bzip2/data/input.program 10"


specmcf_c="$gem5_path/spec_cpu2006/429.mcf/src/specmcf"
specmcf_o="$gem5_path/spec_cpu2006/429.mcf/data/inp.in"


spechmmer_c="$gem5_path/spec_cpu2006/456.hmmer/src/spechmmer"
spechmmer_o="--fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 $gem5_path/456.hmmer/data/bombesin.hmm"


specsjeng_c="$gem5_path/spec_cpu2006/458.sjeng/src/specsjeng"
specsjeng_o="$gem5_path/spec_cpu2006/458.sjeng/data/test.txt"


speclibm_c="$gem5_path/spec_cpu2006/470.lbm/src/speclibm"
speclibm_o="20 $gem5_path/spec_cpu2006/470.lbm/data/lbm.in 0 1 $gem5_path/spec_cpu2006/470.lbm/data/100_100_130_cf_a.of"

echo "Starting default Spec2006 Benchmark Tests"

run_gem5 "$spec_default_results/specbzip" "" "$specbzip_c" "$specbzip_o"
run_gem5 "$spec_default_results/specmcf" "" "$specmcf_c" "$specmcf_o"
run_gem5 "$spec_default_results/spechmmer" "" "$spechmmer_c" "$spechmmer_o"
run_gem5 "$spec_default_results/specsjeng" "" "$specsjeng_c" "$spechmmer_o"
run_gem5  "$spec_default_results/speclibm" "" "$speclibm_c" "$speclibm_o"


echo "Starting Spec2006 Benchmark Tests"

# 1GHz Clock Speed Tests
echo
echo "Test for 1GHz"
echo

run_gem5 "$spec_results/specbzip_1GHz" "--cpu-clock=1GHz" "$specbzip_c" "$specbzip_o"
run_gem5 "$spec_results/specmcf_1GHz" "--cpu-clock=1GHz" "$specmcf_c" "$specmcf_o"
run_gem5 "$spec_results/spechmmer_1GHz" "--cpu-clock=1GHz" "$spechmmer_c" "$spechmmer_o"
run_gem5 "$spec_results/specsjeng_1GHz" "--cpu-clock=1GHz" "$specsjeng_c" "$spechmmer_o"
run_gem5  "$spec_results/speclibm_1GHz" "--cpu-clock=1GHz" "$speclibm_c" "$speclibm_o"

#  2GHz Clock Speed Tests
echo
echo "Test for 2GHz"
echo

run_gem5 "$spec_results/specbzip_3GHz" "-cpu-clock=3GHz" "$specbzip_c" "$specbzip_o"
run_gem5 "$spec_results/specmcf_3GHz" "-cpu-clock=3GHz" "$specmcf_c" "$specmcf_o"
run_gem5 "$spec_results/spechmmer_3GHz" "-cpu-clock=3GHz" "$spechmmer_c" "$spechmmer_o"
run_gem5 "$spec_results/specsjeng_3GHz" "-cpu-clock=3GHz" "$specsjeng_c" "$spechmmer_o"
run_gem5 "$spec_results/speclibm_3GHz" "-cpu-clock=3GHz" "$speclibm_c" "$speclibm_o"

#  DDR3_2133_x64 Memory Tests
echo
echo "Test for DDR3_2133_x64"
echo

run_gem5 "$spec_results/specbzip_DDR3_2133" "--mem-type=DDR3_2133_8x8" "$specbzip_c" "$specbzip_o"
# run_gem5 "$spec_results/specmcf_DDR3_2133" "$gem5_path/429.mcf/src/specmcf" "--mem-type=DDR3_2133_8x8 -o $gem5_path/429.mcf/data/inp.in"
# run_gem5 "$spec_results/spechmmer_DDR3_2133" "$gem5_path/456.hmmer/src/spechmmer" "--mem-type=DDR3_2133_8x8 -o --fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 $gem5_path/456.hmmer/data/bombesin.hmm"
# run_gem5 "$spec_results/specsjeng_DDR3_2133" "$gem5_path/458.sjeng/src/specsjeng" "--mem-type=DDR3_2133_8x8 -o $gem5_path/458.sjeng/data/test.txt"
# run_gem5 "$spec_results/speclibm_DDR3_2133" "$gem5_path/470.lbm/src/speclibm" "--mem-type=DDR3_2133_8x8 -o 20 $gem5_path/470.lbm/data/lbm.in 0 1 $gem5_path/470.lbm/data/100_100_130_cf_a.of"

echo
echo "All tests complete!"
