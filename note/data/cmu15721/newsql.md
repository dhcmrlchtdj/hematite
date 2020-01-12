# What’s Really New with NewSQL?

---

- 背景，为什么
    - 历史 single-node，middleware, NoSQL, NewSQL
    - middleware
        - 优点 present a single logical database to the application that is stored across multiple physical nodes
        - work well for simple operations like reading/updating a single record
        - 问题 difficult to execute queries that update more than one record in a transaction or join tables
    - NoSQL
        - forgo strong transactional guarantees and the relational of traditional DMBSs in favor of eventual consistency and alternative data models (kv, graph, document)
            - 为了效率，业务上能接受一定程度的数据不一致
            - 只是存数据，完整的 DB 有很多用不上的功能
            - 只需要简单查找，完整的 SQL 有很多用不上的功能
        - 问题 developers spend too much time writing code to handle inconsistent data
            - transaction provide a useful abstraction that is easier for humans to reason about

- 定义，是什么
    - 作者总结了目前（2016） NewSQL 的一些特点
        - target OLTP workloads
        - use a lock-free concurrency control scheme
        - use a shared-nothing distributed architecture

- 示例，有哪些
    - new architecture
        - based on distributed architecture
            - operate on shared-nothing resources
            - contain components to support multi-node concurrency control, fault tolerance throigh replication, flow control, and distributed query processing
        - responsible for distributing the database across its resources, allowed to "send the query to the data" rather than "bring the data to the query"
    - transparent sharding middleware
        - the centralized middleware component routes queries, coordinates transactions, manages data placement, replication, and partitioning across the nodes
        - a drop-in replacement for existed applications using single-node DBMS
    - database-as-a-service

- 现状，state-of-the-art
    - main memory storage
        - it is affordable to store all but the largest OLTP database entirely in memory
        - this approach enables certain optimizations
    - partitioning / sharding
        - split a database into disjoint subsets (for scale)
        - the DBMS distributes the execution of a query to multiple partitions and then combine their results together into a single result
    - concurrency control
        - there is nothing significantly new about the core concurrency control schemes in NewSQL system
        - whether the system uses a centralized or decentralized transaction coordination protocol
            - decentralized coordinator is better for scalability, but require a global ordering (google use TrueTime hardware)
        - 2PL, MVCC
    - secondary indexes
        - all new architecture NewSQL systems use partitioned secondary indexes
        - each node stores a portion of the index, rather than each node having a complete copy of it
    - replication
        - strong consistent or not
        - active-passive replication
    - crash recovery
        - the recovering node needs to get the updates from the new master that it missed while it was down

- 趋势，未来会怎样
    - real-time analytics, HTAP (hybrid transactional/analytical processing)
    - three approaches to support HTAP pipelines in a database application
        - OLTP, ETL, OLAP
        - the lambda architecture
        - a single HTAP DBMS
            - 前两种方案的开发维护成本都比较高，单系统同时支持 OLTP/OLAP 才是未来
            - 说的就是 streaming system?
