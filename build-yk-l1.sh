#!/bin/bash -ex


#make dirclean
sudo apt-get install -y build-essential asciidoc binutils bzip2 gawk gettext  git libncurses5-dev libz-dev patch unzip zlib1g-dev  subversion git
# get all the latest package definitions defined in feeds.conf / feeds.conf.default respectively
./scripts/feeds update -a
# install symlinks of all of them into package/feeds/
./scripts/feeds install -a
./scripts/feeds install -a -p packages

make defconfig
make prereq

#make menuconfig
# grep -irn youku-yk1 target/
# target/linux/ramips/image/mt7620.mk
# target/linux/ramips/dts/YOUKU-YK1.dts
# target/linux/ramips/base-files/lib/ramips.sh
# target/linux/ramips/base-files/etc/board.d/01_leds
# target/linux/ramips/base-files/etc/board.d/02_network

# Target System (MediaTek Ralink MIPS)
# Subtarget (MT7620 based boards)
# Target Profile (YOUKU YK1)

time make -j16 V=99 2>&1 |tee make-yk-l1-19.07.log
# ./build_dir/target-mipsel_24kc_musl/linux-ramips_mt7620/tmp/openwrt-ramips-mt7620-youku-yk1-squashfs-sysupgrade.bin
# ./bin/targets/ramips/mt7620/openwrt-ramips-mt7620-youku-yk1-squashfs-sysupgrade.bin


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
