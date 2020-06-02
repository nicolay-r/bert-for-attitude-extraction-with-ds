#!/bin/bash

########################################
# Run all the task on a single Videocard
########################################


source _models.sh

for i in $s4; do

    OLDIFS=$IFS
    IFS=','

    # Split into
    # $1 -- folder,
    # $2 -- task_name
    set -- $i;

    folder=$1
    task_name=$2

    src=./data/$1

    ./run_classifier.sh 3 $folder $task_name

done;

IFS=$OLDIFS
