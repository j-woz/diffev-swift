#!/bin/zsh

set -eu

for f in diffev discus kuplot CMakeCache.txt CMakeFiles
do
  if [[ ! -e ${f} ]]
  then
    print "Could not find: ${f}"
    exit 1
  fi
done

PATH=${HOME}/.local/bin:${PATH}
PATH=${HOME}/sfw/python-2.7.6/bin:${PATH}
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HOME}/sfw/python-2.7.6/lib

rm -fv **/*.so
sleep 1

make VERBOSE=1
