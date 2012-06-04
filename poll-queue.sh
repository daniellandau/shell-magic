#!/bin/bash

(date; qstat | awk '$5 = "Q" {print $0;}' | sed -n -e '1,/landau/p' | wc -l) | tee -a $WRKDIR/queue-stat

