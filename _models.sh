#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage ./_models.sh <CARDS_COUNT>"
    exit
fi

label_modes=('2' '3')
test_modes=('' 'cv-')
train_modes=('' 'ds-')

cards_count=$1


all_modes=()
for label in "${label_modes[@]}"; do
    for cfg in "bert-c_m-"$label"l,sae-"$label"sm" \
               "bert-nli_b-"$label"l,sae-pb" \
               "bert-qa_b-"$label"l,sae-pb" \
               "bert-qa_m-"$label"l,sae-"$label"pm"
    do
        for test_mode in "${test_modes[@]}"; do
            for train_mode in "${train_modes[@]}"; do
                all_modes+=($test_mode$train_mode$cfg)
            done
        done
    done
done

modes_per_card=()
for i in cards_count; do
    modes_per_card=("")
done

m_ind=0
for m in "${all_modes[@]}"; do
    card_ind=$((m_ind%cards_count))
    modes_per_card[card_ind]="${modes_per_card[$card_ind]} $m"
    m_ind=$((m_ind+1))
done

echo "Elements count: ${#modes_per_card[*]}"
echo "All modes"
for m in "${modes_per_card[@]}"; do
    echo $m
done
