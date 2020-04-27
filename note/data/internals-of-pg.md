# The Internals of PostgreSQL

http://www.interdb.jp/pg/index.html

---

## MVCC

> PostgreSQL and some RDBMSs use a variation of MVCC called Snapshot Isolation (SI).

MVCC 实现了数据的 snapshot

---

> To implement SI, some RDBMSs, e.g., Oracle, use rollback segments.
> When writing a new data item, the old version of the item is written to the
> rollback segment, and subsequently the new item is overwritten to the data area.
> PostgreSQL uses a simpler method.
> A new data item is inserted directly into the relevant table page. When reading
> items, PostgreSQL selects the appropriate version of an item in response to an
> individual transaction by applying visibility check rules.

MVCC 比不上 mysql，大概是 PG 最大的黑点？
比不上的原因就在这个地方了，用了 a simpler method

---

> SI does not allow the three anomalies defined in the ANSI SQL-92 standard,
> i.e. Dirty Reads, Non-Repeatable Reads, and Phantom Reads.
> However, SI cannot achieve true serializability because it allows
> serialization anomalies, such as Write Skew and Read-only Transaction Skew.

还是前面说的，MVCC 实现的是 snapshot，并没有达成 serializable

在 PG 里开启 SERIALIZABLE isolation level，会使用 Serializable Snapshot Isolation (SSI)

---

PG 里每个事务都有个 txid，是个 32bit unsigned integer，可以视为 logical clock。
32bit 不够用怎么办？
把 32bit 整个空间视为环，将 2^32 个数字对半开
对于 txid=100 的事务来说，[101,2^31+100] 是未来，[0,99] 及 [2^31+101, 2^32-1] 是过去

---

PG 因为 MVCC 的缘故，每次 update 一个字段，就会在 page 里面插入一个新的 tuple。（旧的字段被标记为 delete
插入的开销，加上遍历的开销，导致整体开销大？好像也不太对啊，只是空间占用问题？

---

## Heap Only Tuple (HOT)

在 heap 上更新 tuple，会插入一个新的 tuple。
PG 的 index 是指向 physical 地址的，所以需要同步更新 index 的指向。
为了减少 index 的修改，在更新的使用会使用 HOT 的方式。
还是会插入一个新的 tuple，但不修改 index，而是在 tuple header 里加个指针，指向最新的 tuple。
但如果 page 的空间不够了，新 tuple 只能插入到其他 page 去，index 的指针就必须修改，HOT 这个优化也就无效了。

---

## VACUUM

> Concurrent VACUUM, often simply called VACUUM, removes dead tuples for each
> page of the table file, and other transactions can read the table while this
> process is running.
> Full VACUUM removes dead tuples and defragments live tuples the whole file,
> and other transactions cannot access tables while Full VACUUM is running.
