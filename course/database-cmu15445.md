# DATABASE SYSTEMS

https://15445.courses.cs.cmu.edu/fall2018/schedule.html

---

## Relational Model

---

- data model
    - most DBMS
        - relational
    - NoSQL
        - key-value
        - graph
        - document
        - column-family
    - Machine Learning
        - array / matrix
    - rare
        - hierarchical
        - network
- schema

---

- relational model
    - n-ary relation = table with n columns
    - primary key / foreign key

---

- relational algebra
    - based on set algebra
- relational calculus

---

## Advanced SQL

---

- relational algebra is based on sets (unordered, no duplicates)
- SQL is based on bags (unordered, allows duplicates)
    - DML
    - DDL
    - DCL
- SQL
    - window functions
        - likes an aggregation but still returns the original tuples
    - common table expressions
        - a CTE like a temporary table
        - https://www.postgresql.org/docs/11/queries-with.html
            - `WITH RECURSIVE` process is iteration not recursion
            - 执行 non-recursive 的部分。再执行 recursive 的部分，有新增内容就递归执行，直到没有新增内容。

---

## Database Storage

---

- how to represent the datatbase in file on disk
- how to manage memory and move data back-and-forth from disk

---

- manage the movement of data between non-volatile and volatile storage
- DBMS, support databases that exceed the amount of memory available
    - `mmap` will hit page faults

---

- file storage
    - a page is a fixed-size block of data
        - each page has a unique identifier
        - each page has a page type
        - database page (1~16k)
        - not hardware page(4k) nor os page(4k)
    - heap, unordered collection of pages
- page layout
    - header
    - tuple-oriented, slotted pages
        - slot array + tuple data
        - 有点像内存堆栈，两头向中间增长
    - log-structured
        - scan the log backwards and recreate the tuple
        - periodically compact the log
        - fast write, slow read
- tuple layout
    - header
    - each tuple has a unique record identifier (page_id + offset)
- data representation
    - large values (larger then page)
        - overflow page
        - external file
- system catalogs
- storage models
    - OLTP
        - simple query, read/update small amount of data
    - OLAP
        - complex query, read large portions of data
    - n-ary storage model
        - row store
        - fast inserts, updates, deletes
        - good for queries that need the entrie tuple
        - (good for OLTP
    - decomposition storage model
        - column store
        - tuple identification
        - better query processing and data compression
        - slow for point queries, inserts, updates, deletes
        - (good for OLAP

---

## buffer pools

---

- how to represent the datatbase in file on disk
- how to manage memory and move data back-and-forth from disk

---

- spatial && temporal
    - when to read pages into memory
    - when to write pages to disk
    - where to write pages on disk
- buffer pool is memory, page(datatbase files) is disk

---

- buffer pool, array of fixed-size pages, in-memory cache
- page table, track of pages that already in memory
    - page table, in memory, page_id to buffer pool
    - page directory, in disk, page_id to datatbase files
- dirty-flag
    - dirty pages will be written back to disk
- pin counter
- optimization
    - multiple buffer pools
    - pre-fetching
    - scan sharing

---

- locks
    - protect the database logical contents from other transactions
    - held for transactions duration
    - need to be able to rollback changes
- latches
    - protect the DBMS internal data structure from other threads
    - held for operation duration
    - do not need to be able to rollback changes

---

- buffer replacement
    - LRU
    - clock
    - LRU-K
    - localization
    - priority hints

---

## Hash

- DBMS data structure
    - meta-data
    - core data storage
    - temporary data sturctures
    - table index
- hash table
    - hash function
    - hashing schema
- open addressing hashing
- cuckoo hashing
    - multiple hash tables with different hash functions
- chained hashing
- extendible hashing
- linear hashing

---

## Trees Indexes

- DBMS data structure
    - meta-data
    - core data storage
    - temporary data sturctures
    - table index
- B-tree
- skip list
    - less memory but not cache friendly
- radix tree
- inverted indexes
    - full-text search indexes

---

## Index Concurrency Control

- lock vs latch(mutex)
    - read / write latch
    - 就是读写锁
- latch crabbing, allow multiple threads to access/modify B+Tree at the same time
    - get latch for parent
    - get latch for child
    - release latch for parent if child is safe node
        - safe node, will not split or merge when updated
        - not full on insertion or more than half full on deletion
- search
    - acquire latch on child and then unlatch parent
- insert/delete
    - set READ latches as if for search, go to leaf, and set WRITE latch on leaf.
    - if leaf is not safe, release all latches, restart transaction

---

## Query Processing

- query plan
    - use an index as much as possible
- processing model, how the system executes a query plan
    - iterator model / volcano model / pipeline model
        - top-down
        - each operator implement a `next` function, return a single tuple or null
        - allows for tuple pipelining
            - some operators will block (join, subquery, orderby)
        - general (OLTP, OLAP)
    - materialization model
        - bottom-up
        - each operator processes input all at once, then emits output all at once
        - better for OLTP
            - most OLTP only access a small number of tuples
    - vectorization model / batch model
        - top-down
        - every operator implement a `next` function, return a vector of data
        - ideal for OLAP
- access methods
    - sequential scan
        - optimizations
    - index scan
    - multi-index scan / bitmap scan
- expression evaluation

---

## Sorting & Aggregation Algorithms

- sorting
    - external merge sort
- aggregations (such as group by, distinct)
    - sorting
    - hashing

---

## Joins Algorithms

- join
    - use smaller table as outer table, DBMS will buffer outer table in memory
        - smaller means smaller `count(*)`
    - join operator output, tuple vs record_id
        - record_id, ideal for column store, called late materialization
    - IO cost analysis
- nested loop join
    - simple nested loop join
        - fetch every tuple (outer table) from disk
        - sequential scan
    - block nested loop join
        - fetch block (outer table) but not tuple
        - sequential scan
    - index nested loop join
        - outer table will be the one without the index
        - inner table will be the one with the index
- sort-merge join
    - useful if one or both tables are sorted on join attributes
    - sort table on join key, then perform a sequential scan on sorted table to compute the join
- hash join
    - split table into smaller chunks by hash algorithm
    - only be used for equi-joins
    - basic hash join
    - grace hash join
    - hashing is almost always better than sorting
        - sorting is better on non-uniform data
        - sorting is better when result needs to be sorted

---

## Query Optimization (TODO)

- rule-based query optimization (heuristics)
    - query rewriting
        - predicate push-down
        - projections push-down
        - expression simplification
- cost-based query optimization
    - cost model: CPU, disk, memory, network
- nested sub-query
    - sub-queries are writtern to a temporary table, and discarded after the query finishes

---

## Parallel Execution

- background
    - why
        - performance (throughput and latency)
        - availability
        - lower TCO (total cost of ownership)
    - parallel DBMS
        - communication is assumed to be fast and reliable
    - distributed DMBS
        - communication is slower and failures cannot be ignored
    - inter-query parallelism
        - executes different queries are concurrently
        - increases throughput and reduces latency
    - intra-query parallelism
        - executes the operations of a single query in parallel
        - decreases latency for long-running queries
        - intra-operator parallelism
        - inter-operator parallelism
- process models
    - process per worker
    - process pool
    - thread per worker
    - the DBMS always knows more than the OS
- execution parallelism
    - inter-query parallelism
        - 多个 query 并行
    - intra-query parallelism
        - 单个 query 内多个 operation 并行
        - intra-operator (horizontal)
            - 数据分块处理，再合并。分治。
        - inter-operator (vertical) / pipelined parallelism
            - 单行数据走完完整流程。流式处理。
            - common in stream processing systems
- I/O parallelism
    - multi-disk parallelism
    - partitioning (vertical / horizontal)

---

## Embedded Database Logic

- user-defined function
- stored procedure
- trigger
- change notification
- user-defined type
- view

---

## Logging Schemes

- crash recovery
    - UNDO: removing the effects of an incomplete or aborted transaction
    - REDO: re-installing the effects of a committed transaction
- failure classification
    - transaction failure
    - system failure
    - storage media failure
- buffer pool mamagement policy
    - steal policy: allows a transaction to write uncommitted changes to disk
    - force policy: ensure changes written to disk on committed
- shadow paging
    - NO-STEAL + FORCE
    - copy page table is expensive, commit overhead is high
    - two separate copies of the database (master, shadow)
    - update on the shadow copy, the shadow becomes the new master when transaction committed
- write-ahead logging
    - STEAL + NO-FORCE
    - fastest runtime performance, but recovery time is slow
    - records all the changes made to the database in a log file before the change is made to a disk page
    - checkpoints
        - the log file will grow forever
        - takes a checkpoint where DBMS flushes all buffers out to disk
    - schemes
        - physical logging
        - logical logging
        - physiological logging

---

## Distributed OLTP Database Systems

- system architecture
    - shared everything
    - shared memory
    - shared disk: aurora, spanner
        - a single logical disk
        - scale execution layer independently from the storage layer
    - shared nothing: tidb, redis
        - communicate via network
        - easy to increase capacity
        - hard to ensure consistency
- design issues
- partitioning schemes
    - native table partitioning
    - horizontal partitioning, partitioning key
        - physical partitioning (shared nothing)
        - logical partitioning (shared disk)
- distributed concurrency
    - distributed transaction requires expensive coordination
    - coordinator
- atomic commit protocol
    - two-phase commit, blocks if coordinator fails
    - paxos, non-blocking as long as a majority participants are alive
    - raft
    - zab
    - 2pc 要求所有节点状态一致，paxos 放宽了限制，大部分一致即可
- replication
    - master-replica vs multi-master
    - k-safety
    - synchronous vs asynchronous vs semi-synchronous
        - integrity vs performance
- consistency issues (CAP)
- federated databases

---

## Distributed OLAP Database Systems

- OLTP databases -> ETL -> OLAP database
- execution models
    - push query to data, send query to the node that contains the data
    - pull data to query, send the data to the node that executes query
    - fault tolerance
        - take snapshots of the intermediate result
        - use snapshots to recover after a crash
- query planning
    - physical operators
        - generate a single query plan
        - break up into partition-specific fragments
    - SQL
        - rewrite query into partition-specific queries
- distributed join algorithm
- cloud systems

---

## Concurrency Control Theory

- transaction
    - ACID
- atomicity
    - shadow paging vs logging
- consistency
    - TODO
- isolation
    - look like that transactions are executed in serial order
    - concurrency control protocol
        - pessimistic vs optimistic
- durability

---

## Two-Phase Locking

- locks
    - shared lock
    - exclusive lock
- 2PL is a pessimistic concurrency control protocol
    - growing, request locks
    - shrinking, release locks
    - 拿到锁、释放锁，两个阶段
- guarantee conflict serializability
    - serializable 的充分不必要条件
- strict 2PL
- deadlock handing
    - deadlock detection
        - waits-for graph, node is transaction (T), edge is T1 waits T2
    - deadlock prevention
        - assign priority (timestamp) to transaction
        - if T1 has higher priority than T2
            - if T1 waits T2, T1 waits
            - if T2 waits T1, T2 aborts
- lock granulary
    - intention locks
        - lock higher level node
        - not need to check all descendant nodes

---

## Timestamp Ordering

- timestamp ordering (T/O) is a optimistic concurrency control protocol
    - system clock, logical counter, hybrid
- optimistic concurrency control (OCC)
    - assume: conflicts are rare, transactions are short lived
    - creates a private workspace for each transaction
    - three phases: read, validation(when commit), write

---

## Multi-Version Concurrency Control

- The DBMS maintains multiple physical versions of a single logical object in the database
    - when a transaction writes to an object, the DBMS creates a new version of the object
    - when a transaction reads an object, it reads the newest version that existed when transaction started
- key property
    - writers don't block the readers
    - readers don't block the writers
- important MVCC design decisions
    - concurrency control protocol
        - 2PL, T/O, OCC
    - version storage
        - create a version chain per logical tuple
        - approach
            - append-only storage
                - oldest-to-newest
                - newest-to-oldest
            - time-travel storage
            - delta storage
    - garbage collection
        - remove reclaimable physical versions from database
        - approach
            - tuple level GC
                - background vacuuming
                - cooperative cleaning
            - transaction level GC
    - index management
        - primary key indexes
            - always point to version chain head
        - secondary indexes
            - approach
                - logical pointers
                - physical pointers
