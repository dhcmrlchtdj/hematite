让程序以 root 权限运行
=======================

.. code::

    $ chmod u+s /usr/bin/fbterm




禁用 ipv6
==========

+ add :code:`ipv6.disable=1` to kernel parameters to disable ipv6 stack.
+ add :code:`ipv6.disable_ipv6=1` to kernel parameters will keep ipv6 stack
  but not assign ipv6 address to any of network devices.


动态关闭

.. code::

    # 1. vim /etc/sysctl.d/ipv6.conf
    net.ipv6.conf.all.disable_ipv6 = 1
    # net.ipv6.conf.<interface0>.disable_ipv6 = 1

    # 2. vim /etc/hosts
    # comment ipv6 hosts
    #::1            localhost.localdomain   localhost




scp
====

.. code::

    # local to remote
    $ scp -2r [-P port] /local/path user@hostname:/remote/path

    # remote to local
    $ scp -2r [-P port] user@hostname:/remote/path /local/path




rsync
======

.. code::

    $ rsync -ahvzP -e "ssh -p 22" user@hostname:/remote/path /local/path




shell history
==============

:code:`Ctrl-R`




bsdtar
=======

.. code::

    $ bsdtar cvaf output.txz *
    $ bsdtar xvf output.txz




core dump
==========

enable
-------

.. code::

    # get
    $ ulimit -c

    # set
    $ ulimit -c unlimited
    $ ulimit -c 1073741824  # 1gb


path
-----

.. code::

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

.. code::

    $ echo '
    > #!/usr/bin/env sh
    > exec gzip - > /var/core/$1-$2-$3-$4.core.gz' > /path/to/script
    $ echo '| /path/to/script %t %e %p %s' > /proc/sys/kernel/core_pattern


exclude shared memory
----------------------

.. code::

    $ cat /proc/<PID>/coredump_filter
    $ echo 1 > /proc/<PID>/coredump_filter

    $ man core




查找文件属于哪个包
===================

archlinux only

.. code::

    $ which google-chrome
    /usr/bin/google-chrome
    $ pacman -Qqo /usr/bin/google-chrome
    google-chrome-dev

    # 使用管道查找
    $ which google-chrome | pacman -Qqo - | pacman -Qi -





是否支持 64 位
===============

.. code::

    $ grep lm /proc/cpuinfo




dd
===

.. code::

    $ dd bs=4M if=/path/to/archlinux.iso of=/dev/sdX

    # restore
    $ dd count=1 bs=512 if=/dev/zero of=/dev/sdX
    $ cfdisk /dev/sdX
    $ cgdisk /dev/sdX # for GPT

``ddrescure``




查看网卡速度
=============

.. code::

    $ cat /sys/class/net/eth0/speed




sshfs
======

.. code::

    $ modprobe fuse

    # mount
    $ sshfs username@hostname:path /local/mount/point [ssh_options]

    # unmount
    $ fusermount -u /local/mount/point





pip
====

以前找到的代码是这样的

.. code::

    $ pip freeze -l | cut -d = -f 1 | xargs pip instal -U
    $ pip freeze -l | cut -d = -f 1 | xargs -n 1 pip search | grep -B2 'LATEST:'

发现还可以这样

.. code::

    $ pip list -l   # list local packages
    $ pip list -lo  # out of date
    $ pip list -lo | awk '{print $1}' | xargs -n 1 pip install -U
    $ pip list -lo | cut -d ' ' -f 1 | xargs -n 1 pip install -U






wget
=====

.. code::

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
