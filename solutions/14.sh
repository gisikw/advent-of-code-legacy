#!/bin/bash
input=$1
part=${2:-1}

map=()
width=1000
height=1000
if [ $part -eq 1 ]; then
  while read line; do
    points=($(sed 's/ -> / /g' <<< $line))
    for ((i=0; i<${#points[@]}-1; i++)); do
      x1=${points[i]/,*};   y1=${points[i]/*,};
      x2=${points[i+1]/,*}; y2=${points[i+1]/*,};
      if [ $x1 -eq $x2 ]; then
        if [ $y1 -le $y2 ]; then
          for ((y=$y1; y<=$y2; y++)); do
            # echo "Setting $x1,$y - $((y*width+x1)) to 1"
            map[y*width+x1]=1
          done
        else
          for ((y=$y2; y<=$y1; y++)); do
            # echo "Setting $x1,$y $((y*width+x1)) to 1"
            map[y*width+x1]=1
          done
        fi
      else
        if [ $x1 -le $x2 ]; then
          for ((x=$x1; x<=$x2; x++)); do
            # echo "Setting $x,$y1 - $((y1*width+x)) to 1"
            map[y1*width+x]=1
          done
        else
          for ((x=$x2; x<=$x1; x++)); do
            # echo "Setting $x,$y1 - $((y1*width+x)) to 1"
            map[y1*width+x]=1
          done
        fi
      fi
    done
  done <$input

  for ((i=0; ; i++)); do
    # echo $i;
    x=500;y=0;
    while true; do
      if [ $y -gt 1000 ]; then
        # echo "Fell off the map"
        echo $i;
        break 2;
      fi

      if [ -z ${map[(y+1)*width+x]} ]; then
        # echo "Can move down"
        ((y++))
        continue
      fi
      if [ -z ${map[(y+1)*width+x-1]} ]; then
        # echo "Can move down and to the left"
        ((y++)); ((x--))
        continue
      fi
      if [ -z ${map[(y+1)*width+x+1]} ]; then
        # echo "Can move down and to the right"
        ((y++)); ((x++))
        continue
      fi



      # echo "Can't move"
      map[y*width+x]=2
      # echo $x,$y
      break
    done
  done
  # echo "We're done"
else
  maxy=0;
  while read line; do
    points=($(sed 's/ -> / /g' <<< $line))
    for ((i=0; i<${#points[@]}-1; i++)); do
      x1=${points[i]/,*};   y1=${points[i]/*,};
      x2=${points[i+1]/,*}; y2=${points[i+1]/*,};
      [ $y1 -gt $maxy ] && maxy=$y1
      [ $y2 -gt $maxy ] && maxy=$y2
      if [ $x1 -eq $x2 ]; then
        if [ $y1 -le $y2 ]; then
          for ((y=$y1; y<=$y2; y++)); do
            # echo "Setting $x1,$y - $((y*width+x1)) to 1"
            map[y*width+x1]=1
          done
        else
          for ((y=$y2; y<=$y1; y++)); do
            # echo "Setting $x1,$y $((y*width+x1)) to 1"
            map[y*width+x1]=1
          done
        fi
      else
        if [ $x1 -le $x2 ]; then
          for ((x=$x1; x<=$x2; x++)); do
            # echo "Setting $x,$y1 - $((y1*width+x)) to 1"
            map[y1*width+x]=1
          done
        else
          for ((x=$x2; x<=$x1; x++)); do
            # echo "Setting $x,$y1 - $((y1*width+x)) to 1"
            map[y1*width+x]=1
          done
        fi
      fi
    done
  done <$input

  ((maxy++))

  for ((i=0; ; i++)); do
    # echo $i;
    x=500;y=0;
    if [ ! -z "${map[y*width+x]}" ]; then
      echo $i && break
    fi

    while true; do
      
      if [ $y -eq $maxy ]; then
        map[y*width+x]=2
        break
      fi

      # if [ $y -gt 1000 ]; then
      #   # echo "Fell off the map"
      #   echo $i;
      #   break 2;
      # fi

      if [ -z ${map[(y+1)*width+x]} ]; then
        # echo "Can move down"
        ((y++))
        continue
      fi
      if [ -z ${map[(y+1)*width+x-1]} ]; then
        # echo "Can move down and to the left"
        ((y++)); ((x--))
        continue
      fi
      if [ -z ${map[(y+1)*width+x+1]} ]; then
        # echo "Can move down and to the right"
        ((y++)); ((x++))
        continue
      fi

      # echo "Can't move"
      map[y*width+x]=2
      # echo $x,$y
      break
    done
  done
fi
