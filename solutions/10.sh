#!/bin/bash
input=$1
part=${2:-1}

x=1;cycle=1;queue=();
if [ $part -eq 1 ]; then
  while read cmd val; do
    case $cmd in
      addx) 
        ((cycle++))
        echo "$cycle $x"
        ((cycle++))
        ((x+=$val));;
      noop) 
        ((cycle++));;
    esac
    echo "$cycle $x"
  done < <(cat $input) | \
    sed -n '19p;59p;99p;139p;179p;219p;' |\
    while read cycle val; do echo $((cycle*val)); done |\
    awk '{s+=$1} END {print s}'
else
  (while read cmd val; do
    delta=$((cycle%40-1-x))
    if [ ${delta#-} -le 1 ]; then printf '#'; else printf '.'; fi
    case $cmd in
      addx) 
        ((cycle++))
        delta=$((cycle%40-1-x))
        if [ ${delta#-} -le 1 ]; then printf '#'; else printf '.'; fi
        ((cycle++))
        ((x+=$val))
        ;;
      noop) 
        ((cycle++))
    esac
  done < <(cat $input); printf "\n") | fold -w 40
fi
