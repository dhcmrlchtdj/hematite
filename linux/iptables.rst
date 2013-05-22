==========
 iptables
==========

iptables splits packet hadling into three tables.

+ filter
+ nat
+ mangle

-------------------------------------------------------------------------------

filter
=======

filter table has three chains.

``INPUT``
    packet sent to us.

``OUTPUT``
    packet sent by us.

``FORWARD``
    packet routed by us.


filter table has three rules.

``ACCEPT``
    allow packet pass.

``DROP``
    just drop packet.

``REJECT``
    drop packet and send IMCP reply back to client.

-------------------------------------------------------------------------------

nat
====

Network Address Translation.

this table is used to translate the ``sourcr`` or ``destination`` field
in packets.

-------------------------------------------------------------------------------

mangle
=======

this table is used to alter certain fields in headers of ``IP`` packets.
such as TTL, TOS.

-------------------------------------------------------------------------------

syntax
=======

.. code::

    # append rule
    iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
    # insert rule
    iptables -I INPUT 3 -s 10.0.0.0/8 -j ACCEPT

    # remove rule by slot location
    iptables -D INPUT 3
    # remove rule by rule
    iptables -D INPUT -s 10.0.0.0/8 -j ACCEPT
    # caution: remove command only remove one rule once.
    # so, if there are same rules in tables,
    # this command just remove the first.

    # list rule
    iptables -nL
    # use -n avoid reserve DNS lookup

    # flush(drop) all rules
    iptables -F

-------------------------------------------------------------------------------

match
======

address
--------

filter by source/destination address of packet.

:code:`iptables -A INPUT -s 10.0.0.0/8 -d 172.25.0.1 -j DROP`


protocol
---------

such as TCP, UDP, ICMP ...

:code:`iptables -A INPUT -p tcp --dport 113 -j REJECT --reject-with tcp-reset`


state
------

there are four state:

ESTABLISHED
    packet which passed through our firewall is tracked as ESTABLISHED.

RELATED
    what?

NEW
    packet is part of a new connection which is not tracked.

INVALID
    connection is in invalid state.


:code:`iptables -A INPUT -m state --state INVALID,NEW -j DROP`

-------------------------------------------------------------------------------

whitelist example
==================

.. code::

    iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
    iptables -P INPUT DROP

