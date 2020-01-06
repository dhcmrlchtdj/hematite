创建镜像
=========

::

    $ qemu-img create -f qcow2 debian.qcow2 20G

    # 重复使用，节约资源
    $ qemu-img create -f qcow2 xp.qcow2 20G
    $ qemu-img create -f qcow2 -o backing_file=xp.qcow2 ie6.qcow2
    $ qemu-img create -f qcow2 -o backing_file=xp.qcow2 ie7.qcow2





挂载镜像
=========

qcow2
------

::

    $ modinfo nbd
    $ lsmod | grep nbd
    $ modprobe nbd max_part=10
    $ ll /dev/nbd*

    $ qemu-nbd -c /dev/nbd0 debian.qcow2
    $ mount /dev/nbd0p1 /mnt/debian
    $ umount /mnt/debian
    $ qemu-nbd -d /dev/nbd0
    $ modprobe -r nbd

raw
----

::

    mount -o loop,offset=32256 /path/to/image.img /mnt/mountpoint






start emu
===========

::

    $ qemu -enable-kvm -vga vmware -net nic,model=virtio -net user debian.qcow2






boot order
===========

::

    $ qemu -hdb freebsd_memstick.img -boot menu=on freebsd.qcow2






status
=======

press ``Ctrl-Alt-2`` enter console.







network
========

user mode
----------

use user's network, only works with the TCP and UDP protocols.

::

    $ qemu -net nic,model=virtio -net user debian.qcow2


tap
----

::

    # enable ip forward
    $ sysctl net.ipv4.ip_forward=1
    # or edit /etc/sysctl.conf
    $ cat /proc/sys/net/ipv4/ip_forward

    # load tun
    $ modprobe tun
    $ lsmod | grep tun

    # if no tun mod, try
    $ find /lib/modules/ -iname 'tun.ko.gz'
    $ insmod `find /lib/modules/ -iname 'tun.ko.gz'`

    # create tap
    $ tunctl -b -u `whoami`

    ## check permission
    ##$ ll /dev/net/tun

    # archlinux for example
    $ ip link
    # tap0 eth0

    $ echo '
    > Description="qemu Bridge connection"
    > Connection=bridge
    > Interface=br0
    > BindsToInterfaces=(eth0 tap0)
    > #IP=static
    > #Address=('x.x.x.x/x')
    > #Gateway='x.x.x.x'
    > #DNS=('x.x.x.x')
    > IP=dhcp' > /etc/netctl/qemu-bridge

    $ netctl start qemu-bridge
    # show statue
    $ brctl show
    $ ip route

    # start qemu
    $ qemu -net nic -net tap,ifname=tap0,script=no,downscript=no debian.qcow2

    # or use bridge
    $ echo 'allow br0' >> /etc/qemu/bridge.conf
    $ qemu -net nic -net bridge,br=br0 debian.qcow2





cpu and memery
===============

::

    $ qemu -smp 2 -m 1024







mouse
======

::

    $ qemu -usb -usbdevice tablet
