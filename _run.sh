#!/bin/bash
########################################
# Tasks bootstrap
# Allows to payload a particular GPU.
# with the list of sequentional tasks.
########################################

if [ $# -lt 1 ]; then
    echo "Usage ./_run.sh -c <GPU_ID> -p <PART_INDEX> -t <TOTAL_PARTS_COUNT> -l <LABELS_COUNT>"
    echo "------"
    echo "-c: index of the GPU to be utilized in experiments."
    echo "-p: part index to be used in a whole list of models as a payload"
    echo "-l: labels count to utilized"
    echo "------"
    echo "NOTE: <PART_INDEX> < <TOTAL_PARTS_COUNT>"
    echo "------"
    echo "Example of how to run on card#1, part0 out of 4, in 'nohup' mode:"
    echo "nohup ./_run.sh 1 0 4 &> log_card_0.txt &"
    echo "------"
    exit
fi

# Reading parameters using `getops` util.
while getopts ":c:p:t:l:" opt; do
  case $opt in
    c) card_index="$OPTARG"
    echo "GPU# utilized = $card_index"
    ;;
    p) part_index="$OPTARG"
    echo "part_index = $part_index"
    ;;
    t) parts_count="$OPTARG"
    echo "parts_count = $parts_count"
    ;;
    l) labels_count="$OPTARG"
    echo "labels_count = $labels_count"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# Obtaining list of <PARTS>
# which will be stored in modes_per_card variable
# obtained from _models.sh
source _models.sh -c $parts_count -l $labels_count

# picking a certain part_index
# from the whole available modes
list="${modes_per_card[$part_index]}"

echo "Configurations to be tested:" $list

for i in $list; do

    OLDIFS=$IFS
    IFS=','

    # Split into the follwing args:
    # $1 -- folder,
    # $2 -- task_name
    set -- $i;

    folder=$1
    task_name=$2

    src=./data/$1

    # ./run_classifier.sh $card_index $folder $task_name
    echo ./run_classifier.sh $card_index $folder $task_name

done;

IFS=$OLDIFS
