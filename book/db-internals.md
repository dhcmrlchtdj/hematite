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



---

## distributed systems


