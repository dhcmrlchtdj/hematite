.. contents::



让程序以 root 权限运行
=======================

::

    $ chmod u+s /usr/bin/fbterm




禁用 ipv6
==========

+ add :code:`ipv6.disable=1` to kernel parameters to disable ipv6 stack.
+ add :code:`ipv6.disable_ipv6=1` to kernel parameters will keep ipv6 stack
  but not assign ipv6 address to any of network devices.


动态关闭

::

    # 1. vim /etc/sysctl.d/ipv6.conf
    net.ipv6.conf.all.disable_ipv6 = 1
    # net.ipv6.conf.<interface0>.disable_ipv6 = 1

    # 2. vim /etc/hosts
    # comment ipv6 hosts
    #::1            localhost.localdomain   localhost




scp
====

::

    # local to remote
    $ scp -2r [-P port] /local/path user@hostname:/remote/path

    # remote to local
    $ scp -2r [-P port] user@hostname:/remote/path /local/path




rsync
======

::

    $ rsync -ahvzP -e "ssh -p 22" user@hostname:/remote/path /local/path




shell history
==============

``Ctrl-R``




bsdtar
=======

::

    $ bsdtar cvaf output.txz *
    $ bsdtar xvf output.txz




core dump
==========

enable
-------

::

    # get
    $ ulimit -c

    # set
    $ ulimit -c unlimited
    $ ulimit -c 1073741824  # 1gb


path
-----

::

    # temporary
    $ echo '/var/core/%t-%e-%p-%s.core' > /proc/sys/kernel/core_pattern
    $ echo 0 > /proc/sys/kernel/core_uses_pid

    # permanent
    $ echo '
    > kernel.core_pattern = /var/core/%t-%e-%p-%s.core
    > kernel.core_uses_pid = 0' >> /etc/sysctl.conf
    $ sysctl -p


compress
---------

::

    $ echo '
    > #!/usr/bin/env sh
    > exec gzip - > /var/core/$1-$2-$3-$4.core.gz' > /path/to/script
    $ echo '| /path/to/script %t %e %p %s' > /proc/sys/kernel/core_pattern


exclude shared memory
----------------------

::

    $ cat /proc/<PID>/coredump_filter
    $ echo 1 > /proc/<PID>/coredump_filter

    $ man core





是否支持 64 位
===============

::

    $ grep lm /proc/cpuinfo




dd
===

::

    $ dd bs=4M if=/path/to/archlinux.iso of=/dev/sdX

    # restore
    $ dd count=1 bs=512 if=/dev/zero of=/dev/sdX
    $ cfdisk /dev/sdX
    $ cgdisk /dev/sdX # for GPT

``ddrescure``




查看网卡速度
=============

::

    $ cat /sys/class/net/eth0/speed




sshfs
======

::

    $ modprobe fuse

    # mount
    $ sshfs username@hostname:path /local/mount/point [ssh_options]

    # unmount
    $ fusermount -u /local/mount/point





pip
====

以前找到的代码是这样的

::

    $ pip freeze -l | cut -d = -f 1 | xargs pip instal -U
    $ pip freeze -l | cut -d = -f 1 | xargs -n 1 pip search | grep -B2 'LATEST:'

发现还可以这样

::

    $ pip list -l   # list local packages
    $ pip list -lo  # out of date
    $ pip list -lo | awk '{print $1}' | xargs -n 1 pip install -U
    $ pip list -lo | cut -d ' ' -f 1 | xargs -n 1 pip install -U






wget
=====

::

    $ wget -r -k -l 1 -np 'http://url'  -A html,css

用来抓取文档还是很好用的。

+ ``r`` 是递归抓取。
+ ``k`` 是转换链接地址。
+ ``l`` 是递归的深度。
+ ``np`` 是不抓取上级目录。
+ ``A`` 是要下载的后缀。




systemd service
================
修改了 ``service`` 文件后，
要使用 ``systemctl --system daemon-reload`` 来重新加载配置。






更新 grub 设置
===============
修改好  ``/etc/default/grub`` ，
然后执行 ``grub-mkconfig -o /boot/grub/grub.cfg`` 。





更新系统时间
=============
::

    $ ntpd -q # 更新时间
    $ hwclock -w # 保存时间




max pid
========
进程太多，突然发现编号变小了，估计到了最大值。

上网查了下，由 ``/proc/sys/kernel/pid_max`` 决定，默认是 32768。





配 ip
===========

::

    $ ip addr add your.ip.addr.ess/mask.bits dev eth0




禁用 su
=========

+ http://serverfault.com/questions/69216/disable-su-on-machine

ssh 连上之后，还是可以靠 ``su`` 获取管理权限。

可以修改 ``/etc/pam.d/su`` ，只允许 ``wheel`` 用户组调用 ``su`` 。
