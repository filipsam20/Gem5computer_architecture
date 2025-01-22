#!/usr/bin/bash
echo "Compile the program"

user=$(whoami)

# fib_prog="/home/$user/Desktop/git/c_programms/src/fibonacci.c"
# fib_out="/home/$user/Desktop/git/c_programms/out/fibonacci"
# DIR="/home/$USERNAME/Desktop/git/Part_1/fib_stats"

fib_prog="/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/c_programms/src/fibonacci.c"
fib_out="/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5/c_programms/out"
fib_o=fibonnacci
DIR="/home/$user/Desktop/git/gem5_1/Architecture_Assignment_Gem5"
gem5_path="/home/$user/Desktop/gem5"
mkdir -p $fib_out
arm-linux-gnueabihf-gcc --static "$fib_prog" -o "$fib_out/$fib_o"

USERNAME=$(whoami)


# mkdir -p "$DIR/MinorCpu"
# mkdir -p "$DIR/TimingCpu"
# mkdir -p "$DIR/TimingCpu_2GHz"
# mkdir -p "$DIR/MinorCpu_2GHz"
# mkdir -p "$DIR/TimingCpu_DDR4"
# mkdir -p "$DIR/MinorCpu_DDR4"

# Function to pause and add spacing
wait_for_seconds() {
    for i in $(seq 1 $1)
    do
        echo
		echo "Waiting... ($i)" >&2
    done
}

echo "Start fibonacci ....."
wait_for_seconds 10

$gem5_path/build/ARM/gem5.opt -d "$DIR/fib_stats/TimingCpu" $gem5_path/configs/example/se.py --cpu-type=TimingSimpleCPU --caches -c "$fib_out/$fib_o"

wait_for_seconds 5
echo "End of TimingSimpleCpu"
wait_for_seconds 5

echo "Start of MinorCPU"
wait_for_seconds 5

$gem5_path/build/ARM/gem5.opt -d "$DIR/fib_stats/MinorCpu" $gem5_path/configs/example/se.py --cpu-type=MinorCPU --caches -c "$fib_out/$fib_o"

wait_for_seconds 5
echo "End of MinorCPU"
wait_for_seconds 5

echo "Start for 2GHz TimingCPU"
wait_for_seconds 5

$gem5_path/build/ARM/gem5.opt -d "$DIR/fib_stats/TimingCpu_2GHz" $gem5_path/configs/example/se.py --cpu-type=TimingSimpleCPU --caches --cpu-clock=2GHz -c "$fib_out/$fib_o"

wait_for_seconds 5
echo "End of 2GHz TimingCPU"
wait_for_seconds 5

echo "Start for 2GHz MinorCPU"
wait_for_seconds 5

$gem5_path/build/ARM/gem5.opt -d "$DIR/fib_stats/MinorCpu_2GHz" $gem5_path/configs/example/se.py --cpu-type=MinorCPU --caches --cpu-clock=2GHz -c "$fib_out/$fib_o"

wait_for_seconds 5
echo "End of 2GHz MinorCPU"
wait_for_seconds 5

echo "Start for DDR4 TimingCPU"
wait_for_seconds 5

$gem5_path/build/ARM/gem5.opt -d "$DIR/fib_stats/TimingCpu_DDR4" $gem5_path/configs/example/se.py --cpu-type=TimingSimpleCPU --caches --mem-type=DDR4_2400_8x8 -c "$fib_out/$fib_o"

wait_for_seconds 5
echo "End of DDR4 TimingCPU"
wait_for_seconds 5

echo "Start for DDR4 MinorCPU"
wait_for_seconds 5

$gem5_path/build/ARM/gem5.opt -d "$DIR/fib_stats/MinorCpu_DDR4" $gem5_path/configs/example/se.py --cpu-type=MinorCPU --caches --mem-type=DDR4_2400_8x8 -c "$fib_out/$fib_o"

wait_for_seconds 5
echo "End of DDR4 MinorCPU"
