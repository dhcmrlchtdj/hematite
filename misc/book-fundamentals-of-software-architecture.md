# fundamentals of software architecture

---

比较一般。
主要在看第二部分，可能精华在其他部分吧。
前几章也提到，作者认为做架构时，广度更重要。
可以认为，本书的重点也是广度，没有进行深度讲解。

---

- stuff you know -> technical depth
- stuff you know that you don't know -> technical breadth
- stuff you don't know that you don't know

---

# architecture

- monolithic
    - layered
    - pipeline
    - microkernel
- distributed
    - service-based
    - event-driven
    - space-based
    - service-oriented
    - microservices

distributed fallacy
    - the network is reliable
    - latency is zero
    - bandwidth is infinite
    - the network is secure
    - the topology never changes
    - there is only one administor
    - transport cost is zero
    - the network is homogeneous

---

## layered

- it is natural due to Conway's Law
- layer isolation
    - open vs close (是否运行 request 直接访问下一层
- technical partitioned architecture, components are grouped by technical role in the architecture
    - vs domain partitioned architecture, components are grouped by domain
- anti-pattern
    - sinkhole anti-pattern
        - requests move from layer to layer as simple pass-through processing with no business logic performed within each layer
        - analyze the percentage of requests that fall into sinkhole anti-pattern

## pipeline

- example: shell pipe, map-reduce

## microkernel

- topology: core system + plug-in components
