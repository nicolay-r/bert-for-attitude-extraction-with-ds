#!/bin/bash

########################################
# Task runner
# ./_run.sh <CARD_INDEX>|all
########################################

if [ $# -lt 1 ]; then
    echo "Usage ./_run.sh <CARD_ID> all|test|[<PART_INDEX> <PARTS_COUNT>]"
    echo "IMPORTANT: <CARD_ID> <= <CARDS_COUNT>"
    echo "Example of how to run on card#1, part0 out of 4, in 'nohup' mode:"
    echo "nohup ./_run.sh 1 0 4 &> log_card_0.txt &"
    exit
fi

card_index=$1

if [ $# -lt 2 ]; then
    parts_count=1
else
    part_index=$2
    parts_count=$3
fi

source _models.sh $parts_count

list="-"

if [[ $part_index == all ]] ; then
    list="${modes_per_card[0]}"
    part_index=0
elif [[ $part_index == test ]] ; then
    list="${modes_per_card[0]}"
    part_index=0
else
    list="${modes_per_card[$part_index]}"
fi

echo "Configurations to be tested:" $list

for i in $list; do

    OLDIFS=$IFS
    IFS=','

    # Split into
    # $1 -- folder,
    # $2 -- task_name
    set -- $i;

    folder=$1
    task_name=$2

    src=./data/$1

    ./run_classifier.sh $card_index $folder $task_name

done;

IFS=$OLDIFS
