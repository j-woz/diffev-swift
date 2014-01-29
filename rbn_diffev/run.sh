#!/bin/bash -e

if [[ ${#*} != 1 ]]
then
  echo "requires argument: cycles"
  exit 1
fi

CYCLES=$1

# Create directories required by the application:
mkdir -p CALC DIFFEV FINAL

stc -pu refine.swift

# Logging/debugging off by default:
export TURBINE_LOG=${TURBINE_LOG:-0}
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

turbine -l -n 3 refine.tcl --cycles=${CYCLES} |& tee ${REFINE_OUT}
echo "logged to: ${REFINE_OUT}"
