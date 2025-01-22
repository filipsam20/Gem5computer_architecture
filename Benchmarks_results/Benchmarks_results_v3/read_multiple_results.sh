#!/bin/bash

############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Runs the script read_results for all the config.ini files found in the directory specified"
   echo
   echo "Syntax: ./read_multiple_results.sh path/to/config.ini/directory"
}

############################################################
############################################################


# If the number of arguments is not correct exit with help message
if [[ "$#" -ne 1 ]]; then
    echo "Illegal number of parameters"
    Help
    exit -1
fi

path=$1

# for every config.ini in the specified directory run the read_results script
for i in $(find $1 -name "*.ini")
do  
    "./read_results.sh" $i
done