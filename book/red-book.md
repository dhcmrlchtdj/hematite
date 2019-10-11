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

