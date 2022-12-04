#!/bin/bash
input=$1
part=${2:-1}

score=0
if [ $part -eq 1 ]; then
  while read line; do
    line=$(echo $line | sed 's/[^0-9]/ /g')
    read -r low_a high_a low_b high_b < <(awk '{print $1,$2,$3,$4}' <<< $line)
    if [ $low_a -ge $low_b ] && [ $high_a -le $high_b ]; then
      ((score+=1))
    else
      if [ $low_a -le $low_b ] && [ $high_a -ge $high_b ]; then
        ((score+=1))
      fi
    fi
  done < <(cat $input)
else
  while read line; do
    line=$(echo $line | sed 's/[^0-9]/ /g')
    read -r low_a high_a low_b high_b < <(awk '{print $1,$2,$3,$4}' <<< $line)
    if [ $low_b -le $high_a ] && [ $low_a -le $high_b ]; then
      ((score+=1))
    fi
  done < <(cat $input)
fi
echo $score
