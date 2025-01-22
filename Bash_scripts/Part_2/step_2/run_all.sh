instr=100000000

# ./specbzip_opt.sh "$instr"
# ./spechmmer_opt.sh "$instr"
# ./speclibm_opt.sh "$instr"
# ./specmcf_opt.sh "$instr"
# ./specsjeng_opt.sh "$instr"
version=0

specs=("specbzip" "spechmmer" "speclibm" "specmcf" "specsjeng")
path_to_file=/home/arch/Desktop/git/gem5_1/Architecture_Assignment_Gem5/Bash_scripts/Bechmarks_custom_opt

default=("1" "0" "2" "0" "2" "1" "2")

for spec in "${specs[@]}"; do
    # "$path_to_file/all_in_one.sh" $instr $version $spec 1 0 a 0 3 1 3
    # "$path_to_file/all_in_one.sh" $instr $version $spec 1 0 3 a 3 1 3
    # "$path_to_file/all_in_one.sh" $instr $version $spec 1 0 3 0 a 0 3
    # "$path_to_file/all_in_one.sh" $instr $version $spec 1 0 3 0 3 a 3
    # "$path_to_file/all_in_one.sh" $instr $version $spec 1 0 3 0 3 0 a

    "./all_in_one.sh" $instr $version $spec a 0 2 0 2 1 2
    "./all_in_one.sh" $instr $version $spec 1 a 2 0 2 1 2
    "./all_in_one.sh" $instr $version $spec 1 0 a 0 2 1 2
    "./all_in_one.sh" $instr $version $spec 1 0 2 a 2 1 2
    "./all_in_one.sh" $instr $version $spec 1 0 2 0 a 1 2
    "./all_in_one.sh" $instr $version $spec 1 0 2 0 2 a 2
    "./all_in_one.sh" $instr $version $spec 1 0 2 0 2 1 a
done