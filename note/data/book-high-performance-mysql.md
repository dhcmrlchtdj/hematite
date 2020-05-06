# high performance mysql

---

## 1. MySQL Architecture and History

---

> Much of MySQL’s brains are here, including the code for query parsing,
> analysis, optimization, caching, and all the built-in functions (e.g., dates,
> times, math, and encryption).
> Any functionality provided across storage engines lives at this level:
> stored procedures, triggers, and views, for example.

mysql 的 query optimization 等步骤，和 engine 是无关的

> The optimizer asks the storage engine about some of its capabilities and the
> cost of certain operations, and for statistics on the table data.

optimizer 和 engine 还是有相互作用的。

---

> MySQL operates in AUTOCOMMIT mode by default.

---

> the underlying storage engines implement transactions themselves.
> you can’t reliably mix different engines in a single transaction.

> MySQL will not usually warn you or raise errors if you do transactional
> operations on a nontransactional table.

其实现在都是用 InnoDB 了吧，所以应该不会碰到这个问题

---

> Because MySQL uses the filesystem to store database names and table
> definitions, case sensitivity depends on the platform.

大小写看系统，这个行为有点怪异

---

> InnoDB tables are built on a clustered index.
> it provides very fast primary key lookups.
> secondary indexes contain the primary key columns, so if your primary key is
> large, other indexes will also be large.

clustered index

---

> InnoDB defaults to the REPEATABLE READ isolation level, and it has a next-key
> locking strategy that prevents phantom reads in this isolation level: rather
> than locking only the rows you’ve touched in a query, InnoDB locks gaps in the
> index structure as well, preventing phantoms from being inserted.

---

## 4. Optimizing Schema and Data Types

---

> It’s harder for MySQL to optimize queries that refer to nullable columns,
> because they make indexes, index statistics, and value comparisons more
> complicated.
> The performance improvement from changing NULL columns to NOT NULL is usually
> small.

怎么感觉这两句话互相矛盾呢…

> InnoDB stores NULL with a single bit, so it can be pretty space-efficient for
> sparsely populated data.

在 InnoDB 下，NULL 的空间利用率较好。

---

> Your choice determines how MySQL stores the data, in memory and on disk.
> However, integer computations generally use 64-bit BIGINT integers.

TINYINT/SMALLINT/MEDIUMINT/INT/BIGINT 只是存储，运算时都是 BIGINT

> you’re choosing only the storage type; MySQL uses DOUBLE for its internal
> calculations on floating-point types.

FLOAT/DOUBLE 只是存储，运算时都是 double

> A DECIMAL number in MySQL 5.0 and newer can have up to 65 digits.

---

> VARCHAR uses 1 or 2 extra bytes to record the value’s length

较短的字符串，可以用 CHAR
定长的字符串，可以用 CHAR
经常修改的，也可以用 CHAR，因为修改 VARCHAR 容易产生碎片

---

> The finest granularity of time MySQL can store is one second.

不知道有没有更新

> The value a TIMESTAMP displays also depends on the time zone

---

> it’s better to use NULL than a magical constant

---

## 5. Indexing for High Performance

---

> The InnoDB storage engine has a special feature called adaptive hash indexes.
> When InnoDB notices that some index values are being accessed very frequently,
> it builds a hash index for them in memory on top of B-Tree indexes.

虽然不能控制这个行为

---

> a three-star system for grading how suitable an index is for a query.
> The index earns one star if it places relevant rows adjacent to each other,
> a second star if its rows are sorted in the order the query needs,
> and a final star if it contains all the columns needed for the query.

对比 index cost 的一个方法

---

> Updating the clustered index columns is expensive, because it forces InnoDB to
> move each updated row to a new location.

我对 clustered index 的理解没错，确实更新 key 要移动数据。
所以最佳实践应该是软删除，只做追加数据？

> Secondary index accesses require two index lookups instead of one.
> a leaf node doesn’t store a pointer to the referenced row’s physical location;
> rather, it stores the row’s primary key values.

这是 clustered index 最大的问题了。

为什么不存储 physical location 呢？
大概是关于 index 更新的 trade-off
因为存储的是 primary key，所以修改无关字段的时候，不需要修改 secondary index。
如果存储的是 physical location，每次修改 tuple，所有 index 都要更新。
（PG 不适合 update-heavy 的原因，虽然 PG 搞出了 HOT

> In InnoDB, the adaptive hash index can help reduce this penalty.

大家都不傻，都有针对性优化

> It is best to avoid random (nonsequential and distributed over a large set of
> values) clustered keys, especially for I/O-bound workloads.
> using UUID values is a poor choice from a performance standpoint

> you should probably do an OPTIMIZE TABLE to rebuild the table and fill the
> pages optimally.

乱序插入后，最好 optimize 一下

---

虽然现在可能没什么人用了，MyISAM 是 heap 的方式存储数据的

---

> InnoDB can place shared (read) locks on secondary indexes, but exclusive
> (write) locks require access to the primary key.

没太明白，为什么

---

## 6. Query Performance Optimization

---

> using too many queries is a common mistake in application design.

> but sometimes you can make a query more efficient by decomposing it and
> executing a few simple queries instead of one complex one.

要不要把一个复杂查询，拆分成几个小查询。
约等于什么都没说

---

> Many high-performance applications use join decomposition.
> performing the join in the application

在应用里做 join，而不是在数据库完成。好处呢？
（后文说，mysql 只有 nested-loop 一种方式做 join，所以部分场景应用自己做可能确实会更快吧

> doing joins in the application can be more efficient when
> you cache and reuse a lot of data from earlier queries,
> you distribute data across multiple servers,
> you replace joins with IN() lists on large tables,
> or a join refers to the same table multiple times.

我还是觉得应用层做，数据一致性很可能出问题

---

> Before even parsing a query, MySQL checks for it in the query cache.
> This operation is a case-sensitive hash lookup.

case-sensitive 可能需要注意一下，毕竟 sql 关键字不区分大小写

> MySQL check privileges before returning the cached query.
> MySQL retrieves the stored result from the query cache and sends it to the client.

我以为缓存的之前解析过的语句，居然直接缓存查询结果。
怎么判断缓存失效？

---

> At the moment, MySQL’s join execution strategy is simple:
> it treats every join as a nested-loop join.

之前和 sqlite 一样啊，不知道现在如何

---

> a join over n tables will have n-factorial combinations of join orders to examine.

其实，业务里不会 join 太多张表吧

---

> the query execution plan is actually a tree of instructions that the query
> execution engine follows to produce the query results

就像是 ast intepreter。
感觉 sqlite 的 bytecode vm 听着更厉害。

---

## 7. Advanced MySQL Features

---

> There’s a limit of 1,024 partitions per table.
> Any primary key or unique index must include all columns in the partitioning
> expression.
> You can’t use foreign key constraints.

partition 的一些限制

---

> The easiest way for the server to implement a view is to execute its SELECT
> statement and place the result into a temporary table.

> A better way to implement views is to rewrite a query that refers to the view,
> merging the view’s SQL with the query’s SQL.

实现 view 的两种方案，在 MySQL 里称为 TEMPTABLE 和 MERGE。
用 explain 可以查看 view 使用哪种方式实现。

如果用了 group by/distinct/union/subquery 等等，导致 view 和 table 的 row 不是 1:1 的，就会使用 TEMPTABLE。

> A view is not updatable if it contains GROUP BY, UNION, an aggregate function,
> or any of a few other exceptions.

能否 update view，大概和 TEMPTABLE 一样的限制吧

> MySQL does not support the materialized views.
> A materialized view generally stores its results in an invisible table behind
> the scenes, with periodic updates to refresh the invisible table from the
> source data.

也就是说，temptable 每次查询都要重新构建吗

---

> Foreign keys typically require the server to do a lookup in another table
> every time you change some data.
> which means acquiring locks

foreign key 为了保证一致性，要查询其他表。查询意味着需要加锁。

> Foreign keys are useful for cascading deletes or updates.

除了一致性，级连的修改也很有用

> Instead of using foreign keys as constraints, it’s often a good idea to
> constrain the values in the application.
> Foreign keys can add significant overhead.

不过性能确实是问题

---

> When you create a prepared statement, the client library sends the server a
> prototype of the actual query you want to use.
> The server parses and processes this “skeleton” query, stores a structure
> representing the partially optimized query, and returns a statement handle to
> the client.
> The client library can execute the query repeatedly by specifying the statement handle.

client 要维护一个 sql 到 handle 的映射？

---

> A character set is a mapping from binary encodings to a defined set of symbols;
> you can think of it as how to represent a particular alphabet in bits.
> A collation is a set of sorting rules for a character set.

不太喜欢 mysql 的字符串处理，那个 utf8 不知道坑了多少人…
不过字符串本来就复杂就是了…

> MySQL uses fixed-size buffers internally for many string operations, so it
> must allocate enough space to accommodate the maximum possible length.

等于说 utf8 都需要 4byte 空间

---

> a distributed (XA) transaction is a higher-level transaction that can extend
> some ACID properties outside the storage engine—and even outside the
> database—with a two-phase commit

2PC

> any cross-engine transaction is distributed by nature and requires a third
> party to coordinate it. That third party is the MySQL server.

看起来是 server 用 2PC 协调多个 storage engine

---

> The query cache keeps track of which tables a query uses, and if any of those
> tables changes, it invalidates the cache entry.
> it’s a simple approach with low overhead, which is important on a busy system.

query cache 在 table 变更后自动失效
（我还是觉得可以缓存处理好的 SQL，还是说这个缓存收益不高

> As servers have gotten larger and more powerful, the query cache has
> unfortunately proven not to be a very scalable part of MySQL.
> disable it by default, and configure a small query cache (no more than a few
> dozen megabytes) only if it’s very beneficial.

多核场景下会造成性能问题，所以作者建议直接关掉 cache。
（盲猜，mysql 是多线程的，是多线程读写需要锁导致的性能问题？

> When a statement inside a transaction modifies a table, the server invalidates
> any cached queries that refer to the table.
> The table is also globally uncacheable until the transaction commits, so no
> further queries against that table can be cached until the transaction commits.

事务会导致缓存失效。
我理解是因为 MySQL 的失效判断粒度较粗，但粒度细又可能导致 overhead 过大。
最终导致怎么搞，缓存收益都很有限。

---

## 10. Replication

---

> MySQL supports two kinds of replication: statement-based replication and
> row-based replication.
> Both kinds work by recording changes in the master’s binary log and replaying
> the log on the replica, and both are asynchronous.

两种方案，statement-based 和 row-based
都只能异步这点，不会有点难受吗…

---

> Replica doesn’t poll for events. If it catches up to the master, it goes to
> sleep and waits for the master to signal it when there are new events.

由 master 主动发数据到 replicas

---

> 1. The master records changes to its data in its binary log. (These records are called binary log events.)
> 2. The replica copies the master’s binary log events to its relay log.
> 3. The replica replays the events in the relay log, applying the changes to its own data.

流程三步走

> This replication architecture decouples the processes of fetching and
> replaying events on the replica, which allows them to be asynchronous.
> the I/O thread can work independently of the SQL thread.

replica 获取 log 和执行操作，是两个步骤。

> replication is serialized on the replica.
> this is a performance bottleneck for many workloads.

log 是有序的，所以执行也是有序的，不存在并发。
（这样单现场执行操作，可能出现性能问题

---

> statement-based replication or logical replication, is simple to implement.
> the binary log events tend to be reasonably compact.

logical replication 的好处是实现简单，且需要传输的数据量少。

> statement-based replication can be made to work in more cases where the tables
> have different but compatible data types, different column orders, and so on.

因为是以 SQL 为基础，所以对存储结构没有要求。
甚至允许 master 和 replica 的表结构不同（比如更新数据，之后替换主库之类的场景

> if you’re using triggers or stored procedures, don’t use statement-based replication

不支持某些操作。（不过这些本来就很少用吧

---

> The biggest advantages of row-based replication are that MySQL can replicate
> every statement correctly, and some statements can be replicated much more
> efficiently.

部分场景更高效是因为不需要再次解析执行 SQL，并且这样更准确。

不过有的时候，简单的 SQL 需要大量操作，就需要传输很多数据了。

---

> MySQL can switch between statement-based and row-based replication dynamically.
> By default, it uses statement-based replication, but when it detects an event
> that cannot be replicated correctly with a statement, it switches to row-based
> replication.

两种方式可以动态切换。

---

replica 从 master 或者其他 replica 复制数据。
都是从远程的 binary log 复制到本地的 relay log，再给 SQL 线程执行。

> When the replication SQL thread reads the relay log, it discards any event
> whose server ID matches its own. This breaks infinite loops in replication.

好像是为了避免 replica 之间出现循环

---

> replication scales reads, but it doesn’t scale writes.
> Partition is the only way you can scale writes.

主从架构，replication 只能提升读的性能。

而且这个提升还不是线性的。
写入增加，意味着 replica 要处理的 relay log 增加，使得单个 replica 处理读取吞吐量降低。
而且 replica 写入通常还比 master 要慢（单线程写入

---

> A common question about replication is “How fast is it?”
> The short answer is that it runs as quickly as MySQL can copy the events from
> the master and replay them, with very little overhead.

主要耗时就两个地方，网络传输和执行写入。

---

> add multithreaded (parallel) replication apply to alleviate the current
> single-threaded bottleneck

不再是单线程了，书太旧，没细讲

> semisynchronous replication.
> Replica acknowledge after receiving the transaction, not after applying it.

书太旧，没细讲

---

## 11. Scaling MySQL

---

> Most people will never maintain systems at an extremely large scale.
> What is your expected peak load?

扎心 x2

---

> performance: the response time
> capacity: the throughput it can achieve while still delivering acceptable performance
> scalability: the ability to add capacity by adding resources

性能，现在都是看 p95 p99 这种百分位数吧

---

单机的 MySQL 利用不好 24-32 CPU / 128-256GB memory / PCIe flash drive
书里一处 24C-128G 一处 32C-256G，不过大概就在这个范围，新版应该还提升。

---

> archive and purge unneeded data
> remove them in small chunks (find a good compromise between lock contention and transactional overhead

就是分离冷热数据

---

> The primary difficulty is how to handle stale data on the replica, because
> replication is asynchronous.

读到过期数据，确实是个很大的问题。
我怀疑，大部分都是直接根据 query 类型分发请求到 master/replica

> The user doesn’t have to see the most up-to-date data from other users but
> should see her own changes.
> You can implement this at the session level by flagging the session as having
> made a change and directing the user’s read queries to the master for a
> certain period of time after that.

前后两个 HTTP 请求的话，感觉尤其难以处理，毕竟请求可能是不同节点处理的。
所以 session 这个方案感觉不太实用。

> you can track version numbers and/or timestamps for objects, and read the
> object’s version or timestamp from the replica to determine whether its data
> is fresh enough to use.

version 这个方案也没太明白。需要结合业务画个时序图看看…

---

> The load balancer then routes incoming connections to the least busy available server.

random / round-robin / fewest connections / fastest response / hashed / weighted

感觉大部分都是 round-robin 或者 weighted 对付了

---

## 12. High Availability

---

> availability is best understood by studying its opposite: downtime

> These two dimensions of high availability can be measured by two corresponding
> metrics:
> mean time between failures (MTBF) and mean time to recovery (MTTR)

最重要的就是如何衡量，MTBF 和 MTTR

---

> One way to increase availability is to create a cluster or pool of servers and
> add a load-balancing solution.

感觉最常用的还是 replica 吧，上副本。

> Shared or replicated storage is one popular way to accomplish this.
> Shared storage is a way to decouple your database server and its storage.

数据库有状态，可以分离计算和存储。计算单元挂了直接切备用。
