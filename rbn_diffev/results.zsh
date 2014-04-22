#!/bin/zsh

# RESULTS.ZSH
# Extracts latest results from Turbine output directory

N=$1

checkvars N

DIRS=( $( print -l ~/turbine-output/2014/*/*/*/*/* | sort | tail -${N} ) )

# declare DIRS

set -eu

for D in ${DIRS}
do
  print "TO=${D}"
  [[ -f ${D}/jobid.txt ]] && cat ${D}/jobid.txt
  if [[ -f ${D}/turbine-cobalt.log ]]
  then
    grep PROCS ${D}/turbine-cobalt.log
  fi
  grep ppn ${D}/turbine-aprun.sh
  OUTPUT=$( print ${D}/output*.out || true )
  if [[ ${OUTPUT} != "" ]]
  then
    grep "pop_c" ${OUTPUT}
    grep "Total Elapsed" ${OUTPUT}
  else
    print "No output."
  fi
  if grep -q APPL ${OUTPUT}
  then
    print "Check for APPL errors!"
  fi
  print
done

