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






查找命令
=========

有这么几个命令，平时也没注意区别。

type
-----

用来查看命令的类型，是个函数。

.. code::

    $ type type
    type is a shell builtin

    $ type ls
    ls is an alias for ls --color=auto --group-directories-first -vF


where
------

也是个函数，会列出 ``$PATH`` 下所有符合的命令。

.. code::

    $ type where
    where is a shell builtin
    $ where where
    where: shell built-in command

    $ where ls
    ls: aliased to ls --color=auto --group-directories-first -vF
    /usr/bin/ls



which
------

用 ``where`` 会发现有个函数叫 ``which`` ，有个命令也叫 ``which`` 。

可以看 ``man 1 which`` ，
函数 ``which`` 是对 ``/usr/bin/which`` 的一个包装。

功能是列出 ``$PATH`` 下第一个符合名字的命令。

使用 ``which -a`` 可以列出所有命令，和 ``where`` 一样。
大概 ``where`` 也是对 ``/usr/bin/which`` 的包装吧。

.. code::

    $ where which
    which: shell built-in command
    /usr/bin/which

    $ type which
    which is a shell builtin

    $ which ls
    ls: aliased to ls --color=auto --group-directories-first -vF

    $ which -a ls
    ls: aliased to ls --color=auto --group-directories-first -vF
    /usr/bin/ls



whence
-------

whence 也是个函数。
可以查看一个命令实际上执行了什么，是个函数还是别名还是程序。
也可以模拟上面三个命令。

.. code::

    $ type whence
    whence is a shell builtin

    $ whence whence # function
    whence

    $ whence mkdir # command
    /usr/bin/mkdir

    $ whence ls # alias
    ls --color=auto --group-directories-first -vF

    $ whence -v ls # type
    ls is an alias for ls --color=auto --group-directories-first -vF

    $ whence -c ls # which
    ls: aliased to ls --color=auto --group-directories-first -vF

    $ whence -ca ls # where, which -a
    ls: aliased to ls --color=auto --group-directories-first -vF/usr
    /bin/ls


whereis
--------

会列出所有符合名字的二进制文件、源码、帮助文件。看 ``man 1 whereis`` 吧。

.. code::

    $ type whereis
    whereis is /usr/bin/whereis

    $ whereis ls
    ls: /usr/bin/ls /usr/share/man/man1/ls.1p.gz /usr/share/man/man1/ls.1.gz
