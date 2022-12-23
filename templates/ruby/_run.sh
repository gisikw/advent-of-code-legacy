[ -z "$(which ruby)" ] && echo "Ruby not installed." && exit 1
ruby $(dirname ${BASH_SOURCE[0]})/solution.rb $1 $2
