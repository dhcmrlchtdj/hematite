# hybrid logical clock

---

https://cse.buffalo.edu/tech-reports/2014-04.pdf

论文里面的方案，是 HLC = physical_time + logical_time
这里说是 physical_time，实际上和 Lamport Clock 一样会取最大值，而不仅仅看本机时钟。
所以，实质上还是 Lamport Clock
但前面的物理时间让 HLC 有了一定的时间意义，但实际发挥作用的还是 Lamport Clock

---

https://www.cockroachlabs.com/blog/living-without-atomic-clocks/

- linearizability, external consistency
- serializability
    - in a non-distributed database, serializability implies linearizability for transactions

- TrueTime gives an upper bound for clock offsets between nodes in a cluster
    - TT, upper bound of 7ms
    - NTP, between 100ms and 250ms
- Before a node is allowed to report that a transaction has committed, it must **wait** 7ms

- When starting a transaction reading data from multiple nodes, a timestamp must be chosen which is guaranteed to be at least as large as the highest commit time across all nodes
- When CockroachDB starts a transaction, it chooses a provisional commit timestamp based on the current node's wall time.
- Spanner always delays writes for a short interval, whereas CockroachDB sometimes delays reads.
