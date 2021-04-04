# BERT for Sentiment Attitude Extraction in Russian with Pretraining on Distantly Supervised Data

This repository contains the code for ...

We apply BERT for Sentiment Attitude Extraction task by experimenting within RuSentRel-v1.2 dataset.

Code depends on Google-BERT implementation [[original readme]](README-BERT.md).

**Main Contribution**: It provides a custom input formatters [[code-reference]](https://github.com/nicolay-r/bert-for-attitude-extraction-with-ds/blob/abert-release/sae/processors.py)

## Installation

> To be updated.

## Download Pretrained States

Using the related bash scripts from the `pretrained` dir.

List of utilized pretrained states:
* BERT-mult-base;
* RuBERT;
* SentenceRuBERT;

## Prepare the data

### For supervised learning and Fine-Tunning

Download or Serialize Manually

#### Download

Supervised-Learning and Fine-Tunning:
```sh
# Download prepared for BERT data of RuSentRel-1.2
curl -L https://www.dropbox.com/s/bchz4bmvr5f6cod/rsr-1.2-ra-all.tar.gz?dl=1
tar -xvf rsr-1.2-ra-all.tar.gz
```
Pretraining:
```sh
# It includes the prepared for BERT samples of RuAttitudes 
# (1.0, 2.0-base, 2.0-large, 2.0-base-neut, 2.0-large-neut).
TODO.
```

#### Manually

Proceed with the following [repo](https://github.com/nicolay-r/language-model-utils-for-attitude-extraction)


It provides input formatting in following formats [[refered-paper]]():
* `C` -- classic, i.e. `text_a` only;
* `NLI` -- `text_a` + `text_b` with the mentioned attitude description in `text_a`;
* `QA` -- as NLI, but `text_b` represents a question.

## Training

Use `_run.sh` for training which allows to queue multiple 
[training tasks](https://github.com/nicolay-r/bert-for-attitude-extraction-with-ds/blob/abert-release/_training_tasks.sh)
(in list) for a selected GPU's.
However we use this functionality in order to pick only a particular task from the whole list 
[[code-reference]](https://github.com/nicolay-r/bert-for-attitude-extraction-with-ds/blob/fd1331d8caad63681cacc713678f7fc429f8c180/_run.sh#L126).
It could be modified for efficiency purposes.
This script represents a wrapper over `_run_classifier.sh`, which solves the task of data-folding formats and  

Parameter `-p` corresponds to a particular index of the available tasks: [`C`, `NLI`, `QA`].

Brief list of a main 
[[flags]](https://github.com/nicolay-r/bert-for-attitude-extraction-with-ds/blob/abert-release/_run.sh): 
```
-g: GPUs to be utilized in experiments.
-A: do predict
-p: task type: 0 ('c'), 1 ('nli'), 2 ('qa')
-l: labels count (2 or 3)
-c: cv_count (1 -- fixed Train/Test separation, or k -- k-fold CV)
-b: batch size
-P: pretrained state name
-T: epochs count before evaluation
-e: total epochs count
-W: warmup proportion
```

### Supervised Learning Example

```sh
./_run.sh 
  -g 2 \
  -p 0 \
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

### Pre-training Tutorial

**Step 1.** Launch pretraining (without evaluation):
```
./_run.sh -g 0,1 \
   -p 0 \
   -l 3 \
   -r output/ra-v1_2-balanced-tpc50_3l/ \
   -c 1 \
   -b 32 \
   -P multi_cased_L-12_H-768_A-12 \
   -e 5 \
   -A False
```
The target folder with the updated state is `bert-output-0,1`.

**Step 2**. Copy the output folder into the `new-pretrained-state` of the `pretrained` dir as follows:
```sh
cp bert-output-0,1 ./pretrained/NEW-PRETRAINED-STATE
```

**Step 3**. Copy the `vocab.txt` and `bert_config.json` from the original model (`multi_cased_L-12_H-768_A-12` in the related scenario).
```
cd ./pretrained/NEW-PRETRAINED-STATE
cp ../multi_cased_L-12_H-768_A-12/vocab.txt .
cp ../multi_cased_L-12_H-768_A-12/bert_config.json .
``` 
This is a dirty hack which allows us to avoid modification of the related parameters while running `run_classifier.py`.

**Result:** it allows us then to write as follows:
```
  ./_run.sh 
    ...
    -P NEW-PRETRAINED-STATE
    ...
```

### Fine-tunning Tutorial
**Step 1.** Obtain the last checkpoint from the `NEW-PRETRAINED-STATE`, which is a result of the pretraining stage [[section]](#pre-training-tutorial).
Considering the latter as `model.ckpt-75596`.

**Step 2.** Launch fine-tunning process:
```
./_run.sh -g 0 \
	-p 2 \
	-l 3 \
	-r output/rsr-v1_1-fixed-balanced-tpc50_3l/ \
	-c 1 \
	-b 16 \
	-P NEW-PRETRAINED-STATE \
	-e 50 \
	-M ft \
	-W 0.1 \
	-C model.ckpt-75596 \
	-T 5
```
> NOTE: We provide tag by `-M` which allows us to separate the evaluation output from the orginal directory.

**Result**: The evaluated results will be at: `rsr-v1_1-fixed-balanced-tpc50_3l-ft`

## RuSentRel related result Evaluation 

Result Evaluation is out of scope of this repository.

Proceed with [[this]](https://github.com/nicolay-r/language-model-utils-for-attitude-extraction) repository.

## References:

> To be updated.
