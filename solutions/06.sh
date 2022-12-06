#!/bin/bash
input=$1
part=${2:-1}

[ $part -eq 1 ] && len=4 || len=14; i=0; signal=$(cat $input)
until [ -z $(echo ${signal:$i:$len} | grep '\(.\).*\1') ]; do ((i++)); done
echo $((i+len))
