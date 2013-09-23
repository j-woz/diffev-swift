#!/bin/bash -e

set -ux

TCL_INCLUDE=/home/wozniak/sfw/tcl-8.6.0/include

FFLAGS="-g -O0"

# Wrap the Fortran for Swift
fortwrap.py test1.f90 
swig -c++ -module test FortFuncs.h
sed -i '11i#include "FortFuncs.h"' FortFuncs_wrap.cxx

# Compile everything
gfortran -c ${FFLAGS} test1.f90
g++      -c -fPIC -I . FortFuncs.cpp
g++      -c -fPIC -I ${TCL_INCLUDE} FortFuncs_wrap.cxx


g++ -shared -o libtest.so FortFuncs_wrap.o FortFuncs.o test1.o \
    -lgfortran

tclsh make-package.tcl > pkgIndex.tcl
