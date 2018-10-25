# Computer Networks: A Systems Approach

https://book.systemsapproach.org/

---

- end-to-end
    - transport, end-to-end protocol
    - from host-to-host delivery service to process-to-process communication service
    - pronlems
        - drop messages
        - reorder messages
        - duplicate messages
        - size limits 
        - message delay

- UDP
    - demultiplexing: a process is identified by (port, host)
    - which port: well-known port; port mapper service 
    - FIFO queue, no flow-control, connectless
    - checksum

- TCP
    - demultiplexing, (srcPort,srcIP,dstPort,dstIP)
    - full-duplex
    - end-to-end
        - sliding window
        - adaptive timeout mechanism
        - package order, Maximum Segment Lifetime
        - flow control, backpresure, hardware limited
        - network congestion control, the load on the link layer
    - segment
        - byte-stream
        - sequence num, acknowledgement
        - flag: SYN, ACK, FIN, RESET, PUSH, URG
        - checksum
    - three-way handshake
        - SYN, seq=x
        - SYN+ACK, seq=y, ack=x+1
        - ACK, ack=y+1
    - sliding window
        - reliable and ordered delivery
        - flow control
    - congestion control



- RPC
    - is a mechanism for structuring distributed system
    - remote method invocation (vs local method call
    - transport layer, encode/decode layer
    - reliable message delivery
    - at-most-once semantic, idempotent semantic
    - identifier (program number + procedure number)



- RTP
    - type: interactive, streaming
    - commonly run over UDP
    - requirement
        - support different encode scheme, negotiation
        - relation of time and data, to support playback, how to synchronization different channels
        - packet loss
        - efficient use of bandwidth 
    - design, RTCP
