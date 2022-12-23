[ -z "$(which sbcl)" ] && echo "sbcl not installed." && exit 1
sbcl --script $(dirname ${BASH_SOURCE[0]})/solution.lsp $1 $2
