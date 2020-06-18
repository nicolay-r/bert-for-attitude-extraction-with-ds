#!/bin/bash

########################################
# Task runner
# ./_run.sh <CARD_INDEX>|all
########################################

if [ $# -ne 1 ]; then
    echo "No arguments supplied"
    exit
fi

source _models.sh

list="-"
card_index=$1
if [[ $1 == 0 ]] ; then
    list=$s1
elif [[ $1 == 1 ]] ; then
    list=$s2
elif [[ $1 == 2 ]] ; then
    list=$s3
elif [[ $1 == 3 ]] ; then
    list=$s4
elif [[ $1 == all ]] ; then
    list=$models_list
    card_index=0
fi

echo "Configurations to be tested:" $s1

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
