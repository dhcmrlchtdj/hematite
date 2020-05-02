# sqlite4

---

## [LSM Design Overview](https://www.sqlite.org/src4/doc/trunk/www/lsm.wiki)

---

> To query a database, the contents of the in-memory tree must be merged with
> the contents of each sorted run in the database file. Entries from newer
> sorted runs are favoured over old (for the purposes of merging, the in-memory
> tree contains the newest data).

> When an application writes to the database, the new data is written to the
> in-memory tree. Once the in-memory tree has grown large enough, its contents
> are written into the database file as a new sorted run. To reduce the number
> of sorted runs in the database file, chronologically adjacent sorted runs may
> be merged together into a single run, either automatically or on demand.

这段关于 LSM 的描述，我感觉有点复杂了……
如果理解了大致结构，其实是很简单的东西。
memory 里维护一个 table，体积达到阈值就写入 disk。
查找的时候，先查找 memory，再查找 disk。
写入是 append only 的，所以 disk 上的多个 table 可以在其他线程合并，然后替换原有的 table。

---

> The in-memory tree is an append-only b-tree of order 4 (each node may have up
> to 4 children), which is more or less equivalent to a red-black tree.

> An append-only tree is convenient, as it naturally supports the
> single-writer/many-readers MVCC concurrency model.

sqlite4 的做法，是 memory 维护一个 tree。

---

## [LSM Users Guide](https://www.sqlite.org/src4/doc/trunk/www/lsmusr.wiki)

---

> LSM is an embedded database library for key-value data.
> Both keys and values are specified and stored as byte arrays.
> Duplicate keys are not supported.
> Keys are always sorted in memcmp() order.

从用户角度看 LSM

> A single-writer/multiple-reader MVCC based transactional concurrency model.

这个 MVCC 是我最疑惑的地方。到底在表达什么……

---

> B-trees are attractive because a b-tree structure minimizes the number of disk
> sectors that must be read from disk when searching the database for a specific
> key.
> However, b-tree implementations usually suffer from poor write localization -
> updating the contents of a b-tree often involves modifying the contents of
> nodes scattered throughout the database file.
> Additionally, b-tree structures are prone to fragmentation, reducing the
> speed of range queries.

Btree 的优缺点，查找快，写入随机，碎片化。

HDD 写入需要移动磁头，SSD 写入需要擦除（？不太懂这个 the large erase-block sizes

> writing to an LSM database should be very fast and scanning through large
> ranges of keys should also perform well, but searching the database for
> specific keys may be slightly slower than when using a b-tree based system.

LSM 适合写入和范围查询，查找则可能比较慢。

---

> LSM supports a single-writer/multiple-reader MVCC based transactional concurrency model


> at most one database client may hold an open write transaction

一次最多一个 write client，先到先得，慢的 client 失败

> If a read-transaction is already open when the write-transaction is opened,
> then the snapshot read by the read-transaction must correspond to the most
> recent version of the database.
> if any other client has written to the database since the current clients
> read-transaction was opened, it will not be possible to upgrade to a
> write-transaction.

这个有点没读懂。
应该不是读写锁那样不允许写，但 the snapshot read by the read-transaction 指的是什么…

---

Overview of LSM Architecture 这段是不错的 LSM 介绍

> When an application writes to an LSM database, the new data is first written
> to a log file and stored in an in-memory tree structure.

> Flushing an in-memory tree to the database file creates a new database "segment".
> A database segment is an immutable b-tree structure stored within the database file.
> A single database file may contain up to 64 segments.

memory 和 disk 都是 tree

---

## [The Design Of SQLite4](https://www.sqlite.org/src4/doc/trunk/www/design.wiki)

---

> SQLite4 does all numeric computations using decimal arithmetic
> all numeric values are represented internally as an 18-digit decimal number with a 3-digit base-10 exponent.

定点数

---

> SQLite3 simply treats that PRIMARY KEY as a UNIQUE constraint.
> The actual key used for storage in SQLite is the rowid associated with each row.

其实我觉得这个可以接受呀

> In SQLite3, a search on the primary key means doing a search on an automatic
> index created for that primary key to find the rowid, then doing a second
> search on the main table using the rowid.

听起来是 clustered index 的表结构呀

---

## [BT Design Overview](https://www.sqlite.org/src4/doc/trunk/www/bt.wiki)

---

> All data is stored in a b-tree structure with fixed size pages.
> Large records are stored using overflow pages.

大数据使用 overflow page 的方式存储
