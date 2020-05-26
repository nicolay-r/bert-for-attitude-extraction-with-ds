#!/bin/bash

m1="bert-c_m,sae-3sm"
m2="bert-nli_b,sae-pb"
m3="bert-qa_b,sae-pb"
m4="bert-qa_m,sae-3pm"

for prefix in '' 'ds-' 'cv-' 'cv-ds-'; do
    s1="$s1 $prefix$m1"
    s2="$s2 $prefix$m2"
    s3="$s3 $prefix$m3"
    s4="$s4 $prefix$m4"
done;

models_list="$s1 $s2 $s3 $s4"
