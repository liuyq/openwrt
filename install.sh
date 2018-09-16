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

### install tftp server on ubuntu
## https://help.ubuntu.com/community/TFTP
sudo apt-get install tftpd-hpa
sudo service tftpd-hpa status
sudo service tftpd-hpa restart
The default configuration file for tftpd-hpa is /etc/default/tftpd-hpa.
The default root directory where files will be stored is /var/lib/tftpboot.

## ttl tftp flash
## cp sudo cp  bin/targets/ar71xx/tiny/openwrt-ar71xx-tiny-tl-wr743n-v2-squashfs-factory.bin /var/lib/tftpboot/openwrt-new.bin
tftpboot 0x80000000 wr743nv2.bin
tftpboot 0x80000000 openwrt.bin
tftpboot 0x80000000 openwrt-new.bin

erase 0x9f020000 +0x3c0000
cp.b 0x80000000 0x9f020000 0x3c0000
bootm 0x9f020000

# LuCI Essentials
# https://openwrt.org/zh-cn/doc/howto/luci
enable ExBoot, and install luci on USB Drive

==============================
root@OpenWrt:~# opkg list
base-files - 188-r6693-ec1d7b9
busybox - 1.28.3-1
dnsmasq - 2.79-3
dropbear - 2017.75-5
firewall - 2018-04-05-35b3e74a-2
fstools - 2018-02-11-3d239815-1
fwtool - 1
hostapd-common - 2018-04-09-fa617ee6-1
ip6tables - 1.6.2-1
iptables - 1.6.2-1
iw - 4.14-1
iwinfo - 2018-02-15-223e09bf-1
jshn - 2018-04-12-6eff829d-1
jsonfilter - 2018-02-04-c7e938d6-1
kernel - 4.9.91-1-d36eb51ce7cd3df5e7d972b30cc4c8ea
kmod-ath - 4.9.91+2017-11-01-4
kmod-ath9k - 4.9.91+2017-11-01-4
kmod-ath9k-common - 4.9.91+2017-11-01-4
kmod-cfg80211 - 4.9.91+2017-11-01-4
kmod-gpio-button-hotplug - 4.9.91-2
kmod-ip6tables - 4.9.91-1
kmod-ipt-conntrack - 4.9.91-1
kmod-ipt-core - 4.9.91-1
kmod-ipt-nat - 4.9.91-1
kmod-lib-crc-ccitt - 4.9.91-1
kmod-mac80211 - 4.9.91+2017-11-01-4
kmod-nf-conntrack - 4.9.91-1
kmod-nf-conntrack6 - 4.9.91-1
kmod-nf-ipt - 4.9.91-1
kmod-nf-ipt6 - 4.9.91-1
kmod-nf-nat - 4.9.91-1
kmod-nf-reject - 4.9.91-1
kmod-nf-reject6 - 4.9.91-1
kmod-nls-base - 4.9.91-1
kmod-ppp - 4.9.91-1
kmod-pppoe - 4.9.91-1
kmod-pppox - 4.9.91-1
kmod-slhc - 4.9.91-1
kmod-usb-core - 4.9.91-1
kmod-usb-ehci - 4.9.91-1
kmod-usb-ledtrig-usbport - 4.9.91-1
kmod-usb-ohci - 4.9.91-1
kmod-usb2 - 4.9.91-1
lede-keyring - 2017-01-20-a50b7529-1
libblobmsg-json - 2018-04-12-6eff829d-1
libc - 1.1.19-1
libgcc - 7.3.0-1
libip4tc - 1.6.2-1
libip6tc - 1.6.2-1
libiwinfo - 2018-02-15-223e09bf-1
libjson-c - 0.12.1-1
libjson-script - 2018-04-12-6eff829d-1
libnl-tiny - 0.1-5
libpthread - 1.1.19-1
libubox - 2018-04-12-6eff829d-1
libubus - 2018-01-16-5bae22eb-1
libuci - 2018-03-24-5d2bf09e-1
libuclient - 2017-11-02-4b87d831-1
libxtables - 1.6.2-1
logd - 2018-02-14-128bc35f-1
mtd - 21
netifd - 2018-04-03-3dc8c916-1
odhcp6c - 2018-05-04-474b5a3a-11
odhcpd-ipv6only - 1.5-1
opkg - 2017-12-07-3b417b9f-2
ppp - 2.4.7-12
ppp-mod-pppoe - 2.4.7-12
procd - 2018-03-28-dfb68f85-1
swconfig - 11
uboot-envtools - 2015.10-1
ubox - 2018-02-14-128bc35f-1
ubus - 2018-01-16-5bae22eb-1
ubusd - 2018-01-16-5bae22eb-1
uci - 2018-03-24-5d2bf09e-1
uclient-fetch - 2017-11-02-4b87d831-1
usign - 2015-07-04-ef641914-1
wireless-regdb - 2017-10-20-4343d359
wpad-mini - 2018-04-09-fa617ee6-1
root@OpenWrt:~# 
========================================

## compiling and ttl recovery for TL-WR743N V2

设备：TPLINK WR743N v2
DRAM:  32 MB
Flash:  4 MB
CPU revision is: 00019374 (MIPS 24Kc)
SoC: Atheros AR9330 rev 1
Clocks: CPU:400.000MHz, DDR:400.000MHz,
http://blog.iytc.net/wordpress/?s=WR743N
