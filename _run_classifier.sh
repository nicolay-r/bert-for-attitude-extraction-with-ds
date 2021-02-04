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
epochs=30.0
batch_size=16
tokens_per_context=128
m_root="./pretrained/multi_cased_L-12_H-768_A-12"
do_lowercasing=False
use_custom_distance=False
############################################

# Reading parameters using `getops` util.
while getopts ":g:s:t:c:b:" opt; do
  case $opt in
    g) device_index="$OPTARG"
    echo "DEVICE (GPU#) = $device_index"
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
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

i=0
while [ "$i" -lt $cv_count ]; do

    cv_index=$i

    out_dir=./bert_output-$device_index
    mkdir -p $out_dir
    rm -rf $out_dir/*

    valid=1
    for data_type in "train" "test"; do
        input_template="sample-"$data_type"-"$cv_index".tsv.gz"
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

    echo "Current CV Index: "$cv_index

    # We provide all the results withing the same source folder
    # in order to later apply evaluation towards the obtained results.
    CUDA_VISIBLE_DEVICES=$device_index python3.6 run_classifier.py \
        --use_custom_distance=$use_custom_distance \
        --task_name=$task_name \
        --cv_index=$cv_index \
        --do_predict=true \
        --do_eval=true \
        --do_train=true \
        --data_dir=$src --vocab_file=$m_root/vocab.txt \
        --bert_config_file=$m_root/bert_config.json \
        --init_checkpoint=$m_root/bert_model.ckpt \
        --max_seq_length=$tokens_per_context --train_batch_size=$batch_size \
        --learning_rate=2e-5 \
        --warmup_proportion=0.1 \
        --num_train_epochs=$epochs \
        --output_dir=$src \
        --do_lower_case=$do_lowercasing \
        --save_checkpoints_steps 10000

    # Create output folder
    result_out=./bert-model-results/$model_folder
    mkdir -p $result_out

    i=$(( i + 1 ))

    echo "Model train and evaluation at cv_index="$i" completed!"
done

