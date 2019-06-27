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

---

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

---

- DBMS data structure
    - meta-data
    - core data storage
    - temporary data sturctures
    - table index

---

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

---

- DBMS data structure
    - meta-data
    - core data storage
    - temporary data sturctures
    - table index

---

- B-tree
- skip list
    - less memory but not cache friendly
- radix tree

---

- inverted indexes
    - full-text search indexes

---

## Index Concurrency Control

---

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

