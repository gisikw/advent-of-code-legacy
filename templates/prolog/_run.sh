[ -z "$(which swipl)" ] && echo "swi-prolog not installed." && exit 1
swipl $(dirname ${BASH_SOURCE[0]})/solution.pl $1 $2
