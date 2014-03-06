#!/bin/zsh

# Set cmake to use f2py -L Python/lib

set -e

DIFFUSE=${HOME}/proj/x86/diffuse/build

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
export LD_LIBRARY_PATH=${PWD}:${HOME}/Public/sfw/x86/Python-2.7.6/lib:/gpfs/mira-fs0/software/x86_64/compilers/gcc/4.8.1/lib64
# :${HOME}/.local/lib/python/
export PATH=${HOME}/Public/sfw/x86/Python-2.7.6/bin:${PATH}

set -u

# Create directories required by the application:
mkdir -p CALC DIFFEV FINAL

cp -uv ${DIFFUSE}/**/*.so .

echo "STC..."
stc -pu refine.swift
echo "done."

# Must pick up user liblapack.so, libblas.so

declare QUEUE

export MODE=cluster
export PROJECT=ExM
export ADLB_PRINT_TIME=1

# Substitute on POP_C
m4 < diffev_setup.mac.m4 > diffev_setup.mac

turbine-cobalt-run.zsh -t 00:${WT}:00 -n ${PROCS} \
  -i ${PWD}/turbine-init.sh \
  -e PYTHONPATH=${PYTHONPATH} \
  -e LD_LIBRARY_PATH=${LD_LIBRARY_PATH} \
  refine.tcl --cycles=${CYCLES}
