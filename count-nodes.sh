#!/bin/bash
cnselect -e label0.eq.INTELSB | 
(IFS=$',';
read input;
for pair in $input;
do
  echo $pair |
  (IFS='-';
  read -r first second;
  echo $((second - first + 1)) );
done) |
gawk '{sum += $1;}
END {printf "Number of SB nodes is: %s\n", sum;}'

