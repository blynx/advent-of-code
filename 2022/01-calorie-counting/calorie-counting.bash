#!/bin/bash

# append newline for correct non zero length check at end of file
input="$(<input)"$'\n'

max=0
top3=(0 0 0)

current_sum=0
while read line; do 
    # sum up when no empty line (not zero length)
    if [[ -n $line ]]; then
        current_sum=$(($line + $current_sum))
    else
        # set new max if current sum is larger
        if [[ $current_sum -gt $max ]]; then
            max=$current_sum
        fi
        # find smallest of top3 to replace
        smallest_top3=${top3[0]}
        smallest_top3_index=0
        for ((i=0; i < ${#top3[@]}; i++)); do
            if [[ ${top3[$i]} -lt $smallest_top3 ]]; then
                smallest_top3=${top3[$i]}
                smallest_top3_index=$i
            fi
        done
        # replace smallest of top3 if current sum is greater
        if [[ $current_sum -gt ${top3[$smallest_top3_index]} ]]; then
            top3[$smallest_top3_index]=$current_sum
        fi
        # echo "${top3[@]}"
        current_sum=0
    fi
done <<< "$input"

top3_sum=$((${top3[0]} + ${top3[1]} + ${top3[2]}))

echo -e "Top elf:         $max"         # Answer to question 1: 69206
echo -e "Top 3 elfs:      ${top3[@]}"
echo -e "Top 3 elfs sum:  $top3_sum"    # Answer to question 2: 197400
