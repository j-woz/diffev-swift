#!/bin/zsh

# Make a movie from a set of PNG images

set -eu

cd imgs

print -l *.png > png.list

mencoder mf://@png.list -mf w=800:h=600:fps=1:type=png \
  -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy \
  -o diffev.avi
