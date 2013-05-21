======
 qemu
======

create image
=============

.. code::

    % qemu-img -b image.iso -f qcow2 disk_image.qcow2 20G

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

    # create tap
    % tunctl -b -u `whoami`


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
    % qemu -net nic -net bridge,br=br0 disk_image.qcow2

