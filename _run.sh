#!/bin/bash
########################################
# Tasks bootstrap
# Allows to payload a particular GPU.
# with the list of sequentional tasks.
########################################

if [ $# -lt 1 ]; then
    echo "Usage ./_run.sh -g<GPU_ID> -p <PART_INDEX> -t <TOTAL_PARTS_COUNT> -l <LABELS_COUNT> -r "
    echo "  <ROOT_DIR> -c <CV_COUNT> -b <BATCH_SIZE> -A <DO_PREDICT>"
    echo "------"
    echo "-A: do predict."
    echo "-g: index of the GPU to be utilized in experiments."
    echo "-p: part index to be used in a whole list of models as a payload"
    echo "-l: labels count to utilized"
    echo "-d: root dir that contains serialized models"
    echo "-c: cv_count"
    echo "-b: batch size"
    echo "-P: predefined state name"
    echo "-T: train epoch step"
    echo "-p: do predict"
    echo "-e: epochs count"
    echo "-C: checkpoint name"
    echo "-r: root directory of the serialized data for experiment"
    echo "-M: model tag"
    echo "-L: learning rate"
    echo "-W: warmup"
    echo "------"
    echo "NOTE: <PART_INDEX> < <TOTAL_PARTS_COUNT>"
    echo "------"
    echo "Example of how to run on card#1, part0 out of 4, in 'nohup' mode:"
    echo "nohup ./_run.sh -g 1 -p 0 -t 4 -l 3 -r <DIR> -c 3 -p True &> log_card_0.txt &"
    echo "------"
    exit
fi

########################################
# Default parameters
########################################
do_predict=True
learning_rate=2e-5
model_tag=None
batch_size=16
do_predict=True
train_epoch_step=5
warmup=0.1
checkpoint=bert_model.ckpt
# NOTE: we deal with only 'C', 'NLI', 'QA' tasks
# therefore the total amount of task is limited
# by value below.
parts_count=3 
########################################

# Reading parameters using `getops` util.
while getopts ":g:p:t:l:r:c:b:P:A:e:C:M:L:W:T:" opt; do
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
      echo "root_dir = $root_dir"
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
    P) predefined_state_name="$OPTARG"
    echo "predefined_state = $predefined_state_name"
    ;;
    A) do_predict="$OPTARG"
    echo "do_predict = $do_predict"
    ;;
    e) epochs="$OPTARG"
    echo "epochs = $epochs"
    ;;
    C) checkpoint="$OPTARG"
    echo "checkpoint = $checkpoint"
    ;;
    M) model_tag="$OPTARG"
    echo "model_tag = $model_tag"
    ;;
    L) learning_rate="$OPTARG"
    echo "learning_rate = $learning_rate"
    ;;
    W) warmup="$OPTARG"
    echo "warmup = $warmup"
    ;;
    T) train_epoch_step="$OPTARG"
    echo "train_epoch_step = $train_epoch_step"
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
# obtained from _training_tasks.sh
source _training_tasks.sh -c $parts_count -l $labels_count

# picking a certain part_index
# from the whole available modes
list="${modes_per_card[$part_index]}"

echo "Configurations to be tested:" $list

for i in $list; do

    # Split into the following args:
    # $1 -- model_folder,
    # $2 -- task_name
    model_folder=$(echo $i | cut -f1 -d,)
    task_name=$(echo $i | cut -f2 -d,)

    # The result target path is a concatenation of the root directory
    # of the particular experiment and the related local model directory
    # in it.
    target="${root_dir}${model_folder}"

    if [ -d $target ]; then
      # Starting training and evaluation process.
      echo $task_name
      ./_run_classifier.sh -g $card_index -s $target -t $task_name -c $cv_count -b $batch_size \
        -p $predefined_state_name -e $epochs -P $do_predict -T $train_epoch_step -M $model_tag -l $learning_rate \
        -W $warmup -C $checkpoint
    fi

done;

IFS=$OLDIFS
