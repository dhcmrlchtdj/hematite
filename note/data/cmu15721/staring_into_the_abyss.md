# Staring into the Abyss: An Evaluation of Concurrency Control with One Thousand Cores

---

> with hundreds of threads running in parallel, the complexity of coordinating
> competing accesses to data will become a major bottleneck to scalability, and
> will likely dwindle the gains from increased core counts

现有的 concurrency control 算法，在 1000 core 的情况下，同步开销大过性能提升

---

> the transactions in modern OLTP workloads have three slient characteristics:
> (1) they are short-lived (i.e., no user stalls)
> (2) they touch a small subset of data using index look-ups (i.e., no full table scans or large joins)
> (3) they are repetitive (i.e., executing the same queries with different inputs)

OLTP 要处理的场景

---

> all concurrency schemes are either a variant of two-phase locking or timestamp ordering protocol

> a major difference among the different variants of 2PL is in how they handle
> deadlocks and the actions that they take when a deadlock is detected

> the key differents between the schemes are (1) the granularity that the DBMS
> checks for conflicts (i.e., tuples vs. partitions) and (2) when the DBMS
> checks for these conflicts (i.e., while the transaction is running or at the end)

- two-phase locking
    - wait-for
    - non-waiting
    - wait-and-die
- timestamp ordering
    - timestamp ordering
    - MVCC
    - optimistic concurrency control
    - timestamp ordering with partition-level locking

---

> most of this work was eliminate shared data structures and devise distributed
> versions of the classical algorithms

论文列举了过程中的很多问题，但是，缺少经验没什么感觉。

---

> moving to a multi-node architecture introduces a new performance bottleneck:
> distributed transactions. since these transactions access data that may not be
> on the same node, the DBMS must use a atomic commit protocol, such as two-phase commit

> it may be that for multi-node DBMSs two levels of abstraction are required:
> a shared-nothing implementation between nodes and a multi-threaded shared-memory
> DBMS within a single chip.

分布式数据库，在普通数据库的基础上增加了分布式事务。
