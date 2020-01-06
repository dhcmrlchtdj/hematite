==========
 iptables
==========

tables
=======

iptables splits packet hadling into three tables.

filter
-------

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


nat
----

Network Address Translation.

this table is used to translate the ``sourcr`` or ``destination`` field
in packets.


mangle
-------

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

example whitelist
==================

.. code::

    iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
    iptables -P INPUT DROP

-------------------------------------------------------------------------------

filter by interface
====================

.. code::

    % iptables -A INPUT -i lo -j ACCEPT
    # iptables -A INPUT --in-interface lo -j ACCEPT
    # work on INPUT, FORWARD, PREROUTING chains.

    % iptables -A OUTPUT -o lo -j ACCEPT
    # iptables -A OUTPUT --out-interface -j ACCEPT
    # work on FORWARD, OUTPUT, POSTROUTING chains.

    % iptables -A INPUT ! -i lo -j ACCEPT
    # invert

-------------------------------------------------------------------------------

example disallow ping
======================

.. code::

    % iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j DROP

-------------------------------------------------------------------------------

save and restore
=================

.. code::

    % iptables-save > /etc/iptables/example.rules
    % iptables-restore < /etc/iptables/example.rules

-------------------------------------------------------------------------------

connection track
=================

packets are related to tracked connections in four different states.

+ NEW
+ ESTABLISHED
+ RELATED
+ INVALID

all connection tracking is handled in the ``PREROUTING`` chain,
except locally generated packets which are handled in ``OUTPUT`` chain.

all state changes and calculations are done within nat table.

first packet is NEW.
followed packet is ESTABLISHED.
packet which is related to another already ESTABLISHED connection is REALATED.
beside, are INVALID

-------------------------------------------------------------------------------

match
======

+--------------------------+-------------------------------+
| generic match            | example                       |
+==========================+===============================+
| -p, --protocol           | iptables -A INPUT -p tcp      |
+--------------------------+-------------------------------+
| -s, --src, --source      | iptables -A INPUT -s 10.0.0.0 |
+--------------------------+-------------------------------+
| -d, --dst, --destination | iptables -A INPUT -d 10.0.0.0 |
+--------------------------+-------------------------------+
| -i, --in-interface       | iptables -A INPUT -i eth0     |
+--------------------------+-------------------------------+
| -o, --out-interface      | iptables -A FORWARD -o eth0   |
+--------------------------+-------------------------------+
| -f, --fragment           | iptables -A INPUT -f          |
+--------------------------+-------------------------------+

+-----------------------------+--------------------------------------------+
| implicit match              | example                                    |
+=============================+============================================+
| --sport, --source-port      | -A INPUT -p tcp --sport 22                 |
|                             | -A INPUT -p tcp --sport 22:80              |
|                             | -A INPUT -p tcp --sport 22:                |
|                             | -A INPUT -p tcp --sport ! 22:80            |
|                             | -A INPUT -p udp --sport ! 22               |
+-----------------------------+--------------------------------------------+
| --dport, --destination-port | -A INPUT -p tcp --dport 22                 |
|                             | -A INPUT -p udp --dport 80                 |
+-----------------------------+--------------------------------------------+
| --tcp-flags                 | -p tcp --tcp-flags SYN,ACK,FIN,RST,URG,PSH |
|                             | -p tcp --tcp-flags ALL                     |
|                             | -p tcp --tcp-flags NONE                    |
|                             | -p tcp --tcp-flags ! SYN                   |
+-----------------------------+--------------------------------------------+
| --syn                       | -p tcp --syn                               |
|                             | # shortcut for --tcp-flags SYN,ACKSYN,RST  |
+-----------------------------+--------------------------------------------+
| --tcp-option                | -p tcp --tcp-option 16                     |
+-----------------------------+--------------------------------------------+
| --icmp-type                 | -A INPUT -p icmp --icmp-type 8             |
+-----------------------------+--------------------------------------------+

+--------------------+--------------------------------------------------------------+
| explicit match     | example                                                      |
+====================+==============================================================+
| --src-range        | -A INPUT -p tcp -m iprange --src-range 10.0.0.0-10.0.0.255   |
|                    | -A INPUT -p tcp -m iprange ! --src-range 10.0.0.0-10.0.0.255 |
+--------------------+--------------------------------------------------------------+
| --dst-range        | -A INPUT -p tcp -m iprange --dst-range 10.0.0.0-10.0.0.255   |
+--------------------+--------------------------------------------------------------+
| --length           | -A INPUT -p tcp -m length --length 1400:1500                 |
|                    | -A INPUT -p tcp -m length ! --length 1500                    |
+--------------------+--------------------------------------------------------------+
| --mac-source       | -A INPUT -m mac --mac-source 00:00:00:00:00:01               |
|                    | -A INPUT -m mac ! --mac-source 00:00:00:00:00:01             |
+--------------------+--------------------------------------------------------------+
| --source-port      | -A INPUT -p tcp -m multiport --source-port 22,80,443         |
+--------------------+--------------------------------------------------------------+
| --destination-port | -A INPUT -p tcp -m multiport --destination-port 22           |
+--------------------+--------------------------------------------------------------+
| --port             | -A INPUT -p tcp -m multiport --port 22                       |
+--------------------+--------------------------------------------------------------+
| --state            | -A INPUT -m state --state INVALID,ESTABLISHED,NEW,RELATED    |
+--------------------+--------------------------------------------------------------+
| --ttl              | -A OUTPUT -m ttl --ttl 60                                    |
+--------------------+--------------------------------------------------------------+
| --tos              | -A INPUT -p tcp -m tos --tos 0x16                            |
+--------------------+--------------------------------------------------------------+

-------------------------------------------------------------------------------

target
=======

+------------+----------------------------------------------------------------------------------------------+
| target     | example                                                                                      |
+============+==============================================================================================+
| ACCEPT     | -A INPUT -j ACCEPT                                                                           |
+------------+----------------------------------------------------------------------------------------------+
| DROP       | -A INPUT -j DROP                                                                             |
+------------+----------------------------------------------------------------------------------------------+
| REJECT     | -A FORWARD -p tcp --dport 22 -j REJECT --reject-with-tcp-reset                               |
|            | # icmp-net-unreachable, icmp-host-unreachable, icmp-port-unreachable,                        |
|            | # icmp-proto-unreachable, icmp-net-prohibited, icmp-host-prohibited                          |
+------------+----------------------------------------------------------------------------------------------+
| LOG        | -A FORWARD -p tcp -j LOG --log-level debug                                                   |
|            | # debug, info, notice,warning, warn, err,error, crit, alert, emerg, panic                    |
|            | -A FORWARD -p tcp -j LOG --log-tcp-options                                                   |
|            | -A FORWARD -p tcp -j LOG --log-ip-options                                                    |
|            | -A INPUT -p tcp -j LOG --log-prefix "INPUT packets"                                          |
|            | -A INPUT -p tcp -j LOG --log-tcp-sequence                                                    |
+------------+----------------------------------------------------------------------------------------------+
| ULOG       | -A INPUT -p tcp --dport 22 -j ULOG --ulog-nlgroup 2                                          |
|            | -A INPUT -p tcp --dport 22 -j ULOG --ulog-prefix "SSH connection"                            |
|            | -A INPUT -p tcp --dport 22 -j ULOG --ulog-cprange 100                                        |
|            | -A INPUT -p tcp --dport 22 -j ULOG --ulog-qthreshold 10                                      |
+------------+----------------------------------------------------------------------------------------------+
| REDIRECT   | -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080                           |
|            | -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080-8090                      |
+------------+----------------------------------------------------------------------------------------------+
| TTL        | -t mangle -A PREROUTING -i eth0 -j TTL --ttl-set 64                                          |
|            | -t mangle -A PREROUTING -i eth0 -j TTL --ttl-dec 1                                           |
|            | -t mangle -A PREROUTING -i eth0 -j TTL --ttl-inc 1                                           |
|            | # ttl will decrement 1 and then dec/int work                                                 |
+------------+----------------------------------------------------------------------------------------------+
| TOS        | -t mangle -A PREROUTING -p tcp --dport 22 -j TOS --set-tos 0x10                              |
+------------+----------------------------------------------------------------------------------------------+
| TCPMSS     | -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RSTSYN -o eth0 -j TCPMSS --set-mss 1460      |
|            | -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RSTSYN -o eth0 -j TCPMSS --clamp-mss-to-pmtu |
+------------+----------------------------------------------------------------------------------------------+
| MASQUERADE | -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 1024-31000                             |
+------------+----------------------------------------------------------------------------------------------+
| DNAT       | -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 10.0.0.0-10.0.0.255          |
|            | -t nat -A PREROUTING --dst $INET_IP -p tcp --dport 80 -j DNAT --to-destination $HTTP_IP      |
+------------+----------------------------------------------------------------------------------------------+
| SNAT       | -t nat -A POSTROUTING -p tcp -o eth0 -j SNAT --to-source 10.0.0.0-10.0.0.255:1024-32000      |
+------------+----------------------------------------------------------------------------------------------+
| NETMAP     | -t mangle -A PREROUTING -s 10.0.0.0/24 -j NETMAP --to 10.5.6.0/24                            |
+------------+----------------------------------------------------------------------------------------------+
| CLASSIFY   | -t mangle -A POSTROUTING -p tcp --dport 80 -j CLASSIFY --set-class 20:10                     |
+------------+----------------------------------------------------------------------------------------------+
| DSCP       | -t mangle -A FORWARD -p tcp --dport 80 -j DSCP --set-dscp 1                                  |
|            | -t mangle -A FORWARD -p tcp --dport 80 -j DSCP --set-dscp-class EF                           |
+------------+----------------------------------------------------------------------------------------------+
| ECN        | -t mangle -A FORWARD -p tcp --dport 80 -j ECN --ecn-tcp-remove                               |
+------------+----------------------------------------------------------------------------------------------+
| MARK       | -t mangle -A PREROUTING -p tcp --dport 22 -j MARK --set-mark 2                               |
+------------+----------------------------------------------------------------------------------------------+

-------------------------------------------------------------------------------

NAT
====

+ NAT network address translation
+ SNAT source network address translation
+ DNAT destination network address translation
+ PNAT port NAT (basic of SNAT and DNAT)

SNAT is a synonym to masquerade.
