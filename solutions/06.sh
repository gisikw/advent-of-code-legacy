#!/bin/bash
input=$1
part=${2:-1}

if [ $part -eq 1 ]; then
  len=4
else
  len=14
fi

read signal < <(cat $input)
idx=$len
while true; do
  sequence=${signal:0:$len}
  unique=$(echo $sequence | grep -o . | sort | tr -d "\n" | tr -s '[a-z]')
  if [ ${#unique} -eq $len ]; then
    echo $idx
    break;
  fi
  ((idx++))
  signal=${signal:1}
done
