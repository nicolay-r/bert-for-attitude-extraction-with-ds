# Input length analysis

* Considering TRAIN/TEST fixed separation.
* Analyzing `text_a` + `text_b` lengths
* Calculating for:
    * TRAIN;
    * TEST;
    * TOTAL (Average)
* Text + Question/Answering format (see log below): 
    * Terms: ~39.7
    * Tokens: ~70
    
Terms:
```
    FOR TERMS:
    -----------------------------
    Filename: ../data/ds-bert-qa_b-3l/sample-train-0.tsv.gz
    Data type: train
    Samples taken: 75709
    TextTypes.TextA (items per sample): 21.08
    Data type: train
    Samples taken: 75709
    TextTypes.TextB (items per sample): 17.7
    -----------------------------
    Filename: ../data/ds-bert-qa_b-3l/sample-test-0.tsv.gz
    Data type: test
    Samples taken: 8466
    TextTypes.TextA (items per sample): 30.65
    Data type: test
    Samples taken: 8466
    TextTypes.TextB (items per sample): 17.75
    -----------------------------
    TOTAL:
    Samples taken: 84175
    Items per sample: 39.74
```
Tokens:
```
    FOR TOKENS:
    -----------------------------
    Filename: ../data/ds-bert-qa_b-3l/sample-train-0.tsv.gz
    Data type: train
    Samples taken: 75709
    TextTypes.TextA (items per sample): 35.61
    Data type: train
    Samples taken: 75709
    TextTypes.TextB (items per sample): 33.48
    -----------------------------
    Filename: ../data/ds-bert-qa_b-3l/sample-test-0.tsv.gz
    Data type: test
    Samples taken: 8466
    TextTypes.TextA (items per sample): 48.65
    Data type: test
    Samples taken: 8466
    TextTypes.TextB (items per sample): 31.89
    -----------------------------
    TOTAL:
    Samples taken: 84175
    Items per sample: 70.23
```
