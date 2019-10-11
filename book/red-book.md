# Red Book

http://www.redbook.io

---

## Background

- hierarchical data format
    - (nobody ever seems to learn anything from history
    - (A decade ago, the buzz was all XML.
    - (Now it is JSON.
        - JSON is a reasonable choice for sparse data
        - 之前看 F1 还是 spanner 来着，用了 protobuf
- New data models have been invented, only to morph into SQL on tables
- Hierarchical structures have been reinvented with failure as the predicted result

吐槽了 JSON 和 MapReduce 模型

- the details of concurrency control, crash recovery, optimization, data structures and indexing are in a state of rapid change
- but the basic architecture of DBMSs remains intact
    - (the parsing/optimizer/executor structure

---

## Traditional RDBMS Systems

- System R
    - SQL
    - transaction
    - ODBC
        - subroutine call interface (couple a client application to the DBMS)
        - (language-specific embedding is better
    - 作者对 SQL 很不满嘛
- Postgres
    - abstract data type (ADT) system (user-defined types/functions
    - (open source distribution model and a generation of highly trained DBMS implementers
- Gamma
    - shared-nothing partitioned table approach
    - hash-join

好像没什么特别可讲的

---

## Techniques Everyone Should Know

- query plan/ query optimization
    - three distinct subproblems
        - cost estimation
        - relational equivalences that define a search space
        - cost-based search
    - use of binary operators and cost estimation

- concurrency control
    - isolation
    - lock-based serializability
        - multi-granularity locking
        - strict 2PL

- database recovery
    - WAL, write-ahead logging
    - ARIES algorithm (No Force, Steal
        - the database need not write dirty pages to disk at commit time (No force
        - the database can flush dirty pages to disk at any time (Steal

- distribution
    - benefits to capacity, durability, and availability
    - servers may fail, network links may be unreliable, network communication may be costly
    - distributed transaction processing, atomic commitment (AC)
        - a transaction that executes on multiple servers (whether multiple replicas, multiple partitions, or both)
        - AC ensures that the transaction either commits or aborts on all of them
        - 2PC
    - consensus
        - ("easier" than AC
        - Paxos, Multi-Paxos, Viewstamped Replication, Raft, ZAB

---







