#!/bin/bash

n=0
while [ 1 ]
do
    clear
    qstat -u landau
    echo waited $((n++))*5s = $( echo "$n * 5 - 5" | bc -lq )s
    sleep 5
done
