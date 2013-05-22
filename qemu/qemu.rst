======
 qemu
======

create image
=============

.. code::

    % qemu-img -f qcow2 debian.qcow2 20G

-------------------------------------------------------------------------------

network
========

prepare
--------

.. code::

    # enable ip forward
    % sysctl net.ipv4.ip_forward=1

    # load tun
    % modprobe tun
    % lsmod | grep tun

    # if no tun mod, try
    % find /lib/modules/ -iname 'tun.ko.gz'
    % insmod `find /lib/modules/ -iname 'tun.ko.gz'`

    # check permission
    % ll /dev/net/tun

    ## create tap
    ## tunctl -b -u `whoami`


create bridge
--------------

.. code::

    # archlinux for example
    % ip link
    # tap0 eth0

    % echo '
    > Description="qemu Bridge connection"
    > Connection=bridge
    > Interface=br0
    > BindsToInterfaces=(eth0 tap0)
    > #IP=static
    > #Address=('x.x.x.x/x')
    > #Gateway='x.x.x.x'
    > #DNS=('x.x.x.x')
    > IP=dhcp' > /etc/netctl/qemu-bridge

    % netctl start qemu-bridge
    # show statue
    % brctl show
    % ip route

-------------------------------------------------------------------------------

start emu
===========

.. code::

    % echo 'allow br0' > /etc/qemu/bridge.conf
    % qemu -enable-kvm -vga vmware -net nic -net bridge,br=br0 \
    > -cdrom debian_netinst.iso debian.qcow2

-------------------------------------------------------------------------------

mount
======

qcow2
------

.. code::

    % modinfo nbd
    % lsmod | grep nbd
    # do not forget max_part
    % modprobe nbd max_part=10

    % qemu-nbd -c /dev/nbd0 debian.qcow2
    % mount /dev/nbd0p1 /mnt/debian
    % umount /mnt/debian
    % qemu-nbd -d /dev/nbd0
    % modprobe -r nbd

raw
----

.. code::

    mount -o loop,offset=32256 /path/to/image.img /mnt/mountpoint

-------------------------------------------------------------------------------

boot
=====

.. code::

    % qemu -hdb freebsd_memstick.img -boot menu=on freebsd.qcow2

