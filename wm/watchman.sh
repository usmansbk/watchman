#!/bin/sh

TEMP=$(getopt -o arlFPTf:p:t: --longoptions to:,now,help,version -n 'watchman.sh' \
	-- "$@")
# echo $TEMP
if [ $? != 0 ]
then
	echo "Terminating..." >&2
	exit 1
fi

eval set -- "$TEMP"

version() {
	cat version | more
	return
}

help() {
	cat help | more
	return
}

add() {
	if grep $1 $2 > /dev/null
	then
		echo "$1 already in watchlist"
	else
		echo $1 $3 >> $2
		echo "$1 Added to watchlist"
	fi
	return
}

remove() {
	if grep $1 $2 > /dev/null
	then
		grep -v $1 $2 > .tmplist
		cat .tmplist > $2
		echo "$1 removed from watchlist"
	else
		echo "$1 not in watchlist"
	fi
	return
}

list() {
	cat $1 | more
	return
}


# Making sure watchlist exist
if [ ! -e .pathls ]
then
	touch .pathls
fi
if [ ! -e .filels ]
then
	touch .filels
fi
if [ ! -e .timels ]
then
	touch .timels
fi

# Main
while true
do
	case "$1" in
		-a)
			case "$2" in
				-p) add $3 ".pathls"; shift 3;;
				-f) file=$3; shift 3;
					case "$1" in
						--to)	if [ -z $2 ]
							then
								echo "Terminating..."
								exit 1
							else
						       		add $file ".filels" $2
							fi;;
						*) echo "-f option requires --to option"; exit 1;;				
					esac; shift 2;;
				-t) add $3 ".timels"; shift 3;;
			esac;;
		-r)
			case "$2" in
				-p) remove $3 ".pathls"; shift 3;;
				-f) remove $3 ".filels"; shift 3;;
				-t) remove $3 ".timels"; shift 3;;
			esac;;
		-l)	
			case "$2" in
				-P) list ".pathls"; shift 2;;
				-F) list ".filels"; shift 2;;
				-T) list ".timels"; shift 2;;
			esac;;
		--now)	echo "Watch now"; shift;;
		--version)	version; shift;;
		--help)		help; shift;;
		--) shift; break;;
		*)	echo "Internal error!"
			exit 1;;
	esac
done

# Clean up
if [ -e .tmplist ]
then
	rm .tmplist
fi

exit 0
