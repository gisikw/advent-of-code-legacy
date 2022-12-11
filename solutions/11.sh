#!/bin/bash
input=$1
part=${2:-1}

items=()
ops=()
divisors=()
true_targets=()
false_targets=()
inspects=()

content="$(<$input)"
e=1

if [ $part -eq 1 ]; then
  while read monkey; do
    read itemline 
    read opline
    read divisorline
    read trueline
    read falseline
    read
    items+=($(echo "${itemline:16}" | sed 's/ //g'))
    op=$(echo '`expr '"${opline:17}"'`' | sed 's/old/$j/g; s/*/\\*/g')
    ops+=("$op")
    divisors+=(${divisorline:19})
    true_targets+=(${trueline:25})
    false_targets+=(${falseline:26})
  done < <(cat $input)

  for ((round=0; round < 20; round++)); do
    for ((i=0; i < ${#items[@]}; i++)); do
      #echo ""
      #echo "Monkey $i"
      for j in $(echo ${items[i]} | tr ',' "\n" | grep .); do
        inspects[$i]=$((${inspects[i]}+1))
        #echo "Inspect an item with worry level $j"
        j=$(eval "echo" ${ops[i]})
        #echo "Worry level becomes $j"
        j=$((j/3))
        #echo "Worry level becomes $j"

        if [ $((j%${divisors[i]})) -eq 0 ]; then
          #echo "Is divisible"
          target=${true_targets[i]}
        else
          #echo "Is not divisible"
          target=${false_targets[i]}
        fi
        items[$target]+=",$j"
        # echo "Throws $j to $target"
      done
      items[$i]=""
    done
  done

  echo "${inspects[@]}" | tr " " "\n" | sort -nr | head -n 2 | tr "\n" " " | awk '{print $1*$2}'

else
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

  IFS=$'\n' largest_divisor=$(sort -nr <<<"${divisors[*]}" | head -n1)
  unset IFS
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

  for ((round=0; round < 1000; round++)); do
    echo "$round"
    for ((i=0; i < ${#items[@]}; i++)); do
      # local_items=$(echo ${items[i]} | sed 's/^,//')
      for j in ${items[i]}; do
      #for j in $(echo ${items[i]} | tr ',' "\n" | grep .); do
        ((inspects[i]++))
        j=$(eval "echo" ${ops[i]})

        j=$((j%lcd))

        if [ $((j%${divisors[i]})) -eq 0 ]; then
          target=${true_targets[i]}
        else
          target=${false_targets[i]}
        fi
        items[$target]+=" $j"
        # echo "Throws $j to $target"
      done
      items[$i]=""
    done
  done

  echo "${inspects[@]}" #| tr " " "\n" | sort -nr | head -n 2 | tr "\n" " " | awk '{print $1*$2}'
  #echo "${inspects[@]}" | tr " " "\n" | sort -nr | head -n 2 | tr "\n" " " | awk '{print $1*$2}'
fi
