print_elements() {
    l1i_sizes=("--l1i_size=16kB" "--l1i_size=32kB" "--l1i_size=64kB" "--l1i_size=128kB")
    l1i_assocs=("--l1i_assoc=2" "--l1i_assoc=4" "--l1i_assoc=8" "--l1i_assoc=16")

    l1d_sizes=("--l1d_size=16kB" "--l1d_size=32kB" "--l1d_size=64kB" "--l1d_size=128kB")
    l1d_assocs=("--l1d_assoc=2" "--l1d_assoc=4" "--l1d_assoc=8" "--l1d_assoc=16")

    l2_sizes=("--l2_size=512kB" "--l2_size=1024kB" "--l2_size=2048kB" "--l2_size=4096kB")
    l2_assocs=("--l2_assoc=4" "--l2_assoc=8" "--l2_assoc=16" "--l2_assoc=32" "--l2_assoc=64")

    cacheline_sizes=("--cacheline_size=16" "--cacheline_size=32" "--cacheline_size=64" "--cacheline_size=128" "--cacheline_size=256")

    local index_l1i_size=$1
    local index_l1i_assoc=$2
    local index_l1d_size=$3
    local index_l1d_assoc=$4
    local index_l2_size=$5
    local index_l2_assoc=$6
    local index_cacheline_size=$7
    local index_list=("$1" "$2" "$3" "$4" "$5" "$6" "$7")
    # Assign values to variables based on the indices
    if [ "$index_l1i_size" = "a" ]; then
        l1i_sizes=("${l1i_sizes[@]}")
        echo "${l1i_sizes[@]}"
    else
        l1i_size="${l1i_sizes[$index_l1i_size]}"
        echo $l1i_size
    fi

    if [ "$index_l1i_assoc" = "a" ]; then
        l1i_assocs=("${l1i_assocs[@]}")
        echo "${l1i_assocs[@]}"
    else
        l1i_assoc="${l1i_assocs[$index_l1i_assoc]}"
        echo $l1i_assoc
    fi

    if [ "$index_l1d_size" = "a" ]; then
        l1d_sizes=("${l1d_sizes[@]}")
        echo "${l1d_sizes[@]}"
    else    
        l1d_size="${l1d_sizes[$index_l1d_size]}"
        echo $l1d_size
    fi

    if [ "$index_l1d_assoc" = "a" ]; then
        l1d_assocs=("${l1d_assocs[@]}")
        echo "${l1d_assocs[@]}"
    else
        l1d_assoc="${l1d_assocs[$index_l1d_assoc]}"
        echo $l1d_assoc
    fi

    if [ "$index_l2_size" = "a" ]; then
        l2_sizes=("${l2_sizes[@]}")
        echo "${l2_sizes[@]}"
    else
        l2_size=("${l2_sizes[$index_l2_size]}")
        echo $l2_size
    fi

    if [ "$index_l2_assoc" = "a" ]; then
        l2_assocs=("${l2_assocs[@]}")
        echo "${l2_assocs[@]}"
    else
        l2_assoc="${l2_assocs[$index_l2_assoc]}"
        echo $l2_assoc
    fi

    if [ "$index_cacheline_size" = "a" ]; then
        cacheline_sizes=("${cacheline_sizes[@]}")
        echo "${cacheline_sizes[@]}"
    else
        cacheline_size=("${cacheline_sizes[$index_cacheline_size]}")
        echo $cacheline_size
    fi
    echo
    echo "${index_list[@]}"
 
}