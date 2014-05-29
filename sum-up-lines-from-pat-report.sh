#!/bin/bash
gawk -F'|' '
  /'$2'/,/=============/ {
    if ($0 ~ /line.[[:digit:]]+/) {
      line = strtonum(substr($8,6));
      samples = $5;
      if (line >= '$3' && line <= '$4') {
        sum += samples;
        /*print;*/
      }
    }
  }
  END {
    print "sum of samples is:", sum;
  }' $1

# e.g. $1 == /cray/css/users/daf/MD/report.intel.16.16.32.T
