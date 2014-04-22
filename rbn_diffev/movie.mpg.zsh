#!/bin/zsh

# Make a movie from a set of PNG images

set -eu

cd imgs

convert -loop 0 -delay 10 filename-*.png movie.mpg

