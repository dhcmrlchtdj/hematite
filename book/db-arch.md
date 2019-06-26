# Architecture of a Database System

http://db.cs.berkeley.edu/papers/fntdb07-architecture.pdf

---

## process model

---

> A DBMS Worker is the thread of execution in the DBMS that
> does work on behalf of a DBMS Client.

本章讲 DBMS worker 和 process 的对应关系
进程模型如何支持并发的用户请求

- process per DBMS worker
- thread per DBMS worker
- process/thread pool

---

## process and memory coordination

---

- shared-memory
    - CPU 共享内存、硬盘
- shared-nothing
    - 网络通信
- shared-disk
    - CPU 共享硬盘，不共享内存

---

## relational query processor

---

> relational query processing can be viewed as a single-user, single-threaded task.
> concurrency control is managed transparently by lower layers of the system

分层大法好

---

> A relational query processor takes a declarative SQL statement, validates it,
> optimizes it into a procedural dataflow execution plan, and executes that
> dataflow program on behalf of a client program.

解析验证 SQL，然后执行。
（主要针对 DML，其他的如 DDL 不通过 query optimizer 处理

- rewriter
    - View expansion
    - Constant arithmetic evaluation
    - Logical rewriting of predicates
    - Semantic optimization
    - Subquery flattening and other heuristic rewrites

---

## storage management

---

- two types of DBMS storage managers
    - interact with low-level block-mode device drivers for the disk (raw-mode access)
    - use standard OS file system facilities

- 空间（spatial）
- 时间（temporal）
    - buffer
    - write ahead logging

---

## transactions

---

- Concurrency Control and Recovery
- ACID
- serializability
    - strict two-phase locking (2PL)
    - Multi-Version Concurrency Control (MVCC)
    - Optimistic Concurrency Control (OCC)
- Isolation Levels
    - READ UNCOMMITTED
    - READ COMMITTED
    - REPEATABLE READ
    - SERIALIZABLE
    - CURSOR STABILITY
    - SNAPSHOT ISOLATION
    - READCONSISTENCY

---

- SQL 语句优化
- 事务
