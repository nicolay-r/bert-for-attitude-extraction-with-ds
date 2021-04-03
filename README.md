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

```sh
# TODO. Provide downloading script.
```

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

Step 1. Run the pretraining
```
./_run.sh -g 0,1 \
   -p 0 -t 3 \
   -l 3 \
   -r output/ra-v1_2-balanced-tpc50_3l/ \
   -c 1 \
   -b 32 \
   -P multi_cased_L-12_H-768_A-12 \
   -e 5 \
   -A False
```
The target folder with the updated state is `bert-output-0,1`.

**Step 2**. Copy the output folder into the `<TARGET-DIR>` of the `pretrained` dir as follows:
```sh
cp bert-output-0,1 ./pretrained/new-pretrained-state
```

**Step 3**. Copy the `vocab.txt` and `bert_config.json` from the original model (`multi_cased_L-12_H-768_A-12` in the related scenario).
```
cd ./pretrained/new-pretrained-state
cp ../multi_cased_L-12_H-768_A-12/vocab.txt .
cp ../multi_cased_L-12_H-768_A-12/bert_config.json .
``` 
This is a dirty hack which allows us to avoid modification of the related parameters while running `run_classifier.py`.

**Result:** it allows us then to write as follows:
```
  ./_run.sh 
    ...
    -P new-pretrained-state
    ...
```

### List of parameters

```
Usage ./_run.sh -g<GPU_ID> -p <PART_INDEX> -t <TOTAL_PARTS_COUNT> -l <LABELS_COUNT> -r <ROOT_DIR> -c <CV_COUNT> -b <BATCH_SIZE>"
    -A: do predict
    -g: index of the GPU to be utilized in experiments.
    -p: part index to be used in a whole list of models as a payload
    -l: labels count to utilized
    -d: root dir that contains serialized models
    -c: cv_count
    -b: batch size
    -P: predefined state name
    -T: train epoch step
    -p: do predict
    -e: epochs count
    -C: checkpoint name
    -M: model tag
    -L: learning rate
    -W: warmup
```

## Evaluation

> Using AREkit library.

## References:

> To be updated.
