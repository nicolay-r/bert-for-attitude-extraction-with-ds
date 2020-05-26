#!/bin/bash
###############################################
# Setup Parameters
# The output folder depends on the DEVICE INDEX.
###############################################

DEVICE_INDEX=0
terms_per_context=50
batch_size=4
epochs=30.0
m_root="./pretrained/multi_cased_L-12_H-768_A-12"
do_lowercasing=True

OLDIFS=$IFS
IFS=','

for i in bert-c_m,sae-3sm \
         bert-nli_b,sae-pb \
         bert-qa_b,sae-pb \
         bert-qa_m,sae-3pm \
         ds-bert-c_m,sae-3sm \
         ds-bert-nli_b,sae-pb \
         ds-bert-qa_b,sae-pb \
         ds-bert-qa_m,sae-3pm;
do
    # Split into $1 -- folder, $2 -- task_name
    set -- $i;

    src=./data/$1

    predict_file_name=test_results.tsv

    cv_index=0
    out_dir=./bert_output-$DEVICE_INDEX
    rm -rf $out_dir

    CUDA_VISIBLE_DEVICES=$DEVICE_INDEX python3.6 run_classifier.py \
        --task_name=$2 \
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
    cp $out_dir/$predict_file_name $src/result-test-$cv_index.csv

done;

IFS=$OLDIFS
