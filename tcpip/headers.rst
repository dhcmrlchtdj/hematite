========
 header
========

ip
===

.. image:: ./ip-headers.jpg

+ [0-3]     version
    + ipv4 ``0100``
    + ipv6 ``0110``

+ [4-7]     IHL (internet header length)
    + how long the IP header is in 32 bit words.
    + minimum length is 5 words.

+ [8-16]    TOS

+ [17-31]   total length
    + how large the packet is in octets/bytes.
    + maxumun is 65535 (2^16-1) octets.
    + minimum is 576 octets.
    + a 1500-byte packet is the largest allowed by Ethernet at network layer.

+ [32-47]   identification
    + used to reassemb fragmented packets.

+ [48-50]   flags
    + 48 is reserved
    + 49 set to 0 if the packet be fragmented else 1
    + 50 set to 0 if it is last fragment else 1

+ [51-63]   fragment offset
    + where in the datagram that this packet belongs.
    + first fragment has offset 0.
    + calculate in 64 bits.

+ [64-72]   TTL (time to live)
    + if TTL reaches 0, the whole packet must be discarded.
    + every process that touches the packet must remove one point from TTL.
    + upon destruction the host should return
      an ICMP Unreachable message to sender.

+ [73-80]   protocol
    + the protocol be used by next level layer.
    + TCP, UDP, ICMP ...

+ [81-96]   header checksum
    + be recomputed at every host that changes the header (TTL or ...).

+ [97-128]  source address

+ [129-160] destination address

+ [161-192:478] options
    + IP options

+ [???-???] padding
    + set to 0.
    + make the header end at an even 32 bit boundary.

-------------------------------------------------------------------------------

tcp
====

.. image:: ./tcp-headers.jpg

+ [0-15]    source port

+ [16-31]   destination port

+ [32-63]   sequence number
    + sequence number is return in ACK field to aknowledge
      that the packet was properly recevied.

+ [64-95]   aknowledgment number
    + used for ACK

+ [96-99]   data offset
    + how long is the TCP header.
    + measure the TCP header in 32 bit words.

+ [100-103] reserved

+ [104]     CWR (congrestion window reduced)

+ [105]     ECE (ECN echo)

+ [106]     URG (urgent pointer)
    + set to 1 to use urgent pointer.

+ [107]     ACK (acknowledgment)
    + indicate this is in reply to another packet that host recevied.

+ [108]     PSH (push)

+ [109]     RST (reset)
    + tell other end to tear down the TCP connection.

+ [110]     SYN (synchronize sequence numbers)
    + be used during the initial establishment of a connection.

+ [111]     FIN
    + indicate that the host has no more data to send.

+ [112-127] window
    + be used by receviving host to tell the sender
      how much data the receiver permits at the moment.
    + be sent with ACK.

+ [128-143] checksum
    + checksum of the whole TCP header.

+ [144-159] urgent pointer
    + pointer that points to the end of the data which is considered urgent.

+ [160-???] options
    + tcp options

+ [???-???] padding
    + ensures that the TCP header ends at a 32-bit boundary.

-------------------------------------------------------------------------------

udp
====

.. image:: ./udp-headers.jpg

+ [0-15]    source port

+ [16-31]   destination port

+ [32-47]   length
    + length of the whole packet in octets, including header and data.
    + shortest possible packet can be 8 octets.

+ [48-63]   checksum

-------------------------------------------------------------------------------

icmp
=====

basic
------

.. image:: ./icmp-basic-headers.jpg

+ [0-3]     version
    + always set to 4.

+ [4-7]     IHL (internet header length)
    + length of header in 32 bit words.

+ [8-16]    TOS (type of service)
    + set to 0.

+ [17-32]   total length
    + length of header and data in 8 bit words.

+ [33-46]   identification

+ [47-49]   flags

+ [50-63]   fragment offset

+ [64-71]   TTL (time to live)

+ [72-79]   protocol
    + ICMP version.
    + always set to 1.

+ [80-95]   header checksum

+ [96-111]  source address

+ [112-127] destination address

+ [128-135] type
    + IMCP type.

+ [136-143] code
    + different types have different codes.

+ [144-159] checksum


  +-------------------------+--------+
  | type                    | number |
  +=========================+========+
  | echo reply              | 0      |
  +-------------------------+--------+
  | echo  request           | 8      |
  +-------------------------+--------+
  | destination unreachable | 6      |
  +-------------------------+--------+
  | source quench           | 4      |
  +-------------------------+--------+
  | time exceeded message   | 11     |
  +-------------------------+--------+
  | paramenter problem      | 12     |
  +-------------------------+--------+
  | information request     | 15     |
  +-------------------------+--------+
  | information reply       | 16     |
  +-------------------------+--------+


Echo Request/Reply
-------------------

.. image:: ./icmp-echo-headers.jpg

+ [160-175] identifier
+ [176-191] sequence number


Destination Unreachable
------------------------

.. image:: ./icmp-destination-unreachable-headers.jpg

code:

+ `0` network unreachable
+ `1` host unreachable
+ `2` protocol unreachable
+ `3` port unreachable
+ `4` fragmentation needed and DF set
    + packet needs to be fragmented to be delivered.
+ `5` source route failed
+ `6` destruction network unknown
+ `7` destination host unknown
+ `8` source host isolated (obsolete)
+ `9` destination network administratively prohibited
+ `10` destination host administratively prohibited
+ `11` network unreachable for TOS
+ `12` host unreachable for TOS
+ `13` communication administratively prohibited by filtering
+ `14` host precedence violation
+ `15` precedence cutoff in effect


source quench
--------------

.. image:: ./icmp-source-quench-headers.jpg


redirect
---------

.. image:: ./icmp-redirect-headers.jpg

code:

+ `0` redirect for network
+ `1` redirect for host
+ `2` redirect for TOS and network
+ `3` redirect for TOS and host


TTL equals 0
-------------

.. image:: ./icmp-time-exceeded-headers.jpg

time exceeded message.

code:

+ `0` TTL equals 0 during transit
+ `1` TTL equals 0 during reassembly


parameter problem
------------------

.. image:: ./icmp-parameter-problem-headers.jpg

+ `0` IP header bad (catchall error)
+ `1` required options missing


timestamp request/reply
------------------------

.. image:: ./icmp-timestamp-headers.jpg

obsolete


information request/reply
--------------------------

.. image:: ./icmp-information-headers.jpg
