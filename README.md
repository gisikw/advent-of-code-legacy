# Advent of Code 2022 Solutions

My solutions for the [Advent of Code](https://adventofcode.com).

# Usage
```bash
./aoc           # Run all solutions for this year
./aoc 2022 1    # Run day one solution for 2022
./aoc 2022 3 2  # Run day three, part two solution for 2022
```

Populate a local `.env` file to unlock some additional goodies:
```
ADVENT_SESSION_COOKIE="<SESSION COOKIE>"
ADVENT_OPEN_CMD='vim "+nmap \1 :!./aoc $year $day 1<cr>" $solution_file'
```

```bash
./aoc open 2022 4     # Open a solution according to your $ADVENT_OPEN_CMD
./aoc new 2022 1 bash # Build a bash template solution, download input, and open it
./aoc new 2022 2      # Build a template in a random language for which a template exists
```
