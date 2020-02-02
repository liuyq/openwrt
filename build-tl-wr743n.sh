#!/bin/bash -ex


make dirclean
sudo apt-get install -y build-essential asciidoc binutils bzip2 gawk gettext  git libncurses5-dev libz-dev patch unzip zlib1g-dev  subversion git
# get all the latest package definitions defined in feeds.conf / feeds.conf.default respectively
./scripts/feeds update -a
# install symlinks of all of them into package/feeds/
#./scripts/feeds install -a
./scripts/feeds install -a -p packages

#make defconfig
make prereq

#make menuconfig
make -j16 V=99 2>&1 |tee make-tl-wr743n.log

exit
## P.1 /usr/bin/ld: zconf.tab.o: relocation R_X86_64_32S against symbol `symbol_yes' can not be used when making a PIE object; recompile with -fPIC
##      08:51:07 liuyq:openwrt$ make dirclean -j1 V=s
##      make[1]: Entering directory '/home/liuyq/data/openwrt/scripts/config'
##      /usr/bin/ld: zconf.tab.o: relocation R_X86_64_32S against symbol `symbol_yes' can not be used when making a PIE object; recompile with -fPIC
##      /usr/bin/ld: final link failed: nonrepresentable section on output
##      collect2: error: ld returned 1 exit status
##      make[1]: *** [<builtin>: conf] Error 1
##      make[1]: Leaving directory '/home/liuyq/data/openwrt/scripts/config'
##      make: *** [/home/liuyq/data/openwrt/include/toplevel.mk:111: scripts/config/conf] Error 2
##      08:51:31 liuyq:openwrt$
## Retry after running make -C scripts/config/ clean
