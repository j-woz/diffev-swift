#!/bin/bash -e

stc -pu refine.swift
export PYTHONPATH=${PYTHONPATH}:${PWD}
# Disable debugging: 
export TURBINE_LOG=0 TURBINE_DEBUG=0
turbine -n 4 refine.tcl

