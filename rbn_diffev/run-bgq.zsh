#!/bin/zsh

# Set cmake to use f2py -L Python/lib

set -e

DIFFUSE=${HOME}/proj/ppc64/diffuse/build

if [[ ${#*} != 3 ]]
then
  echo "usage: run-tukey <procs> <cycles> <pop_c>"
  exit 1
fi

PROCS=$1
CYCLES=$2
export POP_C=$3

export QUEUE=${QUEUE:-default}
export PPN=${PPN:-3}
# Wall time in minutes
WT=${WT:-60}

# Logging/debugging off by default:
export TURBINE_LOG=${TURBINE_LOG:-1}
export TURBINE_DEBUG=${TURBINE_DEBUG:-0}
export ADLB_DEBUG=${ADLB_DEBUG:-0}

export PYTHONPATH=${PWD}
export PYTHON=${HOME}/Public/sfw/ppc64/Python-2.7.6
export LD_LIBRARY_PATH=${PWD}:${PYTHON}/lib
export PATH=${PYTHON}/bin:${PATH}

set -u

cp -uv ${DIFFUSE}/**/*.so .

echo "STC..."
stc -pu refine.swift
echo "done."

# Must pick up user liblapack.so, libblas.so

export MODE=BGQ
export PROJECT=ExM
export QUEUE=batch
export ADLB_PRINT_TIME=1

# Substitute on POP_C
m4 < diffev_setup.mac.m4 > diffev_setup.mac

turbine-cobalt-run.zsh -t 00:${WT}:00 -n ${PROCS} \
  -i ${PWD}/turbine-init.sh \
  -e PYTHONPATH=${PYTHONPATH} \
  -e LD_LIBRARY_PATH=${LD_LIBRARY_PATH} \
  refine.tcl --cycles=${CYCLES}
