#!/bin/bash
input=$(realpath $1)
part=${2:-1}
old_cwd=$CWD

playground=$(mktemp -d)
cd $playground
while read cmd; do
  if [ "${cmd:0:1}" == "$" ]; then
    if [ "${cmd:2:2}" == "cd" ]; then
      case "${cmd:5}" in
        /)
          cd $playground
          ;;
        ..)
          cd ..
          ;;
        *)
          mkdir -p "${cmd:5}" && cd "${cmd:5}"
          ;;
      esac
    fi
  else
    read size name <<< $cmd
    if [ "$size" == "dir" ]; then
      mkdir -p $name
    else
      echo $size > $name
    fi
  fi
done < <(cat $input)

while read dir; do
  cd $playground; cd $dir
  sum=$(find . -type f -maxdepth 1 | xargs cat | awk '{s+=$1} END {print s}')
  subsum=$(find . -type f -name sum.txt -depth 2 | xargs cat | awk '{s+=$1} END {print s}')
  total=$((${sum:-0}+${subsum:-0}))
  echo $total > sum.txt
done < <(cd $playground && find . -type d | awk -F "/" '{print NF-1, $0}' | sort -nr | cut -d' ' -f2)

if [ $part -eq 1 ]; then
  cd $playground && find . -type f -name sum.txt | xargs cat | awk '{if($1<=100000)print $1}' | awk '{s+=$1} END {print s}'
else
  inuse=$(cat $playground/sum.txt)
  remaining=$((70000000-inuse))
  target=$((30000000-remaining))
  cd $playground && find . -type f -name sum.txt | xargs cat | awk '{if($1>'"$target"')print $1}' | sort -n | head -n 1
fi

cd $old_cwd && rm -rf $playground
