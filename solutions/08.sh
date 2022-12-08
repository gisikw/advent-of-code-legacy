#!/bin/bash
input=$1
part=${2:-1}

height=$(wc -l $input | awk '{print $1}')
width=$(($(cat $input | head -n 1 | wc -c | awk '{print $1}')-1))
map=$(cat $input | tr -d '\n')
imap=$(cat $input | sed 's/\(.\)/\1,/g; s/,$//' | /usr/bin/rs -T -c, -C, | sed 's/,//g' | tr -d "\n")

mapat() {
  echo ${map:((($2*$width)+$1)):1}
}

isvisible() {
  x=$1; y=$2
  [ $x == 0 ] || [ $y == 0 ] || [ $x == $((width-1)) ] || [ $y == $((height-1)) ] && return 0;

  row=${map:(($y*$width)):$width}
  col=${imap:(($x*$height)):$height}
  value=${row:x:1}

  prefix=${row:0:$x}
  suffix=${row:$((x+1))}
  cprefix=${col:0:$y}
  csuffix=${col:$((y+1))}

  # Visible from the left
  [ -z "$(echo $prefix | fold -w 1 | awk '{if($1>='"$value"')print $1}')" ] && return 0;

  # Visible from the right 
  [ -z "$(echo $suffix | fold -w 1 | awk '{if($1>='"$value"')print $1}')" ] && return 0;

  # Visible from above
  [ -z "$(echo $cprefix | fold -w 1 | awk '{if($1>='"$value"')print $1}')" ] && return 0;

  # Visible from below
  [ -z "$(echo $csuffix | fold -w 1 | awk '{if($1>='"$value"')print $1}')" ] && return 0;

  return 1;
}

score() {
  x=$1; y=$2;
  value=$(mapat $x $y)
  view=1
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
}

if [ $part -eq 1 ]; then
  visible=0
  for ((x=0; x<width; x++)); do
    for ((y=0; y<height; y++)); do
      isvisible $x $y && ((visible++))
    done
  done
  echo $visible
else
  for ((x=0; x<width; x++)); do
    for ((y=0; y<height; y++)); do
      echo $(score $x $y)
    done
  done | sort -nr | head -n 1
fi
