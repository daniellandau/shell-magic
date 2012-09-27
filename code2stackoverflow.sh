#!/bin/bash
paste <(while true; do echo "    "; done | head -n $(wc -l $1 | cut -d' ' -f1)) $1 | sed -e 's/	//' 

