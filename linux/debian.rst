========
 debian
========

source
=======

试了很久，终于找到可以用的源了。

.. code::

    # /etc/apt/source.list
    deb http://ftp.cn.debian.org/debian unstable main contrib non-free
    deb http://ftp.cn.debian.org/debian-multimedia unstable main non-free

-------------------------------------------------------------------------------

network
========

网络比较简单。

.. code::

    # /etc/network/interfaces
    auto lo
    iface lo inet loopback

    allow-hotplug eth0
    # iface eth0 inet dhcp
    iface eth0 inet static
    address 172.16.42.240
    netmask 255.255.0.0
    gateway 172.16.42.1
    dns-nameservers 202.197.224.4

-------------------------------------------------------------------------------

services
=========

:code:`/etc/init.d/ssh restart`.

-------------------------------------------------------------------------------

mod
====

使用 :code:`lsmod | grep sp` 来查找装载了哪些模块。
在 :code:`/etc/modprobe.d/` 下创建文件，就会在开机时载入相关配置。

.. code::

    # /etc/modprobe.d/blacklist.conf
    blacklist pcspkr
    blacklist snd_pcsp

-------------------------------------------------------------------------------

ssh
====

.. code::

    % ssh-copy-id -i pub_key -p port user@hostname
    # pub_key use `~/.ssh/id*.pub` by defualt
    # the key will be copied to `user@hostname:.ssh/authorized_keys`

