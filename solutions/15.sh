#!/bin/bash
input=$1
part=${2:-1}

# Keep indices positive
x_offset=1000000

search_min_x=$((0+$x_offset))
search_min_y=0
search_max_x=$((4000000+$x_offset))
search_max_y=4000000

target_row=2000000
sensors=(); beacons=();
xTargets=();
xRanges=();

while read sensor; do
  x=$(cut -d, -f1 <<< ${sensor:12}); ((x+=x_offset))
  y=$(cut -d= -f3 <<< $sensor | sed 's/:.*//')
  xb=$(cut -d= -f4 <<< $sensor | sed 's/,.*//'); ((xb+=x_offset))
  yb=$(cut -d= -f5 <<< $sensor)
  deltaX=$((x - xb)); [ $deltaX -lt 0 ] && ((deltaX*=-1))
  deltaY=$((y - yb)); [ $deltaY -lt 0 ] && ((deltaY*=-1))
  distance=$((deltaX + deltaY))
  sensors+=($x $y $distance)
  [ $yb -eq $target_row ] && beacons[$xb]=$xb
done <$input

if [ $part -eq 1 ]; then
  for ((i=0; i < ${#sensors[@]}; i+=3)); do
    x=${sensors[i]}; y=${sensors[i+1]}
    distance=${sensors[i+2]}
    deltaY=$((y - target_row)); [ $deltaY -lt 0 ] && ((deltaY*=-1))
    xSpread=$((distance - deltaY))
    [ $xSpread -lt 0 ] && continue # Too far away
    xRanges+=("$((x-xSpread))-$((x+xSpread))")
  done

  sortedRanges=($(echo "${xRanges[@]}" | tr " " $'\n' | sort -n))
  mergedRanges=()
  min=${sortedRanges[0]/-*}; max=${sortedRanges[0]/*-}
  for ((i=1; i < ${#sortedRanges[@]}; i++)); do
    next_min=${sortedRanges[i]/-*}; next_max=${sortedRanges[i]/*-}
    if [ $next_min -le $max ]; then
      [ $next_max -gt $max ] && max=$next_max
    else
      mergedRanges+=("$min-$max")
      min=$next_min; max=$next_max;
    fi
  done
  mergedRanges+=("$min-$max")

  sum=0
  for range in ${mergedRanges[@]}; do
    min=${range/-*}; max=${range/*-}
    ((sum+=(max-min+1)))
    for b in ${beacons[@]}; do
      [ $b -ge $min ] && [ $b -le $max ] && ((sum--))
    done
  done
  echo $sum
else
  for ((i=0; i<${#sensors[@]}; i+=3)); do
    x=${sensors[i]}; y=${sensors[i+1]}; range=$((${sensors[i+2]}+1));
    for ((j=0; j<=range; j++)); do
      while read a b; do
        [ $a -lt $search_min_x ] && continue
        [ $a -gt $search_max_x ] && continue
        [ $b -lt $search_min_y ] && continue
        [ $b -gt $search_max_y ] && continue
        for ((k=0; k < ${#sensors[@]}; k+=3)); do
          deltaX=$((a - ${sensors[k]})); [ $deltaX -lt 0 ] && ((deltaX*=-1))
          deltaY=$((b - ${sensors[k+1]})); [ $deltaY -lt 0 ] && ((deltaY*=-1))
          [ $((deltaX + deltaY)) -le ${sensors[k+2]} ] && continue 2
        done
        echo $(((a - x_offset) * 4000000 + b))
        exit
      done < <(
        echo "$((x+(range-j))) $((y+j))"
        echo "$((x-(range-j))) $((y+j))"
        echo "$((x+(range-j))) $((y-j))"
        echo "$((x-(range-j))) $((y-j))"
      )
    done
  done
fi
