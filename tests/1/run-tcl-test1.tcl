#!/bin/bash -e

TURBINE_HOME=${HOME}/sfw/turbine
export TCLLIBPATH="${TURBINE_HOME}/lib ${PWD}"

tclsh ./tcl-test1.tcl
