让程序以 root 权限运行
=======================

.. code::

    $ chmod u+s /usr/bin/fbterm

-------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------

scp
====

.. code::

    # local to remote
    $ scp -2r [-P port] /local/path user@hostname:/remote/path

    # remote to local
    $ scp -2r [-P port] user@hostname:/remote/path /local/path

-------------------------------------------------------------------------------

rsync
======

.. code::

    $ rsync -ahvzP -e "ssh -p 22" user@hostname:/remote/path /local/path

-------------------------------------------------------------------------------

shell history
==============

:code:`Ctrl-R`

-------------------------------------------------------------------------------

bsdtar
=======

.. code::

    $ bsdtar cvaf output.txz *
    $ bsdtar xvpf output.txz

-------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------

archlinux only
===============

.. code::

    $ which google-chrome
    /usr/bin/google-chrome
    $ pacman -Qqo /usr/bin/google-chrome
    google-chrome-dev
