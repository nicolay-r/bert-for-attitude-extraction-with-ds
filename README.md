# BERT for Sentiment Attitude Extraction in Russian with Distant Supervision approach for pretraining

This repository contains the code for ...

We apply BERT for Sentiment Attitude Extraction task by experimenting within RuSentRel-v1.2 dataset.

Code depends on Google-BERT implementation [[original readme]](README-BERT.md).

## Installation

> To be updated.

## Download Pretrained States

Using the related bash scripts from the `pretrained` dir.

List of utilized pretrained states:
* BERT-mult-base;
* RuBERT;
* SentenceRuBERT;

## Prepare the data

> To be updated.

## Training

Use `_run.sh` for training which allows to queue multiple training tasks (in list) for a selected GPU's.
However we use this functionality in order to pick only a particular task from the whole list 
[[code-reference]](https://github.com/nicolay-r/bert-for-attitude-extraction-with-ds/blob/fd1331d8caad63681cacc713678f7fc429f8c180/_run.sh#L126).
It could be modified for efficiency purposes.
This script represents a wrapper over `_run_classifier.sh`, which solves the task of data-folding formats and  

Parameter `-p` corresponds to a particular **p**art of the total (`-t`) amount of tasks.
We consider `-t 3`.

### Supervised Learning

```sh
./_run.sh 
  -g 2 \
  -p 0 -t 3 \
  -l 3 \
  -r output/rsr-v1_1-fixed-balanced-tpc50_3l/ \
  -c 1 \
  -b 16 \
  -P multi_cased_L-12_H-768_A-12 \ 
  -e 50 \
  -T 5 \
  -A True \
  -W 0.1
```

### Pre-training

```
./_run.sh -g 0,1 \
   -p 1 -t 3 \
   -l 3 \
   -r output/ra-v1_2-balanced-tpc50_3l/ \
   -c 1 \
   -b 32 \
   -P multi_cased_L-12_H-768_A-12 \
   -e 5 \
   -A False \
   -T 1
```

Next, we 

### List of parameters.
```
    echo "Usage ./_run.sh -g<GPU_ID> -p <PART_INDEX> -t <TOTAL_PARTS_COUNT> -l <LABELS_COUNT> -r <ROOT_DIR> -c <CV_COUNT> -b <BATCH_SIZE>"
    echo "-A: do predict"
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
    echo "-M: model tag"
    echo "-L: learning rate"
    echo "-W: warmup"
```

## Evaluation

> Using AREkit library.

## References:

> To be updated.
