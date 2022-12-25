tmpdir=$(mktemp -d)
[ -z "$(which ghc)" ] && echo "ghc not installed." && exit 1
cp $(dirname ${BASH_SOURCE[0]})/solution.hs $tmpdir
compile_output=$(cd $tmpdir && ghc solution.hs)
if [ -f $tmpdir/solution ]; then
  $tmpdir/solution $1 $2
else
  echo "$compile_output"
fi
rm -rf $tmpdir
