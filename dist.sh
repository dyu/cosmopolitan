#!/bin/sh

set -e

REL=rel

[ -n "$1" ] && REL=$1

REL_DIR=o/$REL

[ -e $REL_DIR ] || ./build/bootstrap/make.com -j4 MODE=$REL

DIR=cosmopolitan

mkdir -p dist/$DIR
cp $REL_DIR/ape/ape.lds $REL_DIR/ape/ape.o $REL_DIR/ape/ape-no-modify-self.o $REL_DIR/ape/ape-copy-self.o $REL_DIR/libc/crt/crt.o $REL_DIR/cosmopolitan.a o/cosmopolitan.h dist/$DIR

# build example
EXAMPLE=hello3
[ -n "$2" ] && EXAMPLE=$2
echo "Compiling examples/$EXAMPLE.c to dist/$EXAMPLE.com"

#gcc -g -Os -static -fno-pie -no-pie -mno-red-zone -nostdlib -nostdinc \
#  -fno-omit-frame-pointer -pg -mnop-mcount \
#  -o dist/hello3.com.dbg examples/hello3.c \
#  -Wl,--gc-sections -fuse-ld=bfd -Wl,-T,dist/$DIR/ape.lds \
#  -include dist/$DIR/cosmopolitan.h -I. \
#  dist/$DIR/crt.o dist/$DIR/ape.o dist/$DIR/cosmopolitan.a

gcc -g -Os -static -nostdlib -nostdinc -fno-pie -no-pie -mno-red-zone \
  -fno-omit-frame-pointer -pg -mnop-mcount -mno-tls-direct-seg-refs \
  -o dist/$EXAMPLE.com.dbg examples/$EXAMPLE.c -fuse-ld=bfd -Wl,-T,dist/$DIR/ape.lds -Wl,--gc-sections \
  -include dist/$DIR/cosmopolitan.h -I. \
  dist/$DIR/crt.o dist/$DIR/ape-no-modify-self.o dist/$DIR/cosmopolitan.a

objcopy -S -O binary dist/$EXAMPLE.com.dbg dist/$EXAMPLE.com

cd dist
[ -e $DIR.tar.gz ] && rm $DIR.tar.gz
tar -cvzf $DIR.tar.gz $DIR
