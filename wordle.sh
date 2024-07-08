#!/bin/bash

must=$1
anypos=$2
lettersinmust=$(echo $must | sed -e "s/[^a-z]//g")
not=$(echo $3 | sed -e "s/[$anypos$lettersinmust]//g")


buf=$(cat /usr/share/dict/words \
  |grep -E "^$must\$" \
  |grep -Ev "[A-Z']" \
  |grep -Ev "[$not]")

for (( i=0; i<${#anypos}; i++ )); do
  buf=$(echo $buf| tr ' ' '\n'|grep "${anypos:$i:1}")
done

args=("$@")
for ((i=3; i<$#; i++ )); do
  for j in 0 1 2 3 4; do
    letter=${args[$i]:$j:1}
    if [[ $letter != . ]]; then
      pattern=$(echo '.....' | sed -e "s/./$letter/$((j+1))")
      buf=$(echo $buf|tr ' ' '\n'| grep -v "$pattern")
    fi
  done
done

echo $buf
