#!/bin/zsh

set -eu

PYTHON_HOME=${HOME}/Public/sfw/ppc64-login/Python-2.7.6

PATH=${PYTHON_HOME}/bin:${PATH}
export LD_LIBRARY_PATH=${PYTHON_HOME}/lib

export PGPLOT_DIR=${HOME}/Public/sfw/ppc64/pgplot-5.2

declare LD_LIBRARY_PATH

print "xlf:    $(which xlf)"
print "python: $(which python)"

declare PGPLOT_DIR

zparseopts c=CMAKE_ONLY f=FULL

checkfiles diffev discus kuplot

cmake_run()
{
  cmake ../code -DPGPLOT_DIR=${PGPLOT_DIR}            \
                -DCMAKE_Fortran_COMPILER=$(which xlf) \
                -DJUST_LIBS=1                         |&
         tee -a cmake.out
}

if [[ -c ${CMAKE_ONLY} ]]
then
  cmake_run
  return ${?}
fi

if [[ -n ${FULL} ]]
then
  print "FULL REBUILD!"
  pause 2
  cmake_run
  make clean || true
  rm -rf CMakeCache.txt **/CMakeFiles
  date "+%m/%d/%Y %I:%M%p" > cmake.out
  grep "errors occurred" cmake.out && return 1
fi

checkfiles CMakeCache.txt CMakeFiles

rm -fv **/*.so
sleep 1

which f2py
sleep 1

{
  make VERBOSE=1 
  make VERBOSE=1 discus_python  
} | tee make.out
