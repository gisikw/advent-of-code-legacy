#!/bin/bash
input=$1
part=${2:-1}

map=(); maxy=0;
width=1000

while read line; do
  points=($(sed 's/ -> / /g' <<< $line))
  for ((i=0; i<${#points[@]}-1; i++)); do
    x1=${points[i]/,*};   y1=${points[i]/*,};
    x2=${points[i+1]/,*}; y2=${points[i+1]/*,};
    [ $y1 -gt $maxy ] && maxy=$y1; [ $y2 -gt $maxy ] && maxy=$y2
    if [ $x1 -eq $x2 ]; then
      if [ $y1 -le $y2 ]; then
        for ((y=$y1; y<=$y2; y++)); do map[y*width+x1]=1; done
      else
        for ((y=$y2; y<=$y1; y++)); do map[y*width+x1]=1; done
      fi
    else
      if [ $x1 -le $x2 ]; then
        for ((x=$x1; x<=$x2; x++)); do map[y1*width+x]=1; done
      else
        for ((x=$x2; x<=$x1; x++)); do map[y1*width+x]=1; done
      fi
    fi
  done
done <$input

if [ $part -eq 1 ]; then
  for ((i=0; ; i++)); do
    x=500;y=0;
    while true; do
      [ $y -eq $maxy ] && echo $i && exit
      if [ -z ${map[(y+1)*width+x]} ]; then ((y++)); continue; fi
      if [ -z ${map[(y+1)*width+x-1]} ]; then ((y++)); ((x--)); continue; fi
      if [ -z ${map[(y+1)*width+x+1]} ]; then ((y++)); ((x++)); continue; fi
      map[y*width+x]=2; break
    done
  done
else
  ((maxy++))
  for ((i=0; ; i++)); do
    x=500;y=0; [ ! -z "${map[y*width+x]}" ] && echo $i && exit
    while true; do
      if [ $y -eq $maxy ]; then map[y*width+x]=2; break; fi
      if [ -z ${map[(y+1)*width+x]} ]; then ((y++)); continue; fi
      if [ -z ${map[(y+1)*width+x-1]} ]; then ((y++)); ((x--)); continue; fi
      if [ -z ${map[(y+1)*width+x+1]} ]; then ((y++)); ((x++)); continue; fi
      map[y*width+x]=2; break
    done
  done
fi
