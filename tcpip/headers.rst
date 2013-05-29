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

+ [32-46]   identification
    + used to reassemb fragmented packets.

+ [47-49]   flags
    + 47 is reserved
    + 48 set to 0 if the packet be fragmented else 1
    + 49-50 set to 0 if it is last fragment else 1

+ [50-63]   fragment offset
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




