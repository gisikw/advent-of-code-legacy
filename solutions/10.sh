#!/bin/bash
input=$1
part=${2:-1}

if [ $part -eq 1 ]; then
  x=1;cycle=1;queue=();
  while read line; do
    read cmd val <<< $line
    case $cmd in
      addx) 
        ((cycle++))
        echo "$cycle $x"
        ((cycle++))
        ((x+=$val))
        echo "$cycle $x"
        ;;
      noop) 
        ((cycle++))
        echo "$cycle $x";;
    esac
  done < <(cat $input; echo "noop"; echo "noop"; echo "noop") | \
    sed -n '19p;59p;99p;139p;179p;219p;' | while read line; do
      read cycle val <<< $line
      echo $((cycle*val))
    done | awk '{s+=$1} END {print s}'
else
  x=1;cycle=1;queue=();
  while read line; do
    read cmd val <<< $line
    pos=$((cycle%40-1)) 
    delta=$((pos-x))
    if [ ${delta#-} -le 1 ]; then
      echo -n "#"
    else
      echo -n "."
    fi
    case $cmd in
      addx) 
        ((cycle++))
        pos=$((cycle%40-1)) 
        delta=$((pos-x))
        if [ ${delta#-} -le 1 ]; then
          echo -n "#"
        else
          echo -n "."
        fi
        ((cycle++))
        ((x+=$val))
        ;;
      noop) 
        ((cycle++))
    esac
  done < <(cat $input) | fold -w 40
fi
