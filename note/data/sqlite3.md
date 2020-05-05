# sqlite3

---

## Architecture of SQLite

https://www.sqlite.org/arch.html

---

SQL 被编译成 bytecode，然后 virtual machine 执行 bytecode，完成数据读写。
（还没看代码，应该也还是 volcano 模型？

---

> Having the tokenizer call the parser is better because it can be made threadsafe and it runs faster.

> Lemon also generates a parser which is reentrant and thread-safe.
> it does not leak memory when syntax errors are encountered.

这是暗示 yacc 等工具，碰到错误的语法会内存泄漏？

parser 之后，codegen 生成 bytecode，生成过程中进行 query optimization。

---

> The default page_size is 4096 bytes but can be any power of two between 512 and 65536 bytes.

page 默认是 4K 大小

> The page cache also provides the rollback and atomic commit abstraction and
> takes care of locking of the database file.

---

## Query Optimizer

---

https://www.sqlite.org/optoverview.html

---

> Application developers can use the EXPLAIN QUERY PLAN prefix on a statement to
> get a high-level overview of the chosen query strategy.

explain 属于必备技能吧

---

> SQLite uses a cost-based query planner that estimates the CPU and disk I/O
> costs of various competing query plans and chooses the plan that it thinks
> will be the fastest.

（SQLite 支持 cost-based query planner，简单的 rule-based 真是不够看

---

`CREATE INDEX idx_a_b ON table(a,b)` 就不需要再定义一个 `idx_a` 了，几个数据库都是一样的。

---

有个 skip-scan optimization 有点意思。

比如有个索引 `CREATE INDEX people_idx ON people(role, height)`
这时候查询 `SELECT name FROM people WHERE height>=180`，索引派不上用场。
如果 `ANALYZE people` 之后发现 role 很少，查询可以被改写成 `SELECT name FROM people WHERE height>=180 AND role IN (SELECT DISTINCT role FROM people)`，这样就能用上索引了。

---

> The current implementation of SQLite uses only loop joins.

不知道文档描述的是不是现状

> SQLite chooses to never reorder tables in a CROSS JOIN.
> This provides a mechanism by which the programmer can force SQLite to choose
> a particular loop nesting order.

可以通过 cross join 指定 nest loop 的驱动表

---

> The ANALYZE command scans all indices of database where there might be a
> choice between two or more indices and gathers statistics on the selectiveness
> of those indices.

查询匹配多个索引，优先用哪个？analyse 可以帮助数据库找到更合适的索引。

> The results of an ANALYZE command are only available to database connections
> that are opened after the ANALYZE command completes.

---

> When doing an indexed lookup of a row, the usual procedure is to do a binary
> search on the index to find the index entry, then extract the rowid from the
> index and use that rowid to do a binary search on the original table.

clustered index 这个问题，最近才知道

> an index contains all of the data needed for a query

这种情况，就不需要再查找一次整表了

---

> SQLite attempts to flatten subqueries in the FROM clause of a SELECT

from (select ... from ...) 会被试着转换成 join

---

> When no indices are available to aid the evaluation of a query, SQLite might
> create an automatic index that lasts only for the duration of a single SQL
> statement.

没有索引，会试着临时创建一个索引。
比如 join 两个表会是 O(N*M)，而创建索引开销是 O(NlogN) + O(MlogM)，有索引后查询是 O(N+M)。

---

https://www.sqlite.org/queryplanner.html

---

> the rowids are always unique and in strictly ascending order

> a good rule of thumb is that your database schema should never contain two indices where one index is a prefix of the other.

left-most 的索引

> SQLite always tries to do a partial sort using an index even if a complete sort by index is not possible.

会创建临时索引

---

介绍了 clustered index 是如何工作的（我总觉得 clustered index 缺点大于优点
图文并貌，清晰易懂

讲 sort 的时候
全部找出来再排序，复杂度 O(NlogN)
按索引排序，遍历索引获取 rowid O(N)，根据 rowid 查找 O(logN)，也是 O(NlogN)
如果 index 能 cover 输出，那确实不错。不过空间成本、维护成本变高了

---

https://www.sqlite.org/queryplanner-ng.html

---

> When the Query Planner Stability Guarantee (QPSG) is enabled SQLite will always pick the same query plan for any given SQL statement

其他条件不变，query plan 就不会变（让执行过程更加可测
条件，包括 analyze 等数据统计

> This is one reason you should consider statically linking your applications
> against SQLite rather than use a system-wide SQLite shared library which might
> change without your knowledge or control.

如果要保证 plan 不变，推荐静态链接

---

> The problem of finding the best query plan is equivalent to finding a
> minimum-cost path through the graph that visits each node exactly once.

> Prior to version 3.8.0 (2013-08-26), SQLite always used the
> "Nearest Neighbor" or "NN" heuristic when searching for the best query plan.
> The NN heuristic makes a single traversal of the graph, always choosing the
> lowest-cost arc as the next step. The NN heuristic works surprisingly well in
> most cases. And NN is fast, so that SQLite is able to quickly find good plans
> for even large 64-way joins.

> The NGQP uses a new heuristic for seeking the best path through the graph:
> "N Nearest Neighbors" (hereafter "N3"). With N3, instead of choosing just one
> nearest neighbor for each step, the algorithm keeps track of the N bests paths
> at each step for some small integer N.

> The initial implementation of NGQP chooses N=1 for simple queries, N=5 for
> two-way joins and N=10 for all joins with three or more tables.

join 的处理，从 nearest neighbor 到 N nearest neighbor

---

## Isolation

https://www.sqlite.org/isolation.html

---

> SQLite implements serializable transactions by actually serializing the writes.

只允许一个 writer，实现 serializable
（简单粗暴

> There can only be a single writer at a time to an SQLite database.
> There can be multiple database connections open at the same time, and all of
> those database connections can write to the database file, but they have to
> take turns.

---

> readers can continue to read the old, original, unaltered content from the
> original database file at the same time that the writer is appending to the
> write-ahead log.

> In WAL mode, SQLite exhibits "snapshot isolation".

---

> No Isolation Between Operations On The Same Database Connection.

隔离以 connection 为单位

> A query sees all changes that are completed on the same database connection
> prior to the start of the query, regardless of whether or not those changes
> have been committed.

---

## rollback journal transaction

https://www.sqlite.org/atomiccommit.html

---

> The information in this article applies only when SQLite is operating in "rollback mode".

这篇文档介绍 rollback journal 的流程，WAL 则是另一套机制

第二节写了很多 hardware assumption
如果真碰到数据异常，可以看下是不是硬件支持出问题了

从后面的图例看，sqlite 也使用了 OS buffer，没有直接操作硬盘（是这样吗

---

shared lock
reserved lock
pending lock
exclusive lock

中间有个 reserved lock，可以和 shared lock 共存，但是和其他 reserved lock 互斥

> a reserved lock signals that a process intends to modify the database file in
> the near future but has not yet started to make the modifications.

之后还有个 pending lock，会拒绝新的 shared lock
这个阶段是等待其他 shared lock 结束，好进入 exclusive lock

> pending lock prevent writer starvation caused by a large pool of readers.

---

> flush takes up most of the time required to complete a transaction commit in SQLite.

写入 rollback journal 和 page，等待 fsync 是事务中耗时最长的操作

---

> SQLite gives the appearance of having made no changes to the database file or
> having made the complete set of changes to the database file depending on
> whether or not the rollback journal file exists.

要不要回滚，看 rollback journal 删除了没。（很粗暴

> Deleting a file is not really an atomic operation, but it appears to be from
> the point of view of a user process.

对进程而言，文件是否已删除，可以视为原子操作

事务执行情况由这个删除决定，所以整个事务也就视为原子的

> if any part of the header is malformed the journal will not roll back

这个属于对删除操作的优化，修改 journal 内容。
但修改操作不是原子的，所以加了这样的判断，header 数据不对就视为不需要回滚。

---

sqlite 是单文件，不过也可以多文件

> When multiple database files are involved in a transaction, each database has
> its own rollback journal and each database is locked separately.

还是每个文件都有自己的 rollback journal

> the master journal contains the full pathnames for rollback journals for every
> database that is participating in the transaction.

为了保证多文件修改的原子性，写入时会生成 master journal
用法和单文件的 rollback journal 其实是一样的

---

rollback journal 记录的是修改前的内容。
每次 disk 写入都以 sector 为单位，所以会浪费一定空间。
（每个 sector 包含多个 page，每个 page 包含多个 tuple

---

完整看下 rollback journal 实现 transaction 的流程

- 数据从 disk -> os buffer -> user space，此时 buffer 需要 shared lock
- 数据都 user space 后，buffer 上升级为 reserved lock
- 将 user space 数据复制到 rollback journal
- 修改 user space 数据
- flush rollback journal 到 disk
- 将 buffer 的锁升级为 exclusive lock （先 pending lock 再 exclusive lock
- 修改写入 buffer，再 flush 到 disk
- 删除 rollback journal
- 释放 exclusive lock

---

目前 rollback journal 仍是默认行为

可以通过 `PRAGMA journal_mode` 查询使用的模式

---

## WAL

https://www.sqlite.org/wal.html

---

> WAL provides more concurrency as readers do not block writers and a writer does not block readers.

这不是 wal 而是 mvcc 了吧

---

> The traditional rollback journal works by writing a copy of the original
> unchanged database content into a separate rollback journal file and then
> writing changes directly into the database file.
> In the event of a crash or ROLLBACK, the original content contained in the
> rollback journal is played back into the database file to revert the database
> file to its original state.
> The COMMIT occurs when the rollback journal is deleted.

rollback journal 是将旧内容复制一份
commit 时丢弃 rollback journal
abort 时从 journal 里拿回数据

这个过程，前面的 rollback journal transaction 也讲了

因为修改是要加锁的，所以 writer block reader

---

> The original content is preserved in the database file and the changes are
> appended into a separate WAL file.
> A COMMIT occurs when a special record indicating a commit is appended to the WAL.
> Thus a COMMIT can happen without ever writing to the original database, which
> allows readers to continue operating from the original unaltered database
> while changes are simultaneously being committed into the WAL.

> Multiple transactions can be appended to the end of a single WAL file.

wal 是新内容写入 log
commit 时，log 加一个 commit 标记（此时 reader 还可以读到旧 db （snapshot

---

> in the rollback-journal approach, there are two primitive operations, reading and writing
> in the write-ahead log there are now three primitive operations: reading, writing, and checkpointing.

---

> When a read operation begins on a WAL-mode database, it first remembers the
> location of the last valid commit record in the WAL. Call this point the
> "end mark".

> When a reader needs a page of content, it first checks the WAL to see if that
> page appears there, and if so it pulls in the last copy of the page that
> occurs in the WAL prior to the reader's end mark.

从这段话看，WAL 修改 tuple 后，会在 buffer 里保存一个不同版本的 page
其他事务根据 end mark 决定读取 WAL 的 page 还是 disk 的 page

> read performance deteriorates as the WAL file grows in size since each reader
> must check the WAL file for the content and the time needed to check the WAL
> file is proportional to the size of the WAL file

因为要查找 WAL 内容，所以读性能会有一定损失

---

> Readers can exist in separate processes

> a data structure called the "wal-index" is maintained in shared memory which
> helps readers locate pages in the WAL quickly and with a minimum of I/O.

> the use of shared memory means that all readers must exist on the same machine

为了让多个进程之间共享 WAL，在共享内容维护了 wal-index
这个共享内存也导致 WAL 只支持单机（不过 sqlite 的使用场景也不需要多机吧

---

> A checkpoint can run concurrently with readers

因为 checkpoint 本身也只是读取 WAL 的内容

> a long-running read transaction can prevent a checkpointer from making progress.
> presumably every read transaction will eventually end and the checkpointer will be able to continue.

checkpoint 会等待其他 read 完成，再清理 WAL，不然其他事务正在读取的内容可能被清理掉
这就导致了这里提到的 long-runing read 问题
而且这个 presumably，看起来 sqlite 不准备处理这个问题…

> A checkpoint is only able to run to completion, and reset the WAL file
> A checkpoint can only complete when no other transactions are running

怎么感觉 checkpoint 有点像 GC 的 STW
尽可能并行，最后还是要独占一下

---

> since there is only one WAL file, there can only be one writer at a time.

文档没有说，不过估计又是直接加锁

> Write transactions are very fast since they only involve writing the content
> once (versus twice for rollback-journal transactions) and because the writes
> are all sequential.

rollback journal 需要 flush page 和 journal
WAL 只要 flush journal，还是线性添加

---

> By default, SQLite does a checkpoint automatically when the WAL file reaches a
> threshold size of 1000 pages.

sqlite 的 page 默认是 4K，所以差不多是 4M 才更新一次数据库。
（当然，可以调

---

## Autoincrement

https://www.sqlite.org/autoinc.html

---

> a column with type INTEGER PRIMARY KEY is an alias for the rowid, a 64bit signed integer.

> the purpose of AUTOINCREMENT is to prevent the reuse of ROWIDs from previously deleted rows.

> If the largest ROWID is equal to the largest possible integer (9223372036854775807)
> then the database engine starts picking positive candidate ROWIDs at random
> until it finds one that is not previously used.

rowid 也是自增的，不过会复用被删除的 rowid
用 AUTOINCREMENT 可以保证不复用之前用过的 rowid
如果插入时碰到 unique 冲突，会导致 AUTOINCREMENT 的值出现中断

sqlite 自动插入的 rowid 都是正数，不过用户可以自己强制插入复数

---

> SQLite keeps track of the largest ROWID using an internal table named "sqlite_sequence".
> The sqlite_sequence table does not track ROWID changes associated with UPDATE statement, only INSERT statements.
> The content of the sqlite_sequence table can be modified using ordinary UPDATE, INSERT, and DELETE statements.

假设 id 字段是 INTEGER PRIMARY KEY AUTOINCREMENT
sqlite 会在 insert 时更新 id 的值，会忽略用户 update id 的行为
以及，可以强制修改 sqlite_sequence 来影响 AUTOINCREMENT 的行为

---

## blob

https://www.sqlite.org/intern-v-extern-blob.html

---

> A database page size of 8192 or 16384 gives the best performance for large BLOB I/O.

> For BLOBs smaller than 100KB, reads are faster when the BLOBs are stored
> directly in the database file. For BLOBs larger than 100KB, reads from a
> separate file are faster.

blob 数据直接存数据库里，还是文件放硬盘，数据库存储文件地址

sqlite 默认 page 是 4K，根据 sqlite 的 benchmark
5M 以内的 blob 可以放在 sqlite 里保存
如果是 10M 的 blob，可以把 page 调整到 8K/16K，性能也不差
更大的文件，就不适合放 sqlite 里了

（结合硬件，自己再 benchmark 吧

---

## Bytecode Engine

https://www.sqlite.org/opcode.html

---

> SQLite works by translating each SQL statement into bytecode and then running
> that bytecode.
> The sqlite3_prepare_v2() interface is a compiler that translates SQL into
> bytecode (prepared statement).
> The sqlite3_step() interface is the virtual machine that runs the bytecode
> contained within the prepared statement.

sqlite 工作的时候，将 SQL 编译成 bytecode，然后执行 bytecode 获得数据。
（sqlite 里 prepared statement 和 bytecode 基本就是一回事

sqlite 里 explain 输出的，也是 bytecode（opcode

> the bytecode engine in SQLite is called the "Virtual DataBase Engine" or "VDBE"

---

> Each instruction has an opcode and five operands named P1, P2 P3, P4, and P5.

---

> The bytecode engine has no stack on which to store the return address of a
> subroutine. Return addresses must be stored in registers. Hence, bytecode
> subroutines are not reentrant.

> Coroutines are often used to implement subqueries from which content is pulled
> on an as-needed basis.

> Triggers need to be reentrant.
> Each trigger is implemented using a separate bytecode program with its own
> opcodes, program counter, and register set.
> subprograms can be reentrant and recursive

感觉这个 virtual machine 还挺复杂的

---

## without rowid

https://www.sqlite.org/withoutrowid.html

---

> A WITHOUT ROWID table is a table that uses a Clustered Index as the primary key.
> Every WITHOUT ROWID table must have a PRIMARY KEY.

without rowid 才是 clustered index

---

> The only advantage of a WITHOUT ROWID table is that it can sometimes use less
> disk space and/or perform a little faster than an ordinary rowid table.

> In an ordinary SQLite table, the PRIMARY KEY is really just a UNIQUE index.

我理解，都是 clustered index，只不过 without rowid 才允许用户自己指定 index key。
比如用 text 做 primary key，查询的时候就不用再走一次 rowid 查询。

---

> The WITHOUT ROWID optimization is likely to be helpful for tables that have
> non-integer or composite (multi-column) PRIMARY KEYs and that do not store
> large strings or BLOBs.

有一些奇怪的限制

> AUTOINCREMENT does not work on WITHOUT ROWID tables.
> The incremental blob I/O mechanism does not work for WITHOUT ROWID tables.

---

> WITHOUT ROWID tables work best when individual rows are not too large.
> A good rule-of-thumb is that the average size of a single row in a WITHOUT
> ROWID table should be less than about 1/20th the size of a database page.
> (about 200 bytes each for 4KiB page size

---

> rowid tables are implemented as B*-Trees where all content is stored in the
> leaves of the tree
> WITHOUT ROWID tables are implemented using ordinary B-Trees with content
> stored on both leaves and intermediate nodes.

rowid 是 b*-tree
without rowid 是 b-tree

---

## File Format

https://www.sqlite.org/fileformat2.html

---

> The size of a page is a power of two between 512 and 65536 inclusive

page 默认是 4K

> The maximum page number is 2147483646 (2^31 - 2)

文件最大 65535 * (2^31 - 2) = 140 TB
文件最小 512 * 1 = 512 B

> terabyte-size SQLite databases are known to exist in production

震惊

---

> The application ID is intended for database files used as an application
> file-format. The application ID can be used by utilities such as file(1) to
> determine the specific file type rather than just reporting "SQLite3 Database".

试了下，好像没什么用

---

> Each ordinary SQL table in the database schema is represented on-disk by a
> table b-tree.
> The rowid of the SQL table is the 64-bit signed integer key for each entry in
> the table b-tree.

> A WITHOUT ROWID table uses an index b-tree rather than a table b-tree for storage.

---

table b-tree, "B*-Tree" stores all data in the leaves of the tree

index b-tree, "B-Tree" stores both the key and the data together in both leaves and in interior pages

查了下，b*-tree 是 b+-tree 的变种。
