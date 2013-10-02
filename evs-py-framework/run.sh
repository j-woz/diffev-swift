#!/bin/bash -e

stc -pu evs.swift
export PYTHONPATH=${PYTHONPATH}:${PWD}
turbine evs.tcl
