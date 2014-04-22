#!/bin/zsh -e

if [[ ${#*} != 3 ]]
then
  print "usage: run <PROCS> <CYCLES> <POP_C>"
  exit 1
fi

PROCS=$1
CYCLES=$2
export POP_C=$3

# Create directories required by the application:
mkdir -p CALC DIFFEV FINAL

echo "STC..."
stc -pu refine.swift
echo "STC done."

# Logging/debugging off by default:
export TURBINE_LOG=${TURBINE_LOG:-1}
export TURBINE_DEBUG=${TURBINE_DEBUG:-0}
export ADLB_DEBUG=${ADLB_DEBUG:-0}

# Create an output file with an unused random number
REFINE_OUT=""
while (( 1 ))
do
  REFINE_OUT=refine-${RANDOM}.out
  [[ ! -f ${REFINE_OUT} ]] && break
done

export PYTHONPATH=${PYTHONPATH}:${PWD}
export LD_LIBRARY_PATH=${PWD}

{
  print ${REFINE_OUT}
  date
  which python
  print "PYTHONPATH: ${PYTHONPATH}"
  print
} >& ${REFINE_OUT}

m4 < diffev_setup.mac.m4 > diffev_setup.mac
echo "Turbine..."
turbine -l -n ${PROCS} refine.tcl --cycles=${CYCLES} |& tee -a ${REFINE_OUT}
print "logged to: ${REFINE_OUT}"

if grep -q APPL ${REFINE_OUT}
then
  print "FOUND ERRORS!"
  return 1
fi

return 0
