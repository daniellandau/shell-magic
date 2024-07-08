#!/bin/bash

if [[ $# -ne 1 ]]
then
  echo "Usage: $0 <filename containing just a single integer number>"
  exit 1
fi

filenumber=$(cat "$1" | sed -e 's/\s//g')
if [[ ! $filenumber =~ -?[[:digit:]]+ ]]
then
  echo "Error: \"$filenumber\" is not an integer"
  exit 2
fi

newnumber=$((filenumber + 1))
echo $newnumber > "$1"
