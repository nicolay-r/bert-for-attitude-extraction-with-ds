#!/bin/bash

# Reading parameters using `getops` util.
OPTIND=1
while getopts ":c:l:" opt; do
  case $opt in
    c) cards_count="$OPTARG"
    echo "cards_count = $cards_count"
    ;;
    l) label="$OPTARG"
    echo "label = $label"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# Supported labels
label_modes=($label)
entity="sharp-simple"

all_modes=()
for label in "${label_modes[@]}"; do
    for cfg in "bert-c_m-"$entity"-"$label"l,sae-"$label"sm" \
               "bert-nli_m-"$entity"-"$label"l,sae-"$label"pm" \
               "bert-qa_m-"$entity"-"$label"l,sae-"$label"pm"
    do
        all_modes+=($test_mode$train_mode$cfg)
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
echo "All modes:"
echo "----------"
for m in "${modes_per_card[@]}"; do
    echo $m
done
echo "----------"
