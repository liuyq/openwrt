#!/bin/bash

sudo apt-get install -y build-essential asciidoc binutils bzip2 gawk gettext  git libncurses5-dev libz-dev patch unzip zlib1g-dev  subversion git
# get all the latest package definitions defined in feeds.conf / feeds.conf.default respectively
./scripts/feeds update -a
# install symlinks of all of them into package/feeds/
./scripts/feeds install -a

# 让OpenWrt编译系统检查你的编译环境中缺失的软件包:
make defconfig
make prereq

# target/linux/ar71xx/image/tiny-tp-link.mk
# define Device/tl-wr743n-v2
#    $(Device/tplink-8mlzma)
#    BOARDNAME := TL-WR743N
#    DEVICE_PROFILE := TLWR743NV2
#    TPLINK_HWID := 0x07430102
#    CONSOLE := ttyATH0,115200
# endef
# TARGET_DEVICES += tl-wr743n-v2
# make menuconfig
# 选编译的目标系统（Atheros AR7XXX架构，profile为743NV2）：
#   Target System (Atheros AR7xxx/AR9xxx)
#   Subtarget (Devices with small flash)
#   Target Profile (TP-LINK TL-WR703N v1)
# LuCI->Collections->luci
# LuCI->Modules->Translations->Chinese (zh-cn)
# LuCI->Themes->luci-theme-openwrt
# make -j32 V=99

#bin/targets/ar71xx/tiny/openwrt-ar71xx-tiny-tl-wr743n-v2-squashfs-factory.bin

# TTL connection
# tp1-tp3，tp2-tp4，分别用飞线连接
# 从左至右依次是VCC（不接）,GND,TX,RX分别接上
# Putty终端连接，用tpl中断，打开tftp服务，网线接在任意一个lan口，bin包放在tftp目录下
# 命令如下
# tftp 0x80800000 ***.bin
# erase 0x9f020000 +0x3c0000
# cp.b 0x80800000 0x9f020000 0x3c0000
# bootm 0x9f020000
# 自动重启就好了
# 重新刷好了
# TP1->RX <-> ttl green
# TP2->TX <-> ttl white

# WAN is the eth0 inteface, connect the wan and pc with internet cable,
# set PC network interface with ifconfit eth1 192.168.1.2, then you could login
# the router via ssh root@192.168.1.1 or telnet root@192.168.1.1 for the first time
#####
# OpenWrt Configuration
# https://openwrt.org/zh-cn/doc/howto/basic.config
# The UCI System
# https://openwrt.org/docs/guide-user/base-system/uci
# Quick Start guide - LEDE Installation
# https://openwrt.org/playground/qsg_lede_installation_guide?s[]=internet&s[]=connection
# Switch Documentation
# https://wiki.openwrt.org/doc/uci/network/switch
# Internet Connection
# https://openwrt.org/docs/guide-user/network/wan/internet.connection
# WiFi /etc/config/wireless
# https://openwrt.org/docs/guide-user/network/wifi/basic
# https://wiki.openwrt.org/doc/uci/wireless

config wifi-device 'radio0'
    option type 'mac80211'
    option channel '11'
    option hwmode '11g'
    option path 'platform/ar933x_wmac'
    option htmode 'HT20'
    option disabled '0'

config wifi-iface 'default_radio0'
option device 'radio0'
    option network 'lan'
    #option mode 'ap'
    #option ssid 'OpenWrt'
    #option encryption 'none'
    option mode sta
    option ssid ipad
    option encryption psk
    option key 20120723

root@OpenWrt:~# ifconfig
br-lan    Link encap:Ethernet  HWaddr 14:E6:E4:3C:2B:A0
          inet addr:192.168.1.1  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fd58:bf23:4c39::1/60 Scope:Global
          inet6 addr: fe80::16e6:e4ff:fe3c:2ba0/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:4075 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2171 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:434709 (424.5 KiB)  TX bytes:323511 (315.9 KiB)

eth0      Link encap:Ethernet  HWaddr 14:E6:E4:3C:2B:A0
          inet addr:192.168.0.111  Bcast:192.168.0.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3187 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2137 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:928105 (906.3 KiB)  TX bytes:327351 (319.6 KiB)
          Interrupt:4

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:691 errors:0 dropped:0 overruns:0 frame:0
          TX packets:691 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1
          RX bytes:49820 (48.6 KiB)  TX bytes:49820 (48.6 KiB)

wlan0     Link encap:Ethernet  HWaddr 14:E6:E4:3C:2B:A0
          inet6 addr: fe80::16e6:e4ff:fe3c:2ba0/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1391 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1206 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:167584 (163.6 KiB)  TX bytes:195478 (190.8 KiB)

root@OpenWrt:~# cat /etc/config/network

config interface 'loopback'
	option ifname 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config globals 'globals'
	option ula_prefix 'fd58:bf23:4c39::/48'

config interface 'lan'
	option type 'bridge'
	option ifname 'eth1'
	option proto 'static'
	option ipaddr '192.168.1.1'
	option netmask '255.255.255.0'
	option ip6assign '60'

config interface 'wan'
        option ifname 'eth0'
        option proto 'dhcp'

root@OpenWrt:~# cat /etc/config/wireless

config wifi-device 'radio0'
	option type 'mac80211'
	option channel '11'
	option hwmode '11g'
	option path 'platform/ar933x_wmac'
	option htmode 'HT20'
	option disabled '0'

config wifi-iface 'default_radio0'
	option device 'radio0'
	option network 'lan'
	option mode 'ap'
	option ssid 'OpenWrt'
	option encryption 'none'
        #option mode sta
        #option ssid ipad
        #option encryption psk
        #option key 20120723
root@OpenWrt:~# /etc/init.d/network reload

opkg update
opkg install luci
/etc/init.d/uhttpd start


https://en.code-bude.net/2013/02/16/how-to-increase-storage-on-tp-link-wr703n-with-extroot/

https://wiki.openwrt.org/doc/howto/generic.sysupgrade
