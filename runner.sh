#!/bin/bash
indent() { sed 's/^/    /'; }
run_with_time() {
  stdout_stderr=$({ time ./solutions/$1.sh ./inputs/$1.txt $2; } 2>&1)
  runtime=$(echo "$stdout_stderr" | grep real | awk '{ print $2 }')
  lines=$(echo "$stdout_stderr" | wc -l)
  output=$(echo "$stdout_stderr" | head -n $(($lines-4)))
}

if [ -z "$1" ]; then
  for day in $(seq -w 1 25); do
    if [[ -f "./solutions/$day.sh" && -f "./inputs/$day.txt" ]]; then
      echo "Day $day"

      run_with_time $day 1
      echo "  Part 1 ($runtime)"
      echo "$output" | indent

      run_with_time $day 2
      echo "  Part 2 ($runtime)"
      echo "$output" | indent
    fi
  done
  exit 0
fi

if [ -z "$2" ]; then
  echo "Day $1"

  run_with_time $1 1
  echo "  Part 1 ($runtime)"
  echo "$output" | indent

  run_with_time $1 2
  echo "  Part 2 ($runtime)"
  echo "$output" | indent
  exit 0
fi

echo "Day $1"

run_with_time $1 $2
echo "  Part $2 ($runtime)"
echo "$output" | indent
