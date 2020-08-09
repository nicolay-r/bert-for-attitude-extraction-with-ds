#!/bin/bash

########################################
# Task runner
# ./_run.sh <CARD_INDEX>|all
########################################

if [ $# -lt 1 ]; then
    echo "Usage ./_run.sh <CARD_ID>|all|test <CARDS_COUNT>"
    echo "IMPORTANT: <CARD_ID> <= <CARDS_COUNT>"
    echo "Example of how to run in 'nohup' mode:"
    echo "nohup ./_run.sh 0 4 &> log_card_0.txt &"
    exit
fi

card_index=$1

if [ $# -lt 2 ]; then
    cards_count=1
else
    cards_count=$2
fi

source _models.sh $cards_count

list="-"

if [[ $card_index == all ]] ; then
    list="${modes_per_card[0]}"
    card_index=0
elif [[ $card_index == test ]] ; then
    list="${modes_per_card[0]}"
    card_index=0
else
    list="${modes_per_card[$card_index]}"
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
