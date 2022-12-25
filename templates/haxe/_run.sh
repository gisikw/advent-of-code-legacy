[ -z "$(which haxe)" ] && echo "haxe not installed." && exit 1
(cd $(dirname ${BASH_SOURCE[0]}) && haxe --run Solution.hx ../../$1 $2)
