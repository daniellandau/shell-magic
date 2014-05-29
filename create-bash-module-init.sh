#!/bin/bash 
module() { eval `/opt/modules/3.2.6.7/bin/modulecmd bash $*`; }

# The upper is for creating a file with modules as they are when running.
# To do it with modules at login time replace the top two lines with just:

#!/bin/bash -l

echo 'for m in $(module list -t 2>&1); do module unload $m; done'
echo 'module load craype-interlagos'

for m in $(module list -t 2>&1 | egrep -e 'modules|Base-opts|PrgEnv-cray|pbs|cray-mpich2' | tr '\n' ' ')
do
  echo module load $m
done
