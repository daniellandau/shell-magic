#!/bin/bash

i=0;
for f in $(head -n 2 movie.* | sed -n -e '/movie/ {N;N;s/\n/ /g;p;}' | sort -k 8 -g | cut -d' ' -f2); 
do
  $1 mv $f tmp_movie.$(printf "%03d" $i).xyz; 
  i=$((i+1));
done

for f in tmp_*
do
     $1	mv $f ${f/tmp_/}
done
