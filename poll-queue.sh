#!/bin/bash
(date; echo $(qstat | awk '$5 == "Q" {print $0;}' | sed -n -e '1,/landau/p' | wc -l) - 1 | bc -lq) | tee -a $WRKDIR/queue-stat
