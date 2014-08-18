.. contents::



source
=======

试了很久，终于找到可以用的源了。

::

    # /etc/apt/source.list
    deb http://ftp.cn.debian.org/debian unstable main contrib non-free
    deb http://ftp.cn.debian.org/debian-multimedia unstable main non-free




gpg key
========

::

    $ apt-get install debian-keyring
    $ gpg --keyserver subkeys.pgp.net --recv-keys 1F41B907
    $ gpg --armor --export 1F41B907 | apt-key add -





network
========

网络比较简单。

::

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





services
=========

``/etc/init.d/ssh restart``




pcspkr
=======

使用 ``lsmod | grep sp`` 来查找装载了哪些模块。
在 ``/etc/modprobe.d/`` 下创建文件，就会在开机时载入相关配置。

::

    # /etc/modprobe.d/blacklist.conf
    blacklist pcspkr
    blacklist snd_pcsp




ssh
====

::

    $ ssh-copy-id -i pub_key -p port user@hostname
    # pub_key use `~/.ssh/id*.pub` by defualt
    # the key will be copied to `user@hostname:.ssh/authorized_keys`




grub
=====

修改 ``/etc/default/grub`` 里的设置，然后运行 ``$ update-grub`` 。
或者 ``$ grub-mkconfig -o /boot/grub/grub.cfg`` 也可以吧。




starting MTA
=============

::

    $ aptitude purge exim4 exim4-base exim4-config exim4-daemon-light




sudo
=====

::

    $ adduser foo sudo


locale
=======
+ http://serverfault.com/questions/301896/how-to-fix-locale-settings-in-debian-squeeze
+ https://wiki.debian.org/Locale
+ https://help.ubuntu.com/community/Locale

之前碰到下面这个问题

::

    $ locale
    locale: Cannot set LC_CTYPE to default locale: No such file or directory
    locale: Cannot set LC_ALL to default locale: No such file or directory
    LANG=en_US.utf8
    LANGUAGE=
    LC_CTYPE=UTF-8
    LC_NUMERIC="en_US.utf8"
    LC_TIME="en_US.utf8"
    LC_COLLATE="en_US.utf8"
    LC_MONETARY="en_US.utf8"
    LC_MESSAGES="en_US.utf8"
    LC_PAPER="en_US.utf8"
    LC_NAME="en_US.utf8"
    LC_ADDRESS="en_US.utf8"
    LC_TELEPHONE="en_US.utf8"
    LC_MEASUREMENT="en_US.utf8"
    LC_IDENTIFICATION="en_US.utf8"
    LC_ALL=

    $ locale -a
    C
    C.UTF-8
    en_US.utf8
    POSIX

重新安装 ``locale`` ，执行 ``dpkg-reconfigure locales`` 和 ``locale-gen`` ，
通通没效果，LC_CTYPE 就是不听话。
虽然自己 ``export LC_CTYPE=en_US.UTF-8`` 也可以，但是不科学啊。

最后找到了上面的链接， ``update-locale LC_CTYPE=en_US.UTF-8`` ，
会在 /etc/defaults/locale 中添加 LC_CTYPE=en_US.UTF-8，问题解决。

debian 的 wiki 里提到了相关文件，却没提到有 update-locale 这个命令呀。

更新：在网上搜了下，连 ubuntu 的 wiki 都提到了。
debian 为什么提供了命令却藏着不说呢，鼓励大家手动改配置吗……
