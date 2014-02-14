#!/bin/bash -e

DIFFEV_SWIFT=${HOME}/proj/diffev/rbn_diffev

cd ${TURBINE_OUTPUT}

cp -v ${DIFFEV_SWIFT}/*.mac .
cp -rv ${DIFFEV_SWIFT}/{CELL,DATA} .
mkdir -pv CALC DIFFEV FINAL
