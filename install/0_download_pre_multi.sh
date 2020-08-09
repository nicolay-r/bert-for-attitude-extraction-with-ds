#!/bin/bash

subdir="../pretrained"
mkdir -p $subdir

# BERT-Base Multilingual model
bert_base=multi_cased_L-12_H-768_A-12.zip
wget https://storage.googleapis.com/bert_models/2018_11_23/$bert_base -O ./$subdir/$bert_base
cd ./$subdir/ && unzip $bert_base -d .

