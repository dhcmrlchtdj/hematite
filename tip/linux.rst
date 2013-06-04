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

    $ bsdtar cvfa output.txz *
    $ bsdtar xvf output.txz
