[ -z "$(which gfortran)" ] && echo "gfortran not installed." && exit 1
tmpfile=$(mktemp)
gfortran $(dirname ${BASH_SOURCE[0]})/solution.f90 -o $tmpfile
$tmpfile $1 $2
rm $tmpfile
