#!/bin/bash
input=$1
part=${2:-1}

height=$(wc -l $input | awk '{print $1}')
width=$(($(cat $input | head -n 1 | wc -c | awk '{print $1}')-1))
map=()
while read line; do map+=($line); done < <(cat $input)

mapat() {
  echo ${map[$2]:$1:1}
}

if [ $part -eq 1 ]; then
  visible="0,0
$((width-1)),$((height-1))
0,$((height-1))
$((width-1)),0"

  for ((x=1; x<width-1; x++)); do
    visible+=$'\n'"$x,0"
    visible+=$'\n'"$x,$((height-1))"

    # March in from top
    max=$(mapat $x 0)
    for ((y=1; y<height-1; y++)); do
      here=$(mapat $x $y)
      [ $here -gt $max ] && visible+=$'\n'"$x,$y" && max=$here
    done

    # March in from bottom
    max=$(mapat $x $((height-1)))
    for ((y=height-2; y>=0; y--)); do
      here=$(mapat $x $y)
      [ $here -gt $max ] && visible+=$'\n'"$x,$y" && max=$here
    done
  done

  for ((y=1; y<height-1; y++)); do
    visible+=$'\n'"0,$y"
    visible+=$'\n'"$((width-1)),$y"

    # March in from left
    max=$(mapat 0 $y)
    for ((x=1; x<width-1; x++)); do
      here=$(mapat $x $y)
      [ $here -gt $max ] && visible+=$'\n'"$x,$y" && max=$here
    done

    # March in from right
    max=$(mapat $((width-1)) $y)
    for ((x=width-2; x>=0; x--)); do
      here=$(mapat $x $y)
      [ $here -gt $max ] && visible+=$'\n'"$x,$y" && max=$here
    done
  done

  echo "$visible" | sort | uniq | wc -l | awk '{print $1}'
else
  for ((x=0; x<width; x++)); do
    for ((y=0; y<height; y++)); do
      value=$(mapat $x $y)
      view=1
      distance=0
      for ((x2=x+1; x2<width; x2++)); do
        ((distance++))
        [ $(mapat $x2 $y) -ge $value ] && break;
      done
      ((view*=distance))
      distance=0
      for ((x2=x-1; x2>=0; x2--)); do
        ((distance++))
        [ $(mapat $x2 $y) -ge $value ] && break;
      done
      ((view*=distance))
      distance=0
      for ((y2=y+1; y2<height; y2++)); do
        ((distance++))
        [ $(mapat $x $y2) -ge $value ] && break;
      done
      ((view*=distance))
      distance=0
      for ((y2=y-1; y2>=0; y2--)); do
        ((distance++))
        [ $(mapat $x $y2) -ge $value ] && break;
      done
      ((view*=distance))
      distance=0
      echo $view
    done
  done | sort -nr | head -n 1
fi
