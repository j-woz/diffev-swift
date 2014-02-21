#!/bin/zsh

set -eu

PYTHON_HOME=${HOME}/Public/sfw/x86/Python-2.7.6

PATH=${HOME}/.local/bin:${PATH}
PATH=${PYTHON_HOME}/bin:${PATH}
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PYTHON_HOME}/lib:/gpfs/mira-fs0/software/x86_64/compilers/gcc/4.8.1/lib64

export PGPLOT_DIR=$HOME/sfw/x86/pgplot-5.2

zparseopts f=FULL

checkfiles diffev discus kuplot

if [[ -n ${FULL} ]]
then
  print "FULL REBUILD!"
  pause 2
  make clean || true
  rm -rf CMakeCache.txt **/CMakeFiles
  cmake ../code -DPGPLOT_DIR=$PGPLOT_DIR |& \
    tee cmake.out
  grep "errors occurred" cmake.out && return 1
fi

checkfiles CMakeCache.txt CMakeFiles

rm -fv **/*.so
sleep 1

which f2py
sleep 1

make VERBOSE=1 |& tee make.out

