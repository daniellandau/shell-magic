import os, string
import subprocess

if not os.environ.has_key('MODULE_VERSION'):
        os.environ['MODULE_VERSION_STACK'] = '3.2.6.7'
        os.environ['MODULE_VERSION'] = '3.2.6.7'
else:
        os.environ['MODULE_VERSION_STACK'] = os.environ['MODULE_VERSION']

os.environ['MODULESHOME'] = '/opt/modules/3.2.6.7'

if not os.environ.has_key('MODULEPATH'):
        os.environ['MODULEPATH'] = os.popen("""sed 's/#.*$//' ${MODULESHOME}/init/.modulespath | awk 'NF==1{printf("%s:",$1)}'""").readline()

if not os.environ.has_key('LOADEDMODULES'):
        os.environ['LOADEDMODULES'] = '';

def module(command, *arguments):
  pipe = subprocess.Popen(['/opt/modules/%s/bin/modulecmd' \
     % (os.environ['MODULE_VERSION']), 'python', \
      command] + list(arguments), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  exec pipe.stdout.read()
  return pipe.stderr.read()

