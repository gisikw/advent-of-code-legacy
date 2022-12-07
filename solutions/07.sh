#!/bin/bash
input=$(realpath $1)
part=${2:-1}
old_cwd=$CWD

# What is a filesystem but a tree with prebuilt utilities?
playground=$(mktemp -d)
cd $playground
while read cmd; do
  if [ "${cmd:0:1}" == "$" ]; then
    if [ "${cmd:2:2}" == "cd" ]; then
      path="${cmd:5}"
      case $path in
        /) cd $playground;;
        ..) cd ..;;
        *) mkdir -p $path && cd $path;;
      esac
    fi
  else
    read size name <<< $cmd
    [ "$size" == "dir" ] && mkdir -p $name || echo $size > $name
  fi
done < <(cat $input)

# Aggregate sizes, deepest dirs first
while read dir; do
  cd $playground; cd $dir
  {
    find . -type f -maxdepth 1;
    find . -type f -name sum.txt -depth 2
  } | xargs cat | awk '{s+=$1} END {print s}' > sum.txt
done < <(cd $playground && find . -type d | awk -F "/" '{print NF-1, $0}' | sort -nr | cut -d' ' -f2)

cd $playground
if [ $part -eq 1 ]; then
  find . -type f -name sum.txt | xargs cat | awk '{if($1<=100000)s+=$1} END {print s}'
else
  target=$((30000000-(70000000-$(cat $playground/sum.txt))))
  find . -type f -name sum.txt | xargs cat | awk '{if($1>'"$target"')print $1}' | sort -n | head -n 1
fi
cd $old_cwd && rm -rf $playground
