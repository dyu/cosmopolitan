#!/bin/sh

set -e

[ -e o ] || make -j8 -O

DIR=cosmopolitan

mkdir -p dist/$DIR
cp o/ape/ape.lds o/ape/ape.o o/libc/crt/crt.o o/cosmopolitan.a o/cosmopolitan.h dist/$DIR

# build example
[ "$1" = "1" ] && echo 'Compiling examples/hello3.c to dist/hello3.com' && \
gcc -g -Os -static -fno-pie -no-pie -mno-red-zone -nostdlib -nostdinc \
  -fno-omit-frame-pointer -pg -mnop-mcount \
  -o dist/hello3.com.dbg examples/hello3.c \
  -Wl,--gc-sections -fuse-ld=bfd -Wl,-T,dist/$DIR/ape.lds \
  -include dist/$DIR/cosmopolitan.h -I. \
  dist/$DIR/crt.o dist/$DIR/ape.o dist/$DIR/cosmopolitan.a && \
objcopy -S -O binary dist/hello3.com.dbg dist/hello3.com

cd dist
[ -e $DIR.tar.gz ] && rm $DIR.tar.gz
tar -cvzf $DIR.tar.gz $DIR

