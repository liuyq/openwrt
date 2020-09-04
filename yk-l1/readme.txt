1. 降级固件，以便于root登陆
   路由宝网页界面点手动升级，降级固件文件: Youku-L1c-0818-root.bin

2. ssh登陆
    ssh root@192.168.11.1
    密码：admin
    Ps: 密码不对的话就在路由器开机状态下长按路由器后面的 Reset 键重置路由器就可以了。

3. 备份完整编程器固件
    dd if=/dev/mtd0 of=/tmp/youku/mnt/tf2/fullflash.bin
    ln -s /tmp/youku/mnt/tf2/fullflash.bin /www/fullflash.bin
    wget http://192.168.11.1/fullflash.bin

4. 刷breed (Boot and Recovery Environment for Embedded Devices):
   下载地址：https://breed.hackpascal.net/

    $ cat /proc/mtd
    dev:    size   erasesize  name
    mtd0: 02000000 00010000 "ALL"
    mtd1: 00030000 00010000 "Bootloader"
    mtd2: 00010000 00010000 "Config"
    mtd3: 00010000 00010000 "Factory"
    mtd4: 00fb0000 00010000 "firmware"
    mtd5: 00e2ad1d 00010000 "rootfs"
    mtd6: 00730000 00010000 "rootfs_data"
    $

   scp breed-mt7620-youku-yk1.bin root@192.168.11.1:/tmp
   ssh root@192.168.11.1
   mtd unlock Bootloader
   mtd write /tmp/breed-mt7620-youku-yk1.bin Bootloader

4. 使用 Breed 刷openwrt
    使用openwrt-19.07.3-ramips-mt7620-youku-yk1-squashfs-sysupgrade.bin

    root@OpenWrt:~# cat /proc/mtd
    dev:    size   erasesize  name
    mtd0: 00030000 00001000 "u-boot"
    mtd1: 00010000 00001000 "u-boot-env"
    mtd2: 00010000 00001000 "factory"
    mtd3: 01fb0000 00001000 "firmware"
    mtd4: 0017e222 00001000 "kernel"
    mtd5: 01e31dde 00001000 "rootfs"
    mtd6: 01bcd000 00001000 "rootfs_data"
    root@OpenWrt:~#

    update the dhcp client range
        Network->Interface->Lan->Edit->General Settings->IPv4 address
    The client ip address will be based on this address
    with the start and limit set in the following page:
        DHCP Server->General Setup

    断电之后reset还能进入BREED

5. 使用 Breed 刷入老毛子
    路由断电后按住 reset 键，后通电，
    指示灯(左右两边两个，中间没有闪)全闪后等 2 秒松开 reset 键，
    进入 Breed 管理界面 http://192.168.1.1 ，
    选择固件更新，使用 RT-N14U-GPIO-1-youku1-128M_3.4.3.9-099.trx 刷入老毛子。

    老毛子固件下载地址：http://opt.cn2qq.com/padavan/
    默认用户密码： admin/admin

    ssh服务开启后才能从终端登录
    从源码编译：
    https://bitbucket.org/padavan/rt-n56u/src/master
    https://aisoa.cn/post-2910.html

    [RT-N14U /opt/home/admin]# cat /proc/mtd
    dev:    size   erasesize  name
    mtd0: 00030000 00010000 "Bootloader"
    mtd1: 00010000 00010000 "Config"
    mtd2: 00010000 00010000 "Factory"
    mtd3: 00131ac0 00010000 "Kernel"
    mtd4: 00dce540 00010000 "RootFS"
    mtd5: 000b0000 00010000 "Storage"
    mtd6: 00f00000 00010000 "Firmware_Stub"
    [RT-N14U /opt/home/admin]#


- 优酷路由宝 YK-L1c 和 YK-L1 刷入 Breed 不死和 hiboy Padavan 固件
    https://zhuanlan.zhihu.com/p/124934007
- 优酷路由宝 YK-L1 刷 Breed 和老毛子 Padavan
    https://cyhour.com/780/
- 优酷路由宝刷OPENWRT心得体会
    https://blog.csdn.net/weixin_34132768/article/details/92565454

- 优酷yk-l1刷如breed的方法 及自编译的固件提供
    https://m.612459.com/news/?2331.html
- 在openwrt源码中开发自己的应用程序
    https://blog.csdn.net/gg101001/article/details/91358739
