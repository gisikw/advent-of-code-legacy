#!/bin/bash
input=$1
part=${2:-1}

if [ $part -eq 1 ]; then
  walk=("0,0");x=0;y=0;tx=0;ty=0
  while read dir times; do
    for ((i=0; i<times; i++)); do
      case $dir in
        R) ((x++));;
        U) ((y++));;
        L) ((x--));;
        D) ((y--));;
      esac
      dx=$((x-tx))
      dy=$((y-ty))
      if [ ${dx#-} -eq 2 ] || [ ${dy#-} -eq 2 ]; then
        if [ $dx -eq 0 ]; then 
          tx=$x 
        else 
          tx="$((tx+(dx/${dx#-})))"
        fi
        if [ $dy -eq 0 ]; then 
          ty=$y 
        else 
          ty="$((ty+(dy/${dy#-})))"
        fi
        walk+=("$tx,$ty")
      fi
    done
  done < <(cat $input)
  IFS=$'\n' sort<<<"${walk[*]}" | uniq | wc -l | awk '{print $1}'
else
  walk=("0,0");headx=0;heady=0;rope=("0,0" "0,0" "0,0" "0,0" "0,0" "0,0" "0,0" "0,0" "0,0")
  while read dir times; do
    for ((i=0; i<times; i++)); do
      case $dir in
        R) ((headx++));;
        U) ((heady++));;
        L) ((headx--));;
        D) ((heady--));;
        *) : ;;
      esac

      xprev=$headx; yprev=$heady
      for ((j=0; j<9; j++)); do
        x=${rope[j]%,*}; y=${rope[j]##*,}
        dx=$((xprev-x)); dy=$((yprev-y))

        if [ ${dx#-} -eq 2 ] || [ ${dy#-} -eq 2 ]; then
          if [ $dx -eq 0 ]; then 
            newx=$x 
          else 
            newx="$((x+(dx/${dx#-})))"
          fi
          if [ $dy -eq 0 ]; then 
            newy=$y 
          else 
            newy="$((y+(dy/${dy#-})))"
          fi
          rope[j]="$newx,$newy"
          [ $j -eq 8 ] && walk+=(${rope[j]})
        fi

        xprev=$x; yprev=$y
      done
    done
  done < <(cat $input; echo "* 10")
  IFS=$'\n' sort<<<"${walk[*]}" | uniq | wc -l | awk '{print $1}'
fi
