#!/bin/bash -e

if [[ ${#*} != 2 ]]
then
  echo "usage: run <PROCS> <CYCLES>"
  exit 1
fi

PROCS=$1
CYCLES=$2

# Create directories required by the application:
mkdir -p CALC DIFFEV FINAL

stc -pu refine.swift

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
  echo ${REFINE_OUT}
  date
  which python
  echo "PYTHONPATH: ${PYTHONPATH}"
  echo
} >& ${REFINE_OUT}

turbine -l -n ${PROCS} refine.tcl --cycles=${CYCLES} |& tee -a ${REFINE_OUT}
echo "logged to: ${REFINE_OUT}"

if grep -q APPL ${REFINE_OUT}
then
  echo "FOUND ERRORS!"
  exit 1
fi
