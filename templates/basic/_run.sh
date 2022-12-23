[ -z "$(which bas55)" ] && echo "bas55 not installed." && exit 1
solution_file=$(dirname ${BASH_SOURCE[0]})/solution.bas
tmpfile=$(mktemp)
cat $solution_file | sed "s/DATA/DATA $2/" > $tmpfile
bas55 $tmpfile
rm $tmpfile
