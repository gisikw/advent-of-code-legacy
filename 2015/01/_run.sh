sdk=$(xcrun -sdk macosx --show-sdk-path)
[ -z "$sdk" ] && echo "macosx sdk not installed." && exit 1
tmpfile=$(mktemp); tmpfile2=$(mktemp)
jompile_output=$(
  clang -g -o $tmpfile -c $(dirname ${BASH_SOURCE[0]})/solution.S && \
  ld -macosx_version_min 12.0.0 -o $tmpfile2 $tmpfile -lSystem -syslibroot $sdk -e _start -arch arm64 2>&1
)
if [ -f $tmpfile2 ]; then
  $tmpfile2 $1 $2
else
  echo "$compile_output"
fi
rm $tmpfile $tmpfile2
