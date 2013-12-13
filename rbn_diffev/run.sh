#!/bin/bash -e

mkdir -p CALC DIFFEV

stc -pu refine.swift
export PYTHONPATH=${PYTHONPATH}:${PWD}

export TURBINE_LOG=1 TURBINE_DEBUG=0

REFINE_OUT=""
while (( 1 ))
do
  REFINE_OUT=refine-${RANDOM}.out
  [[ ! -f ${REFINE_OUT} ]] && break
done

turbine -l -n 3 refine.tcl -cycles=3 |& tee ${REFINE_OUT}

