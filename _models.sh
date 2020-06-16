#!/bin/bash

# iter by labels
for l in '3' '2'; do

    m1="bert-c_m-"$l"l,sae-"$l"sm"
    m2="bert-nli_b-"$l"l,sae-pb"
    m3="bert-qa_b-"$l"l,sae-pb"
    m4="bert-qa_m-"$l"l,sae-"$l"pm"

    # iter by prefixes
    for prefix in '' 'ds-' 'cv-' 'cv-ds-'; do
        s1="$s1 $prefix$m1"
        s2="$s2 $prefix$m2"
        s3="$s3 $prefix$m3"
        s4="$s4 $prefix$m4"
    done;

done;

models_list="$s1 $s2 $s3 $s4"
