#!/bin/zsh


set -eu

cd imgs

convert -loop 0 -delay 10 filename-*.png movie.mpg

