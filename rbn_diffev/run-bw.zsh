#!/bin/zsh

set -e

DIFFUSE=${HOME}/proj/diffuse/build

if [[ ${#*} != 2 ]]
then
  echo "usage: run-bw <procs> <cycles>"
  exit 1
fi

PROCS=$1
CYCLES=$2

export QUEUE=${QUEUE:-low}
export PPN=${PPN:-3}
# Wall time in minutes
WT=${WT:-30}

# Logging/debugging off by default:
export TURBINE_LOG=${TURBINE_LOG:-0}
export TURBINE_DEBUG=${TURBINE_DEBUG:-0}
export ADLB_DEBUG=${ADLB_DEBUG:-0}

export PYTHONPATH=${PYTHONPATH}:${PWD}

set -u

# Create directories required by the application:
mkdir -p CALC DIFFEV FINAL

cp -uv ${DIFFUSE}/**/*.so .

echo "STC..."
stc -pu refine.swift
echo "done."

# Must pick up user liblapack.so, libblas.so

declare QUEUE

export BLUE_WATERS=true

turbine-aprun-run.zsh -t 00:${WT}:00 -n ${PROCS} \
  -i ${PWD}/turbine-init.sh \
  -e PYTHONPATH=${PYTHONPATH} \
  -e LD_LIBRARY_PATH=${PWD} \
  refine.tcl --cycles=${CYCLES}
