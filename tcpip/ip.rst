====
 ip
====

组成
=====

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

+ [161-192] options
    + IP options

+ [?-?]     padding
    + set to 0.
    + make the header end at an even 32 bit boundary.

