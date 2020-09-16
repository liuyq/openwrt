https://openwrt.org/toh/hiwifi/hc6361


- 极路由壹（HC6361）最新固件刷OpenWRT的方法，需要TTL，怕手工活的就不要试了
    https://www.right.com.cn/forum/forum.php?mod=viewthread&tid=174240

    极路由做了一些让人忍无可忍的事情，为此我只有刷OpenWrt（明月51版）了，
    但是路由已经升级到了最新版固件，不能Tftp刷机，只有TTL了！
    准备工作：USB转TTL，TTL线，细电线，烙铁啥的你都有的吧？

    关键是软件，你需要OpenWRT固件，不会检查Magic Number的uboot，
        一个可能有必要的修改过的官方固件。

    一、硬件改造
        1.拆机，需要三角起子，费了我牛劲了，也有测试版是十字螺丝的
        2.飞线TP1连到TP3，TP2连到TP4
        3.装了个跳线座，方便以后用，如果你懒得烦神就直接焊线，对着焊，不用反转tx和rx
    二、软件刷机
        我弄了两台发现关键可能在uboot上，谁有机器？帮我按以下流程试试
        1. TTL刷入我附件的uboot
           接好TTL加电，按mh键（为啥高手都喜欢叫大家猜呢？）
           打开你的tftp服务，把uboot名字改为recovery.bin
           用  tftpboot 81000000 recovery.bin 命令把文件传到路由里
           再执行  erase 9f000000 +10000; cp.b 81000000 9f000000 10000  命令刷uboot
        2. tftp直接刷openwrt固件
           把明月固件放改名recovery.bin 放到tftp目录
           断电，按reset加电，刷机，成功没？

        能成功么？

        如果不成功, 软件刷机修改为：
        1.TTL刷入带SSH的修改版固件
        2.TTL刷入我提供的uboot
        3.tftp刷明月固件

        东西都在这里下吧：
            http://yun.baidu.com/share/link? ... 2&uk=2990324640

-   极壹HC6361救砖
    http://forum.cnsec.org/thread-1009.htm

    极1固件结构（9004版以前）：

    0x00000000 - 0x0000FFFF (0x010000): u-boot
    0x00010000 - 0x0001FFFF (0x010000): boardinfo预留空间
    0x00020000 - 0x0015FFFF (0x140000): kernel
    0x00160000 - 0x???????? (0x??????): squashfs

    极1固件结构（9005版以后）：

    0x00000000 - 0x0000FFFF (0x010000): u-boot
    0x00010000 - 0x0001FFFF (0x010000): boardinfo预留空间
    0x00020000 - 0x0016FFFF (0x150000): kernel
    0x00170000 - 0x???????? (0x??????): squashfs

    极1固件结构（9008版以后）：

    0x00000000 - 0x0000FFFF (0x010000): u-boot
    0x00010000 - 0x0001FFFF (0x010000): boardinfo预留空间
    0x00020000 - 0x0017FFFF (0x160000): kernel
    0x00180000 - 0x???????? (0x??????): squashfs



- https://blog.csdn.net/GodSpeed513/article/details/45530917

    使用winhex自建编程器固件（我的是TP-WR941N v2)
    1：使用winhex新建一个8M，16M的文件，编辑-全选，填充选块，填充十六进制数值 FF ；
    2：打开4M的原厂编程器固件（或者自己备份的，包含uboot和art分区的），定义选块，从0到0001FFFF，复制，然后打开新建的8M,16M文件，写入，偏移量为0.
    3：打开一个自己下载的8M openwrt固件，编辑-全选，复制；
    4：打开新建8M,16M文件，将鼠标定义到00020000处，写入；
    5：打开备份的art文件，或者在4M的原厂编程器固件中，定义选块03F1000到3FFFFF，复制，然后写入新建8M,16M文件的7F1000处，16M文件的FF1000处。
    这样，8M,16M的编程器固件就OK了，用编程器刷到flash里就OK了。


$ flashrom -r /tmp/FL128SAIF00.bin -p ch341a_spi -c S25FL128P......0
flashrom  on Linux 5.3.0-64-generic (x86_64)
flashrom is free software, get the source code at https://flashrom.org

Using clock_gettime for delay loops (clk_id: 1, resolution: 1ns).
No EEPROM/flash device found.
Note: flashrom can never write if the flash chip isn't found automatically.
$
