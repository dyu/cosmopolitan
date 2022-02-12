#!/bin/sh

set -e

[ -e o ] || make -j8 -O

DIR=cosmopolitan

mkdir -p $DIR
cp o/ape/ape.lds o/ape/ape.o o/libc/crt/crt.o o/cosmopolitan.a o/cosmopolitan.h $DIR
[ -e $DIR.tar.gz ] && rm $DIR.tar.gz
tar -cvzf $DIR.tar.gz $DIR

