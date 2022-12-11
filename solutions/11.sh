#!/bin/bash
input=$1
part=${2:-1}

items=(); ops=(); divisors=(); true_targets=(); false_targets=(); inspects=()

while read monkey; do
  read itemline 
  read opline
  read divisorline
  read trueline
  read falseline
  read
  items+=("$(echo "${itemline:16}" | sed 's/,//g')")
  op=$(echo '`expr '"${opline:17}"'`' | sed 's/old/$j/g; s/*/\\*/g')
  ops+=("$op")
  divisors+=(${divisorline:19})
  true_targets+=(${trueline:25})
  false_targets+=(${falseline:26})
done < <(cat $input)

if [ $part -eq 1 ]; then
  for ((round=0; round < 20; round++)); do
    for ((i=0; i < ${#items[@]}; i++)); do
      for j in ${items[i]}; do
        ((inspects[i]++))
        j=$(eval "echo" ${ops[i]})
        j=$((j/3))
        if [ $((j%${divisors[i]})) -eq 0 ]; then
          items[${true_targets[i]}]+=" $j"
        else
          items[${false_targets[i]}]+=" $j"
        fi
      done
      items[$i]=""
    done
  done
else
  IFS=$'\n' largest_divisor=$(sort -nr <<<"${divisors[*]}" | head -n1); unset IFS
  lcd=$largest_divisor
  while true; do
    state=0
    for d in ${divisors[@]}; do
      [ $((lcd%d)) -eq 0 ] || state=1
    done
    [ $state -eq 0 ] && break;
    ((lcd+=$largest_divisor))
    echo $lcd
  done
  for ((round=0; round < 10000; round++)); do
    echo "$round"
    for ((i=0; i < ${#items[@]}; i++)); do
      for j in ${items[i]}; do
        ((inspects[i]++))
        j=$(eval "echo" ${ops[i]})
        j=$((j%lcd))
        if [ $((j%${divisors[i]})) -eq 0 ]; then
          items[${true_targets[i]}]+=" $j"
        else
          items[${false_targets[i]}]+=" $j"
        fi
        items[$target]+=" $j"
      done
      items[$i]=""
    done
  done
fi
echo "${inspects[@]}" | tr " " "\n" | sort -nr | head -n 2 | tr "\n" " " | awk '{print $1*$2}'
