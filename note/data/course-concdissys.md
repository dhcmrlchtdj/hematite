# Concurrent and Distributed Systems

https://www.cst.cam.ac.uk/teaching/2021/ConcDisSys
https://martin.kleppmann.com/2020/11/18/distributed-systems-and-elliptic-curves.html

---

# content
- time / clock / event order
- broadcast
- replication
- consensus
- replica consistency
- concurrency control

---

# failure detectors
- heartbeat, cannot tell the difference between crashed node, temporarily unresponsive node, lost message, and delayed message
- Perfect timeout-based failure detector exists only in a synchronous crash-stop system with reliable links.

---

# clock

- time-of-day clock
    - Time since a fixed date (e.g. 1 January 1970 epoch)
    - May suddenly move forwards or backwards (NTP stepping), subject to leap second adjustments
    - clock_gettime(CLOCK_REALTIME)
- monotonic clock
    - Time since arbitrary point (e.g. when machine booted up)
    - Always moves forwards at near-constant rate
    - clock_gettime(CLOCK_MONOTONIC)

- physical clocks
    - count number of seconds elapsed
    - may be **inconsistent with causality**
- logical clocks
    - count number of events occurred
    - designed to **capture causal dependencies**
    - Lamport clocks, vector clocks

---

# happens-before
- event A happens before event B (written A->B) iff (满足下列任意一个条件)
    - A and B occurred at the same node, and A occurred before B
    - A is the sending of some message m, and B is the receipt of that same message m
    - there exists an event C such that A->C and C->B

- the happens-before relation is a partial order
- happens-before relation encodes potential causality

---

# broadcast
- timing model (upper bound on message latency
    - asynchronous
    - partially synchronous

- 下面这段
    - broadcast 是 application 到 broadcast layer
    - deliver 是 broadcast layer 到 application
    - 下面关心的是消息被 broadcast 的顺序和消息被 deliver 的顺序
- reliable broadcast, forms
    - FIFO broadcast
        - 一个节点先后 broadcast 两个消息，且 happens-before(m1 -> m2)，那么 m1 会先 deliver
    - causal broadcast
        - happens-before(m1 -> m2)，那么 m1 会先 deliver
    - total order broadcast
        - m1 在某个节点上先被 deliver，那么在所有节点上， m1 都要比 m2 先 deliver
    - FIFO-total order broadcast

---

# broadcast algotithm
- make best-effort broadcast reliable, then, enforce delivery order on top of reliable broadcast
- gossip
    - when a node receives a message for the first time, forward it to 3 other nodes, chosen randomly
    - eventually reaches all nodes (with high probability)
        - 瞬间感觉不可靠了

---

# consensus
- implement **total order broadcast** by sending all messages via a single leader
- fault-tolerant -> leader election
- **consensus** and **total order broadcast** are formally equivalent
    - paxos: single-value consensus
    - multi-paxos: total order broadcast
    - raft/zab/viewstamped replication: FIFO-total order broadcast
- partial synchronous, crash-recovery system model
- can guarantee unique leader **per term**

- vs atomic commit
    - consensus 只需要多数节点同意
    - atomic commit 需要全部节点同意
        - 2PC
            - if the coordinator crashes, blocked until coordinator recovers

---

# consistency
- meaning
    - in ACID: consistent means satisfying application-specific invariants
    - in read-after-write consistency
    - in replication consistency: replicas have the same state, return same result

- linearizability: all operations behave as if executed on a single copy of the data
    - quorum reads/writes 不代表一定满足 linearizability
    - quorum read + blind write to quorum （把读到的最新值扩散出去，保证 replicas 同步

- linearizable compare-and-swap (via total order broadcast

---

# model

- atomic commit
    - all participating nodes
    - partially synchronous
- consensus, total order broadcast, linearizable CAS
    - quorum
    - partially synchronous
- linearizable get/set
    - quorum
    - asynchronous
- eventual consistency, causal broadcast, FIFO broadcast
    - local replica only
    - asynchronous

---

# CRDT

- op-based CRDT has smaller messages
- state-based CRDT can tolerate message loss/duplication

- op-based CRDT, require:
    - reliable broadcast
    - commutative: apply an operation is commutative

- state-based CRDT, merge operation must satify:
    - for all state, merge satify:
    - commutation: M(s1, s2) = M(s2, s1)
    - associative: M(M(s1, s2), s3) = M(s1, M(s2, s3))
    - idempotent: M(s1, s1) = s1

---

# spanner

- serializable transaction isolation (2PL)
- linearizable read/write
- many shards
    - atomic commit of transactions across shards (2PC)
    - state machine replication (paxos) within a shard
