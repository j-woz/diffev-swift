#!/bin/zsh

set -eu

PYTHON_HOME=${HOME}/Public/sfw/ppc64-login/Python-2.7.6

PATH=${PYTHON_HOME}/bin:${PATH}
export LD_LIBRARY_PATH=${PYTHON_HOME}/lib

export PGPLOT_DIR=${HOME}/Public/sfw/ppc64/pgplot-5.2

declare LD_LIBRARY_PATH

export CC=powerpc64-bgq-linux-gcc CXX=powerpc64-bgq-linux-g++
print "python: $(which python)"

declare PGPLOT_DIR

zparseopts c=CMAKE_ONLY f=FULL v=VERBOSE

checkfiles diffev discus kuplot

# FORTRAN=powerpc64-bgq-linux-gfortran
FORTRAN=bgxlf

cmake_run()
{
  cmake ../code -DPGPLOT_DIR=${PGPLOT_DIR}            \
                -DCMAKE_Fortran_COMPILER=$FORTRAN \
                -DJUST_LIBS=1                         |&
         tee -a cmake.out
  print "cmake result:" $pipestatus         
}

if [[ -n ${VERBOSE} ]] 
then 
  set -x 
fi

if [[ -c ${CMAKE_ONLY} ]]
then
  cmake_run
  return ${?}
fi

if [[ -n ${FULL} ]]
then
  print "FULL REBUILD!"
  pause 2
  make clean || true
  rm -rf CMakeCache.txt **/CMakeFiles
  date "+%m/%d/%Y %I:%M%p" > cmake.out
  cmake_run
  print "cmake done."
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
print "make result: $pipestatus"
