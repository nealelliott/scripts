#!/bin/bash

rec() {
	if [ $1 -lt $2 ]
	then
		echo $1
		rec $(expr $1 + $3) $2 $3
	fi
}

if [ $# -ne 2 ]
then
	echo "usage $0 <max number> <base>"
else

	rec 0 $1 $2 
fi
