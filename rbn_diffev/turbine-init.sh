#!/bin/bash -e

DIFFEV_SWIFT=${HOME}/proj/x86/diffev/rbn_diffev

cd ${TURBINE_OUTPUT}

V=
# V=-v

cp ${V} ${DIFFEV_SWIFT}/*.mac .
cp ${V} -r ${DIFFEV_SWIFT}/{CELL,DATA} .
mkdir ${V} -p CALC DIFFEV FINAL
