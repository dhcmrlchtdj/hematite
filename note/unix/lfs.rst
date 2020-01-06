创建分区
=========

+ :code:`/`
+ :code:`/boot` 100M 足矣
+ :code:`/home`

使用 ``cfdisk`` 创建分区，
使用 ``mkfs.btrfs`` 格式化分区，
使用 ``mount`` 挂载分区。

-----------------------------------------------------

安装前准备
===========

.. code::

    export LFS=/mnt/lfs

    mkdir -pv $LFS
    # mount ...

    mkdir 0v $LFS/sources
    chmod -v a+wt $LFS/sources
    wget -i download_list -P $LFS/sources

    mkdir -v $LFS/tools
    ln -sv $LFS/tools /
    # 会创建 /tools 这个链接

    # 移交权限
    chown -v username $LFS/sources
    chown -v username $LFS/tools


-----------------------------------------------------------------

编译安装
=========

.. code::

    # 进入源码目录 开始编译
    % cd %LFS/sources













