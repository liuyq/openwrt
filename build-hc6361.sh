#!/bin/bash

make dirclean
sudo apt-get install -y build-essential asciidoc binutils bzip2 gawk gettext  git libncurses5-dev libz-dev patch unzip zlib1g-dev  subversion git
# get all the latest package definitions defined in feeds.conf / feeds.conf.default respectively
./scripts/feeds update -a
# install symlinks of all of them into package/feeds/
./scripts/feeds install -a

#make defconfig
make prereq

#make menuconfig
make -j16 V=99
