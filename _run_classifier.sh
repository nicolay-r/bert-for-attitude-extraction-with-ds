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
total_epochs=250
tokens_per_context=128
do_lowercasing=False
use_custom_distance=False
############################################

# Reading parameters using `getops` util.
while getopts ":g:e:s:t:c:b:P:T:M:l:W:C:p:" opt; do
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
    P) do_predict="$OPTARG"
    echo "do_predict = $do_predict"
    ;;
    T) train_epochs_step="$OPTARG"
    echo "train_epochs_step = $train_epochs_step"
    ;;
    M) model_tag="$OPTARG"
    echo "model_tag = $model_tag"
    ;;
    l) learning_rate="$OPTARG"
    echo "learning_rate = $learning_rate"
    ;;
    W) warmup_proportion="$OPTARG"
    echo "warmup_proportion = $warmup_proportion"
    ;;
    C) checkpoint_filename="$OPTARG"
    echo "checkpoint_filename = $checkpoint_filename"
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

train_stages=$((total_epochs / train_epochs_step))
echo "Train stages: "$train_stages

it_index=0
# For every index, related to cv_count, do:
while [ "$it_index" -lt $cv_count ]; do

    # Clearing output directories.
    out_dir=./bert_output-$device_index
    mkdir -p $out_dir
    rm -rf $out_dir/*


    valid=1
    for data_type in "train"; do
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

      # We provide initial warmup proportion only in case
      # when we do the first k epochs.
      if [[ "$train_stage" -ne "0" ]]; then
           warmup_proportion=0
      fi

      echo "WARMUP_PROPORTION: "$warmup_proportion 

      # We provide all the results within the same source folder
      # in order to later apply evaluation towards the obtained results.
      CUDA_VISIBLE_DEVICES=$device_index python run_classifier.py \
          --use_custom_distance=$use_custom_distance \
          --task_name=$task_name \
          --cv_index=$it_index \
          --stage_index=$epoch_to_stop \
          --predefined_state_name=$predefined_state_name \
          --do_predict=$do_predict \
          --do_eval=true \
          --model_tag=$model_tag \
          --do_train=true \
          --data_dir=$src \
	        --learning_rate=$learning_rate \
          --vocab_file=$m_root/vocab.txt \
          --bert_config_file=$m_root/bert_config.json \
          --init_checkpoint=$m_root/$checkpoint_filename \
          --max_seq_length=$tokens_per_context \
          --train_batch_size=$batch_size \
          --num_train_epochs=$epoch_to_stop \
          --output_dir=$out_dir \
          --results_dir=$src \
          --eval_bound=0.991 \
          --do_lower_case=$do_lowercasing \
          --save_checkpoints_steps 10000 \
          --warmup_proportion=$warmup_proportion

      # Moving to the next training stage.
      train_stage=$(( train_stage + 1 ))

    done;

    # Moving to the next training iteration.
    it_index=$(( it_index + 1 ))

    echo "Model train and evaluation at it_index="$it_index" completed!"
done

