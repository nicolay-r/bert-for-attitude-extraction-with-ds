# Input length analysis

* Considering TRAIN/TEST fixed separation.
* Measuring for 3-scale.
* Analyzing `text_a` + `text_b` lengths
* Calculating for:
    * TRAIN;
    * TEST;
    * TOTAL (Average)

Results:
* Text_A only:
    * Terms: 22.04 
    * Tokens: 36.92
* Text_B (QA_B):
    * Terms: 17.7
    * Tokens: 33.32
* Text_B (NLI_B):
    * Terms: 15.7
    * Tokens: 29.32

Therefore, a combinations (largest):
* Text + Text_B (QA):
    * Terms: ~39.7
    * Tokens: **~70**

