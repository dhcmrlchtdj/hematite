# Spark

- introduction
    - cluster computing framework
        - let users write parallel computation using a set of high-level operators
        - without having to worry about work distribution and fault tolerance
    - reuse intermediate results across multiple computations
        - data reuse is common in iterative algorithm
    - RDDs
        - enables efficient data reuse
        - provide an interface based on coarse-grained transformations
        - provide fault tolerance by logging the transformations used to build a dataset rather than the actual data
        - good for many parallel applications. there applications naturally apply the same operation to multiple data items

- Resilient Distributed Datasets (RDDs)
    - an RDD is a read-only, partitioned collection of records
    - RDD 有两个创建方式，来自硬盘数据，或者来自另一个 RDD
        - data in stable storage
        - through coarse-grained transformations
    - RDD 可以控制 persistence 和 partitioning（用户可以根据需要进行控制
    - RDDs are suited for batch applications that apply same operation to all elements of a dataset
    - RDDs would be less suitable for applications that make asynchronous fine-grained updates to shared state

- representing RDDs
    - a graph-based representation for RDDs, that can track lineage across a wide range of transformations
    - RDD includes (partitions, dependencies_RDDS, compute_function, partitioning_scheme, data_placement)
    - how to represent dependencies between RDDs
        - narrow dependencies
            - allow pipeline execution on one cluster node （map/filter 等操作，可以在一台机器上顺序执行）
            - recovery from a node failure is more efficient （某个 rdd 异常了，把前面的顺序操作再执行一次即可）
        - wide dependencies
            - 像 groupBy 等操作，要等上游 RDD 准备好才能下一步
            - 比如之后某个 RDD 异常，而 wide 操作又没有 persistence，则 wide 依赖的 RDD 也都要重新计算

- implementation
    - job scheduler
        - when user runs an action
            - the scheduler examines RDD's lineage graph to build a DAG of stages to execute
                - stage 会包含尽可能多的 narrow transformations
                - wide transformations 是 stage 的边界
                - 边界也可以是之前已经计算完的 stage
        - scheduler assigns tasks to machines based on data locality
        - task failure, re-run it on another node（有 DAG，算出所有需要重新计算的任务，然后重新算
        - scheduler failure, do nothing （最初设计是挂了重启？
    - memory management
        - storage of persistent RDDs
            - in-memory storage as deserialized Java objects (fastest performance
            - in-memory storage as serialized data (more memory-efficient
            - on-disk storage (useful for too large data
        - LRU eviction policy
    - checkpointing
        - lineage is used to recover RDDs after a failure
        - recovery may be time-consuming for RDDs with long lineage chains
        - checkpointing is useful for RDDs with long lineage graphs containing wide dependencies
        - leaves the decision of which data to checkpoint to the user
        - RDDs can be written out in the background (because RDD is immutable

- related work
    - cluster programming models
    - caching system
    - lineage
    - relational databases
- conclusion
    - RDDs is an efficient, general-purpose and fault-tolerant abstraction for sharing data in cluster applications
    - RDDs recover data efficiently using lineage (fault tolerance without replication)