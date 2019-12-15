# aurora

- introduction
    - IO 被分散到多个节点后，单机的读写性能不再是最大的性能瓶颈
        - 瓶颈变成节点间的网络通信
    - 事务之间的重合，导致必须先同步状态再继续

- quorum model
    - V_r + V_w > V  保证读写的数据是最新的
    - V_w > V/2 避免写冲突
    - aurora 选择了 (v=6,w=4,r=3)
        - 6 个节点分布到 3 个集群，每个集群 2 个节点
        - 即使一个集群宕机，系统仍然可以读写
        - 允许单个集群不可用，意味着系统可以热更新。可以一个个集群升级而不影响整个系统
    - measure
        - Mean Time to Failure - MTTF
        - Mean Time to Repair - MTTR

- the log is the database
    - a log record can be applied to the before-image of the page to produce its after-image
    - in aurora, the only writes that cross the network are redo records
        - 通常 mysql 需要传输 redo log, binlog, data 等
    - offload redo processing to storage
        - the log applicator is pushed to the storage tier where it can be used to generate database pages in background or on demand
        - the process of crash recovery is spread across all normal foreground processing
    - minimize the latency of the foreground write request (on storage)
        - asynchronous
    - asynchronous processing
        - each log record has an associated Log Sequence Number (LSN)
            - monotonically increase
            - 保证操作有序，不依赖 2PC 实现一致性
            - recovery 的时候，没有完成同步的 log 会被丢弃
    - recovery
        - 传统数据库，恢复的时候，在 checkpoint 基础上执行 WAL 记录的操作
            - checkpoint 间隔长，则 log 多，恢复慢
            - checkpoint 间隔短，则影响平常业务吞吐
        - the redo log applicator operates on storage nodes, in the background

- conclusion
    - a high throughput OLTP database
    - decouple storage from compute
        - the bottleneck moves to the network
    - quorum model
    - log process
    - asynchronous consensus
    - checkpoint

---

- 对最初的分离计算与存储，就没搞懂。没有数据，怎么计算出 SQL 要执行什么？分发给存储的 log 都记录了什么？
- 另外文中好像没说 master 怎么选举的
- 对比一下大佬的论文笔记，自己差好远……
