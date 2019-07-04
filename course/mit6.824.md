# Distributed Systems

https://pdos.csail.mit.edu/6.824/schedule.html

---

## Introduction

- why distributed
    - to achieve security via isolation
    - to tolerate faults via replication
    - to scale up throughput via parallel CPUs/mem/disk/net
- topic
    - implementation
    - performance
    - fault tolerance
    - consistency

- MapReduce
    - overview
        - 基本思路、适用场景
        - 解决什么问题，如何解决
    - advantage
        - hide painful details, scale well
        - 比其他方案优势在哪
    - limitations
        - 哪些场景不适用，为什么不适用
        - 性能、效率的瓶颈在哪
    - implementation details
        - 如何应对 limitation
    - fault tolerance, crash recovery
        - 发现、处理、恢复

---
