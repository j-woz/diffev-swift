#!/bin/zsh -eu

# Build procedure for Diffuse on Blue Waters

PATH=${HOME}/.local/bin:${PATH}
PATH=${HOME}/sfw/python-2.7.6/bin:${PATH}
export LD_LIBRARY_PATH=${HOME}/sfw/python-2.7.6/lib

module load gcc

rm -rf **/*.so **/*.o CMakeCache.txt **/CMakeFiles

cmake -DPGPLOT_DIR=${HOME}/sfw/pgplot-5.2 \
      -DCMAKE_SOURCE_DIR=${PWD}/../code   \
      -DCMAKE_BINARY_DIR=$PWD             \
  ../code >& cmake.out

make >& make.out



