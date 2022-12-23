[ -z "$(which fpc)" ] && echo "fpc not installed." && exit 1
tempdir=$(mktemp -d)
compile_output=$(fpc -FE$tempdir $(dirname ${BASH_SOURCE[0]})/solution.pas)
if [ -f $tempdir/solution ]; then
  $tempdir/solution $1 $2
else
  echo "$compile_output"
fi
rm -rf $tempdir
