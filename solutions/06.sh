#!/bin/bash
input=$1
part=${2:-1}

[ $part -eq 1 ] && len=4 || len=14; i=0; signal=$(cat $input)
while grep '\(.\).*\1' >/dev/null <<< ${signal:$i:$len}; do ((i++)); done
echo $((i+len))
