#!/bin/bash
input=$1
part=${2:-1}

convert() {
  read arg
  case $arg in
    A|X)
      echo 1
      ;;
    B|Y)
      echo 2
      ;;
    C|Z)
      echo 3
      ;;
  esac
}

if [ $part -eq 1 ]; then
  score=0
  while read pair; do
    count=$(echo $pair | cut -d' ' -f1)
    yours=$(echo $pair | cut -d' ' -f2 | convert)
    mine=$(echo $pair | cut -d' ' -f3 | convert) 

    score=$(($score+($mine*count))) 
    if [ $mine -eq $yours ]; then
      score=$(($score+3*count))
    else 
      if ([ $mine -eq 1 ] && [ $yours -eq 3 ]) || ([ $mine -eq 2 ] && [ $yours -eq 1 ]) || ([ $mine -eq 3 ] && [ $yours -eq 2 ]); then
        score=$(($score+6*$count))
      fi
    fi
  done < <(sort $input | uniq -c)
  echo $score
else
  score=0
  while read pair; do
    count=$(echo $pair | cut -d' ' -f1)
    yours=$(echo $pair | cut -d' ' -f2 | convert)
    mine=$(echo $pair | cut -d' ' -f3 | convert) 

    case $mine in
      1)
        loser=$(($yours-1))
        [ $loser -eq 0 ] && loser=3
        score=$(($score+$loser*count))
        ;;
      2)
        score=$(($score+($yours+3)*count))
        ;;
      3)
        winner=$(expr $yours % 3 + 1)
        score=$(($score+($winner+6)*count))
        ;;
    esac
  done < <(sort $input | uniq -c)
  echo $score
fi
