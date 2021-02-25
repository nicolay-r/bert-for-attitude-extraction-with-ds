#!/bin/bash
###############################################
# Setup Parameters
# The output folder depends on the DEVICE INDEX.
###############################################

echo "---"
echo "Running BERT task with the following parameters:"

############################################
# Considering such parameters for 8GB of RAM
############################################
train_epochs_step=5
total_epochs=250
train_stages=$((total_epochs / train_epochs_step))
batch_size=16
tokens_per_context=128
do_lowercasing=False
use_custom_distance=False
############################################

# Reading parameters using `getops` util.
while getopts ":g:e:s:t:c:b:p:" opt; do
  case $opt in
    g) device_index="$OPTARG"
    echo "DEVICE (GPU#) = $device_index"
    ;;
    e) total_epochs="$OPTARG"
    echo "EPOCHS = $total_epochs"
    ;;
    s) src="$OPTARG"
    echo "DIR (model_folder) = $src"
    ;;
    t) task_name="$OPTARG"
    echo "TASK (task_name) = $task_name"
    ;;
    c) cv_count="$OPTARG"
    echo "CV_COUNT (cv_count) = $cv_count"
    ;;
    b) batch_size="$OPTARG"
    echo "batch_size = $batch_size"
    ;;
    p) predefined_state_name="$OPTARG"
    echo "predefined_state = $predefined_state_name"
    # Composing a path to the directory with the
    # precomputed stage.
    m_root="./pretrained/"${predefined_state_name}
    if ! [[ -d $m_root ]]; then
      echo "Precomputed state not found: ${m_root}"
      exit 1
    fi
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

it_index=0
# For every index, related to cv_count, do:
while [ "$it_index" -lt $cv_count ]; do

    # Clearing output directories.
    out_dir=./bert_output-$device_index
    mkdir -p $out_dir
    rm -rf $out_dir/*

    valid=1
    for data_type in "train" "test"; do
        input_template="sample-"$data_type"-"$it_index".tsv.gz"
        input_file=$src/$input_template

        if [ ! -f $input_file ]; then
            valid=0
            echo $input_file "[Missed]"
        else
            echo $input_file "[OK]"
        fi
    done

    echo "Valid: "$valid
    if [ ! $valid -eq 1 ]; then
        break
    fi

    echo "Current Iteration Index: "$it_index

    train_stage=0
    while [ "$train_stage" -le $train_stages ]; do

      # Calculating total amount of epochs from the very
      # beginning till the next stop for evaluation process.
      epoch_to_stop=$((train_stage * train_epochs_step))

      # We provide all the results within the same source folder
      # in order to later apply evaluation towards the obtained results.
      CUDA_VISIBLE_DEVICES=$device_index python run_classifier.py \
          --use_custom_distance=$use_custom_distance \
          --task_name=$task_name \
          --cv_index=$it_index \
          --stage_index=$epoch_to_stop \
          --predefined_state_name=$predefined_state_name \
          --do_predict=true \
          --do_eval=true \
          --do_train=true \
          --data_dir=$src \
	  --learning_rate=0.1 \
          --vocab_file=$m_root/vocab.txt \
          --bert_config_file=$m_root/bert_config.json \
          --init_checkpoint=$m_root/bert_model.ckpt \
          --max_seq_length=$tokens_per_context \
          --train_batch_size=$batch_size \
          --learning_rate=2e-5 \
          --warmup_proportion=0.1 \
          --num_train_epochs=$epoch_to_stop \
          --output_dir=$out_dir \
          --results_dir=$src \
          --do_lower_case=$do_lowercasing \
          --save_checkpoints_steps 10000

      # Moving to the next training stage.
      train_stage=$(( train_stage + 1 ))

    done;

    # Moving to the next training iteration.
    it_index=$(( it_index + 1 ))

    echo "Model train and evaluation at it_index="$it_index" completed!"
done

