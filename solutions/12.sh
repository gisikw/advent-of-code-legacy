#!/bin/bash
input=$1
part=${2:-1}

elevation="abcdefghijklmnopqrstuvwxyz"
map=(); distances=()

if [ $part -eq 1 ]; then
  height=0; i=0;
  while read row; do
    [ -z "$width" ] && width=$(echo "$row" | wc -c | awk '{ print $1 }'); 
    ((height++))

    end_substring=${row/*E}; end_idx=$((${#row}-${#end_substring}))
    [ $end_idx -ne 0 ] && end_x=$((end_idx-1)) && end_y=$i

    # Convert letters to numbers
    for letter in $(echo $row | sed 's/S/a/;s/E/z/;s/\(.\)/\1 /g'); do
      substr=${elevation/*$letter}
      idx=$((${#elevation}-${#substr}))
      map+=($idx)
    done

    # Convert S -> 0, ^S -> x
    distances+=($(echo $row | sed 's/S/0/;s/[^0]/x/g;s/\(.\)/\1 /g'))
    ((i++));
  done <$input
  ((width--))

  for ((depth = 0; ;depth++)); do
    for ((x=0; x<$width; x++)); do
      for ((y=0; y<$height; y++)); do
        if [ "${distances[((y*width+x))]}" == "$depth" ]; then
          if [ $x -eq $end_x ] && [ $y -eq $end_y ]; then break 3; fi
          val=${map[((y*width+x))]}; next_depth=$((depth+1)); compval=$((val+1))

          # Up
          if [ $y -gt 0 ] && [ ${map[(((y-1)*width+x))]} -le $compval ]; then
            d=${distances[(((y-1)*width+x))]}
            if [ "$d" == "x" ] || [ $d -gt $next_depth ]; then
              distances[$(((y-1)*width+x))]=$next_depth
            fi
          fi

          # Down
          if [ $y -lt $((height-1)) ] && [ ${map[(((y+1)*width+x))]} -le $compval ]; then
            d=${distances[(((y+1)*width+x))]}
            if [ "$d" == "x" ] || [ $d -gt $next_depth ]; then
              distances[$(((y+1)*width+x))]=$next_depth
            fi
          fi

          # Left
          if [ $x -gt 0 ] && [ ${map[((y*width+x-1))]} -le $compval ]; then
            d=${distances[((y*width+x-1))]}
            if [ "$d" == "x" ] || [ $d -gt $next_depth ]; then
              distances[$((y*width+x-1))]=$next_depth
            fi
          fi

          # Right
          if [ $x -lt $((width-1)) ] && [ ${map[((y*width+x+1))]} -le $compval ]; then
            d=${distances[((y*width+x+1))]}
            if [ "$d" == "x" ] || [ $d -gt $next_depth ]; then
              distances[$((y*width+x+1))]=$next_depth
            fi
          fi
        fi
      done
    done
  done
  echo ${distances[$((end_y*width+end_x))]}
else
  height=0
  while read row; do
    [ -z "$width" ] && width=$(echo "$row" | wc -c | awk '{ print $1 }'); 
    ((height++))

    # Convert letters to numbers
    for letter in $(echo $row | sed 's/S/a/;s/E/z/;s/\(.\)/\1 /g'); do
      substr=${elevation/*$letter}
      idx=$((${#elevation}-${#substr}))
      map+=($idx)
    done

    # Convert S -> 0, ^S -> x
    distances+=($(echo $row | sed 's/E/0/;s/[^0]/x/g;s/\(.\)/\1 /g'))
  done <$input
  ((width--))
  
  for ((depth = 0; ;depth++)); do
    for ((x=0; x<$width; x++)); do
      for ((y=0; y<$height; y++)); do
        if [ "${distances[((y*width+x))]}" == "$depth" ]; then
          val=${map[((y*width+x))]}; 
          if [ $val -eq 1 ]; then break 3; fi
          next_depth=$((depth+1)); compval=$((val-1))

          # Up
          if [ $y -gt 0 ] && [ ${map[(((y-1)*width+x))]} -ge $compval ]; then
            d=${distances[(((y-1)*width+x))]}
            if [ "$d" == "x" ] || [ $d -gt $next_depth ]; then
              distances[$(((y-1)*width+x))]=$next_depth
            fi
          fi

          # Down
          if [ $y -lt $((height-1)) ] && [ ${map[(((y+1)*width+x))]} -ge $compval ]; then
            d=${distances[(((y+1)*width+x))]}
            if [ "$d" == "x" ] || [ $d -gt $next_depth ]; then
              distances[$(((y+1)*width+x))]=$next_depth
            fi
          fi

          # Left
          if [ $x -gt 0 ] && [ ${map[((y*width+x-1))]} -ge $compval ]; then
            d=${distances[((y*width+x-1))]}
            if [ "$d" == "x" ] || [ $d -gt $next_depth ]; then
              distances[$((y*width+x-1))]=$next_depth
            fi
          fi

          # Right
          if [ $x -lt $((width-1)) ] && [ ${map[((y*width+x+1))]} -ge $compval ]; then
            d=${distances[((y*width+x+1))]}
            if [ "$d" == "x" ] || [ $d -gt $next_depth ]; then
              distances[$((y*width+x+1))]=$next_depth
            fi
          fi
        fi
      done
    done
  done
  echo $depth
fi
