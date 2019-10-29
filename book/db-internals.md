# database internals

---

## storage engines

---

- architecture
    - transport (request -> query)
        - cluster communication
        - client communication
    - query processor (query -> query plan)
        - query parser
        - query optimizer
    - execution engine (query plan -> result)
        - remote execution
        - local execution
    - storage engine
        - buffer manager
        - recovery manager
        - access methods / storage structures
        - transaction manager
        - lock manager
- memory-based, disk-based
- column-oriented, row-oriented, wide column
    - depend on access patterns
- data files, index files
    - primary index, secondary index
- storage structure, buffering, immutability, ordering

---

- B-Tree
    - high fanout and low height
        - the desired properties for an optimal on-disk data structure
        - fanout: the number of keys stored in each node
    - efficiently execute both point and range queries
    - (B+-Tree store values only in leaf nodes
    - operations
        - lookup
        - insert and split
        - remove and merge
    - use buffering to reduce write amplification (which is caused by page rewrites)
    - use immutability to reduce space amplification (which is caused by the reserve space in nodes for futere writes)
    - variants
        - copy-on-write B-Tree
        - lazy B-Tree
        - FD-Tree
        - Bw-Tree
        - cache-oblivious B-Tree

- Log-Structured Merge Tree
    - useful for applications where writes are far more common than reads
    - all reads/writes are applied to a memory-resident table (memtable)
    - read, write, and space amplification
    - RUM Conjecture (Read, Update, and Memory) （又是三选二

---


- on-disk B-Tree is a page management mechanism
    - algorithms have to compose and navigate pages

- file formats
    - binary format
        - the main principle to create efficient page layouts
        - primitive types (integer, float, date, ...)
            - fixed size
            - represented (serialized to and deserialized from) in their raw binary forms
        - string and variable-size data
            - size + data
        - bit-packed data (boolean, enum, flag, ...)
            - bit
    - starts with a fixed-size header and may ends with a fixed-size trailer
        - header + page list + trailer
    - store records in data files and index files
        - files are partitioned into fixed-size units called pages
    - split the page into fixed-size segments, to simplify space management for variable-size records
    - slotted pages
    - cell layout (for flag, enum, primitive)
    - version
        - version prefixes in filenames
        - version stores in a separate file
        - version stores in the index file header (magic number)
    - checksum / CRC
        - compute before writing to disk
        - write checksum together with the data

---

- transaction
    - ACID
- buffer
    - page cache, cache pages read from disk in memory
    - dirty, flush back, evicte
    - this synchronization is a one-way process: from memory to disk
    - eviction policy: FIFO, LRU, CLOCK, LFU, ...
- recovery
    - write-ahead log (WAL)
    - every record has a unique, monotonically increasing log sequence number (LSN)
    - physical log, logical log
    - Steal policy, Force policy
        - steal, allows flushing a page that modified by uncommitted transactions
        - force, requires to flush all dirty page to disk before committing transaction
    - ARIES
        - steal + no-force
        - logical log for undo, physical log for redo
- concurrency control
    - category
        - pessimistic concurrency control (PCC)
        - optimistic concurrency control (OCC)
        - multiversion concurrency control (MVCC)
    - read anomaly: dirty read, nonrepeatable read (read a row), phantom read (read a set of rows)
    - write anomaly: lost update, dirty write, write skew
    - isolation level
        - serializability
            - multiple operations executed in arbitrary order
            - as if transactions were executed serially
            - does not imply or impose any particular order on executing transactions
            - isolation in ACID means serializability
    - OCC
        - read, validate, write
    - MVCC
        - at most one uncommitted value at a time
        - MVCC can be implemented by 2PL or timestamp ordering
        - use MVCC to implement snapshot isolation
    - PCC
        - PCC can be implemented by 2PL pr timestamp ordering
        - deadlock
            - timeout and abort
            - waits-for graph
            - priority
        - lock and latch
            - latch crabbing

---

## distributed systems


