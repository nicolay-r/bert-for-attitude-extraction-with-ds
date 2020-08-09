#!/bin/bash

subdir="../pretrained"
mkdir -p $subdir

# RuBert (IPavlov)
rubert_base=rubert_cased_L-12_H-768_A-12.tar.gz
wget http://files.deeppavlov.ai/deeppavlov_data/bert/$rubert_base -O ./$subdir/$rubert_base
cd ./$subdir/ && tar -xvf $rubert_base
