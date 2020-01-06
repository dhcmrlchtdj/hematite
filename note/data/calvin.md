# calvin

---

## deterministic

> forcing all other nodes in a system to wait for the node that experienced a
> nondeterministic event (such as a hardware failure) to recover could bring a
> system to a painfully long stand-still

这个说的是 2PC 吧。
（不过 2PC 应该也能像 raft 一样，多数同意就确定？不行的话，为什么？

> the concurrency control layer of the database is modified to acquire locks
> in the order of the agreed upon transactional input
> allow two replicas to stay consistent simply by replicating database input

## architecture

- a sclable transactional layer above any storage system that implements a basic CRUD interface
- layers (all three layers scale horizontally, shared-nothing)
    - the sequencing layer (sequencer)
        - input, replication, logging
    - the scheduling layer (scheduler)
        - orchestrate tranacstion exection
    - the storage layer
- sequencer
    - do
        - accept transaction requests
        - log txn to disk
        - forward txn in timestamp order to scheduler (in each replica)
    - batch
        - 10ms epoch
        - message = sequencer_node_id + epoch_id + all_txns
            - sequencer 和 scheduler 是 m:n 的关系
            - sequencer 会先在 replica 之间进行同步，然后发送给自己集群内的 scheduler
            - scheduler 会收到多个 sequencer 发来的 message
            - 合并起来可以得到整个 epoch 内的 txn
    - replica
        - 按论文里给出的图，sync 方式的 latency 很高啊
- scheduler
    - logging and concurrency protocals have to be completely logical
        - logical logging is straightforward
            - log by sequencer
            - checkpoint by storage layer
        - concurrency is problematic
            - create virtual resources that can be logically locked in the transactional layer
    - log manager
        - partitioned across the entire scheduling layer
        - each node's scheduler is only responsible for locking records that stored at that node's storage component
        - the locking protocol resembles strict two-phase locking

## checkpointing

- deterministic database systems that simplify the task of fault tolerance
    - allow clients to failover to another replica in the event of a crash
    - only the transactional input is logged, there is no need to pay the overhead of physical redo logging

---

http://dbmsmusings.blogspot.com/2017/04/distributed-consistency-at-scale.html

- Spanner uses TrueTime for transaction ordering
- Calvin uses sequencing for transaction ordering
    - All transactions are inserted into a distributed, replicated log before being processed

http://dbmsmusings.blogspot.com/2018/09/newsql-database-systems-are-failing-to.html

- database systems use consensus protocols to enforce consistency (how they use these protocols?
    - calvin: uses a single, global consensus protocol per database
        - 有中心，性能怎么解决？（batch
    - spanner: partitions the data into shards, and applies a separate consensus protocol per shard
        - the system cannot guarantee CAP consistency without TrueTime

http://www.zenlife.tk/cockroach-parallel-commits.md

- calvin 模式无法支持交互式事务

---

总结一下，就是，不懂…
