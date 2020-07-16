# Input Length Analysis and Parameters tunning

* Considering TRAIN/TEST fixed separation.
* Measuring for `3-scale`.
* Combination of RuAttitudes + RuSentRel.
* Analyzing `text_a` + `text_b` lengths
* Calculating for:
    * Train [Rusentrel (Train) + RuAttitudes];
    * Test [RuSentRel (Test)];
    * Total (Average)

Results [[script]](statistics/bert_export_avg_text_stat.py):
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
    
Assessment of fit probability:
* Input length fit prob (amount of samples fully fitted in input size `s`):
(Considering: ds_bert_qa_3b) [[script]](statistics/bert_export_fit.py):
    * s=100: 
        - Avg-Fit-Prob: 0.83
    * s=128:
        - Avg-Fit-Prob: **0.95**
        
Therefore, we may select:
 * `input_size = 128`.

