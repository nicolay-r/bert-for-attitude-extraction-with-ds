#!/bin/bash
terms_per_context=50
data_root="../relations-bert/data/rusentrel/bert-ds/"
model_root="./pretrained/multi_cased_L-12_H-768_A-12"

CUDA_VISIBLE_DEVICES=0 python3.6 run_classifier.py --task_name=cola --do_train=true --do_eval=true --data_dir=$data_root --vocab_file=$model_root/vocab.txt --bert_config_file=$model_root/bert_config.json --init_checkpoint=$model_root/bert_model.ckpt --max_seq_length=$terms_per_context --train_batch_size=2 --learning_rate=2e-5 --num_train_epochs=3.0 --output_dir=./bert_output/ --do_lower_case=False --save_checkpoints_steps 10000
