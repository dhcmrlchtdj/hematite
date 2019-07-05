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

## Infrastructure: RPC and threads

- threading challenages
    - sharing data
        - synchronization
    - coordination
    - granularity
        - coarse-grained
        - fine-grained
- sharing+locks vs channels
    - state vs communication
- RPC
    - client/server communication
- RPC failure
    - failure-handling scheme
        - best effort (retry)
        - at most once (unique ID for each request)
            - how to create unique ID
            - when to discard old RPC response (heartbeat, received next UID)
        - exactly once

---

## GFS

- system design
    - trading consistency for simplicity and performance
    - performance, fault-tolerance, consistency
- consistency
    - replicate
        - multiply machines, reads and writes go across
    - strong consistency
        - bad for performance, easy for application writers
    - weak consistency
        - good for performance, easy for scale, bad for reason about
- consistency model
    - a replicated FS behaved like a non-replicated FS
        - what happens on a single machine?
    - challenges
        - concurrency
        - machine failures
        - network partitions
- GFS



