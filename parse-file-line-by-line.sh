#!/bin/bash

exec 6<&0
cat dlandau/src/defs.h dlandau/src/defs.h.bak >asd
exec 0<asd

read -r line
while [[ $? -eq 0 ]]
do
#    echo "line: $line"
    if [[ $line =~ "#define" ]]
    then
	macro=$(echo $line | cut -d' ' -f2)
	count=$(grep -c -e "$macro" dlandau/obj/*.f90 | cut -d':' -f 2 | awk  '{sum += $1;} END { print sum;}')
	echo "macro: $macro count: $count"
    fi

    read -r line
done

rm asd
exec 0<&6 6<&-