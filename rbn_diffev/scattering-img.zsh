#!/bin/zsh

# Run from rbn_diffev directory

set -e

DIFFUSE=${HOME}/proj/x86/diffuse/build
DIFFEV=${HOME}/proj/x86/diffev/rbn_diffev

KUPLOT=${DIFFUSE}/kuplot/prog/kuplot

export LD_LIBRARY_PATH=/gpfs/mira-fs0/software/x86_64/compilers/gcc/4.8.1/lib64

if [[ ${#*} != 2 ]]
then
  echo "usage: scattering-img <DIR> <N>"
  exit 1
fi

set -u

DIR=$1
N=$2

declare DIR N

IMGS=()

set -x

push ${DIR}
{
  integer -Z 3 i
  for (( i=1 ; i<=N ; i++))
  do
    PNG=filename-${i}.png
    sed "s/plot/save png, ${PNG}/" ksingle.mac > \
      ksingle-${i}.mac
    print "@ksingle-${i}.mac ${i}"
    IMGS+=${PWD}/${PNG}
  done
  print "exit"
} > ksingle_all.mac

${KUPLOT} ksingle_all.mac
pop

mkdir -pv imgs
cp -uv ${IMGS} imgs
