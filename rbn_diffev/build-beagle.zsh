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

PATH=/lustre/beagle/wozniak/Public/sfw/Python-2.7.5/bin:${PATH}

rm -fv **/*.so
sleep 1

make VERBOSE=1
