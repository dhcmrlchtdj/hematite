.. contents::


查找文件属于哪个包
===================

::

    $ which google-chrome
    /usr/bin/google-chrome
    $ pacman -Qqo /usr/bin/google-chrome
    google-chrome-dev
    $ pacman -Qqo $(which google-chrome)

    # 使用管道查找
    $ which google-chrome | pacman -Qqo - | pacman -Qi -






yaourt cache
=============

::

    $ "EXPORT=2" >> /etc/yaourtrc




更新密匙
=========

::

    # 有必要的话，可以全部更新
    $ rm -rf /etc/pacman.d/gnupg
    $ pacman-key --init

    # 更新密匙
    $ pacman-key --populate archlinux
    $ pacman-key --refresh-keys

