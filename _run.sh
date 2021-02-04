#!/bin/bash
########################################
# Tasks bootstrap
# Allows to payload a particular GPU.
# with the list of sequentional tasks.
########################################

if [ $# -lt 1 ]; then
    echo "Usage ./_run.sh -g<GPU_ID> -p <PART_INDEX> -t <TOTAL_PARTS_COUNT> -l <LABELS_COUNT> -r "
    echo "  <ROOT_DIR> -c <CV_COUNT> -b <BATCH_SIZE>"
    echo "------"
    echo "-g: index of the GPU to be utilized in experiments."
    echo "-p: part index to be used in a whole list of models as a payload"
    echo "-l: labels count to utilized"
    echo "-d: root dir that contains serialized models"
    echo "-c: cv_count"
    echo "-b: batch size"
    echo "------"
    echo "NOTE: <PART_INDEX> < <TOTAL_PARTS_COUNT>"
    echo "------"
    echo "Example of how to run on card#1, part0 out of 4, in 'nohup' mode:"
    echo "nohup ./_run.sh -g 1 -p 0 -t 4 -l 3 -r <DIR> -c 3 &> log_card_0.txt &"
    echo "------"
    exit
fi

# Reading parameters using `getops` util.
while getopts ":g:p:t:l:r:c:b:" opt; do
  case $opt in
    g) card_index="$OPTARG"
      echo "GPU# utilized = $card_index"
      ;;
    p) part_index="$OPTARG"
      echo "part_index = $part_index"
      ;;
    t) parts_count="$OPTARG"
      echo "parts_count = $parts_count"
      ;;
    l) labels_count="$OPTARG"
      if [ $labels_count -eq 2 -o $labels_count -eq 3 ]
      then
          echo "Labels is $labels_count."
      else
          echo "Labels needs to be either 2 or 3, $labels_count found instead."
          exit 1
      fi
      ;;
    r) root_dir="$OPTARG"
      echo "root_dir = $labels_count"
      ;;
    c) cv_count="$OPTARG"
      if [ $cv_count -eq 1 -o $cv_count -eq 3 ]
      then
          echo "cv_count is $cv_count."
      else
          echo "cv_count to be either 1 or 3, $cv_count found instead."
          exit 1
      fi
      ;;
    b) batch_size="$OPTARG"
      echo "batch_size = $batch_size"
      ;;
    \?) echo "Invalid option -$OPTARG" >&2
      ;;
  esac
done

# Additional checks.
if ! (( $part_index < $parts_count )) ; then
  echo "part_index ($part_index) greater or equal than parts count ($parts_count)"
  exit 1
fi

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

    # Split into the following args:
    # $1 -- model_folder,
    # $2 -- task_name
    set -- $i;

    # local model_folder.
    model_folder=$1
    task_name=$2

    # The result target path is a concatenation of the root directory
    # of the particular experiment and the related locat model derectory
    # in it.
    target="${root_dir}${model_folder}"

    if [ -d $target ]; then
      # Starting training and evaluation process.
      echo $task_name
      ./_run_classifier.sh -g $card_index -s $target -t $task_name -c $cv_count -b $batch_size
    fi

done;

IFS=$OLDIFS
