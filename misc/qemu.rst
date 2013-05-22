======
 qemu
======

create image
=============

.. code::

    % qemu-img -f qcow2 debian.qcow2 20G

-------------------------------------------------------------------------------

mount image
============

qcow2
------

.. code::

    % modinfo nbd max_part=10
    % lsmod | grep nbd
    % ll /dev/nbd*

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

start emu
===========

.. code::

    % qemu -enable-kvm -vga vmware debian.qcow2

-------------------------------------------------------------------------------

boot order
===========

.. code::

    % qemu -hdb freebsd_memstick.img -boot menu=on freebsd.qcow2

-------------------------------------------------------------------------------

status
=======

press ``Ctrl-Alt-2`` enter console.

-------------------------------------------------------------------------------

network
========

user mode
----------

use user's network, only works with the TCP and UDP protocols.

.. code::

    % qemu -net nic -net user debian.qcow2


tap
----

.. code::

    # enable ip forward
    % sysctl net.ipv4.ip_forward=1
    # or edit /etc/sysctl.conf

    # load tun
    % modprobe tun
    % lsmod | grep tun

    # if no tun mod, try
    % find /lib/modules/ -iname 'tun.ko.gz'
    % insmod `find /lib/modules/ -iname 'tun.ko.gz'`

    # create tap
    % tunctl -b -u `whoami`

    ## check permission
    ##% ll /dev/net/tun

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

    # start qemu
    % qemu -net nic -net tap,ifname=tap0,script=no,downscript=no debian.qcow2

    # or use bridge
    % echo 'allow br0' >> /etc/qemu/bridge.conf
    % qemu -net nic -net bridge,br=br0 debian.qcow2

