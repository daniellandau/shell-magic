#!/usr/bin/env python
from build_gromacs.module import module
import argparse
import os
import os.path
import sys
from subprocess import Popen, PIPE

# e.g., the three commands:

# CFLAGS="-hprototype_intrinsics -hnoomp" CXXFLAGS="-hprototype_intrinsics -hnoomp" CC=cc CXX=CC aprun -n1 cmake ../gromacs/ -DGMX_PREFER_STATIC_LIBS=ON -DGMX_BUILD_UNITTESTS=OFF -DCMAKE_INSTALL_PREFIX=/lus/scratch/dlandau/gromacs/asd -DCMAKE_NO_BUILTIN_CHRPATH:BOOL=ON -DGMX_GPU=OFF -DGMX_FFT_LIBRARY=fftw3 -DGMX_CPU_ACCELERATION=SSE4.1 -DC_COMPILER_VERSION=8.2.1 -DCXX_COMPILER_VERSION=8.2.1 -DGMX_OPENMP=OFF -C/home/users/dlandau/scripts/cmake-cache-init.txt 
# aprun -n1 -d32 make -j 32
# aprun -n1 make install

# fftw needs to be installed at the prefix for the above commands to work, compile it with ./configure --prefix=[prefix] --enable-single && make install

#os.environ['HOME'] = '/lus/scratch/dlandau'

def is_empty(dir):
  return os.listdir(dir) in [[],['.git']]

parser = argparse.ArgumentParser()
parser.add_argument('-f', '--force', action="store_true")
parser.add_argument('--PrgEnv', choices = ['cray','gnu'], default='cray')
parser.add_argument('--prefix', default=("%s/gromacs/%s" % \
 (os.environ['HOME'], os.getcwd().split('/')[-1])))
parser.add_argument('--noomp', action="store_true")
parser.add_argument('--notmpi', action="store_true")
parser.add_argument('--mpi', action="store_true")
parser.add_argument('--sse41', action="store_true")
parser.add_argument('--avx256', action="store_true")
parser.add_argument('--hfp4', action="store_true")
parser.add_argument('--O3', action="store_true")
parser.add_argument('--perftools', action="store_true")
parser.add_argument('-U', action="append")

args = parser.parse_args()

cmake_defines = ['-DGMX_PREFER_STATIC_LIBS=ON', '-DGMX_BUILD_UNITTESTS=OFF', \
  '-DCMAKE_INSTALL_PREFIX='+args.prefix,\
  '-DCMAKE_NO_BUILTIN_CHRPATH:BOOL=ON', '-DGMX_GPU=OFF']
# TODO: is NO_BUILTIN_CHRPATH required?
cmake_defines.append('-DGMX_FFT_LIBRARY=fftw3')

cflags = []

if not os.path.isfile("../gromacs/CMakeLists.txt"):
  print('You should run this from a directory at the same level\n' \
    'as the gromacs directory')
  sys.exit(2)

if not args.force and not is_empty(os.getcwd()):
  print('You should run this from an empty directory (or use --force, if you'\
      ' know what you are doing)')
  sys.exit(1)

if args.notmpi:
  print("As far as I can tell, Gromacs can't be compiled without any MPI")
  print("Use real MPI (--mpi) if you want to disable threadMPI")
  sys.exit(6)
  cmake_defines.append('-DGMX_THREAD_MPI=OFF')

if args.sse41:
  cmake_defines.append('-DGMX_CPU_ACCELERATION=SSE4.1')
if args.avx256:
  cmake_defines.append('-DGMX_CPU_ACCELERATION=AVX_256')

if args.PrgEnv == 'cray':
  cmake_defines.append('-DC_COMPILER_VERSION=8.2.1')
  cmake_defines.append('-DCXX_COMPILER_VERSION=8.2.1')
  if args.hfp4:
    cflags.append('-hfp4')
  cflags.append('-hprototype_intrinsics')
  if args.O3:
    cflags.append('-O3')

if args.noomp:
  cmake_defines.append('-DGMX_OPENMP=OFF')
  if args.PrgEnv == 'cray':
    cflags.append('-hnoomp')

if args.mpi:
  cmake_defines.append('-DGMX_MPI=ON')

if args.U:
  cmake_undefines = ['-U'+arg for arg in args.U]
else:
  cmake_undefines = []

def getCurrentEnv():
  return filter(lambda x: 'PrgEnv' in x , module('list', '-t').splitlines())[0]

currentEnv = getCurrentEnv()
print('Current Programming Environment is: '+currentEnv)

module('swap', currentEnv, 'PrgEnv-'+args.PrgEnv)
module('load', 'cmake')
if args.perftools:
  module('load', 'perftools')
os.environ['CRAY_NPU_ACCESS'] = '0' # required, see Bug #803906

currentEnv = getCurrentEnv()
print('Current Programming Environment after swapping is: '+currentEnv)

os.environ['CC'] = 'cc'
os.environ['CXX'] = 'CC'
os.environ['F77'] = 'ftn'

def follow_run(command_list):
  os.system(" ".join(command_list))

os.environ['CFLAGS']   = ' '.join(cflags)
os.environ['CXXFLAGS'] = ' '.join(cflags)

fftw_prefix = os.environ['HOME']+'/gromacs/'+os.getcwd().split('/')[-1]
if not os.path.exists(fftw_prefix):
  old_dir = os.getcwd()
  if args.PrgEnv == "cray":
    os.chdir(os.environ['HOME']+'/src/cce-fftw-3.3.3')
  elif args.PrgEnv == "gnu":
    os.chdir(os.environ['HOME']+'/src/gcc-fftw-3.3.3')
  follow_run(['./configure', '--enable-single', \
    '--prefix='+fftw_prefix])
  follow_run(['make','install'])
  os.chdir(old_dir)

follow_run(['aprun', '-n1', 'cmake', '../gromacs', '-C%s/cmake-cache-init.txt' \
    % os.path.dirname(__file__)] + \
    cmake_defines + cmake_undefines)

follow_run(['aprun', '-n1', '-d16', 'make', '-j16'])
follow_run(['make', 'install'])
