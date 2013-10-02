#!/bin/bash -e

stc -pu evs.swift
export PYTHONPATH=${PYTHONPATH}:${PWD}
# Disable debugging: 
# export TURBINE_LOG=0 TURBINE_DEBUG=0
turbine evs.tcl
