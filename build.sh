#!/bin/bash -ex

make dirclean
./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
make prereq
make -j16 V=99 2>&1 |tee build.log
