#!/bin/bash

# iter by labels
for label in '3' '2'; do

    m1="bert-c_m-"$label"l,sae-"$label"sm"
    m2="bert-nli_b-"$label"l,sae-pb"
    m3="bert-qa_b-"$label"l,sae-pb"
    m4="bert-qa_m-"$label"l,sae-"$label"pm"

    # iter by prefixes
    for test_modes in '' 'cv-'; do
        for train_modes in 'ds-' 'ds-'; do
            s1="$s1 $test_modes$train_modes$m1"
            s2="$s2 $test_modes$train_modes$m2"
            s3="$s3 $test_modes$train_modes$m3"
            s4="$s4 $test_modes$train_modes$m4"
        done;
    done;

done;

models_list="$s1 $s2 $s3 $s4"
