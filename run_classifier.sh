#!/bin/bash
###############################################
# Setup Parameters
# The output folder depends on the DEVICE INDEX.
# Arguments
# $1 gpu index
# $2 folder
# $3 task_name
###############################################

# Reading arguments
device_index=$1
model_folder=$2
task_name=$3

echo ---
echo Running BERT task with the following parameters:
echo DEVICE: $device_index
echo DIR: $model_folder
echo TASK: $task_name


terms_per_context=250

############################################
# Considering such parameters for 8GB of RAM
############################################
batch_size=4
############################################

epochs=30.0
m_root="./pretrained/multi_cased_L-12_H-768_A-12"
do_lowercasing=False
use_custom_distance=True

src=./data/$model_folder

predict_file_name=test_results.tsv

cv_count=1
if [[ $model_folder == "cv-"* ]]; then
    cv_count=3;
    echo "Rinning in Cross-Validation Mode"
    echo "CV Count: "$cv_count
else
    echo "Running in Fixed Mode"
fi

i=0
while [ "$i" -lt $cv_count ]; do

    cv_index=$i

    echo "Current CV Index: "$cv_index

    out_dir=./bert_output-$device_index
    mkdir -p $out_dir
    rm -rf $out_dir/*

    CUDA_VISIBLE_DEVICES=$device_index python3.6 run_classifier.py \
        --use_custom_distance=$use_custom_distance \
        --task_name=$task_name \
        --cv_index=$cv_index \
        --do_predict=true --do_train=true \
        --data_dir=$src --vocab_file=$m_root/vocab.txt \
        --bert_config_file=$m_root/bert_config.json \
        --init_checkpoint=$m_root/bert_model.ckpt \
        --max_seq_length=$terms_per_context --train_batch_size=$batch_size \
        --learning_rate=2e-5 --num_train_epochs=$epochs \
        --output_dir=$out_dir \
        --do_lower_case=$do_lowercasing \
        --save_checkpoints_steps 10000

    # Copy result file
    out=./bert-model-results/$model_folder
    mkdir -p $out
    cp $out_dir/$predict_file_name $out/result-test-$cv_index.csv

    i=$(( i + 1 ))
done

