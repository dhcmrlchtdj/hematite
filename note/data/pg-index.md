# pg index

https://postgrespro.com/blog/pgsql/3994098
https://postgrespro.com/blog/pgsql/4161264
https://postgrespro.com/blog/pgsql/4161321
https://postgrespro.com/blog/pgsql/4161516
https://postgrespro.com/blog/pgsql/4175817
https://postgrespro.com/blog/pgsql/4220639
https://postgrespro.com/blog/pgsql/4261647
https://postgrespro.com/blog/pgsql/4262305

一个系列文章，讲 PG 的索引。

> Hash, B-tree, GiST, SP-GiST, GIN and RUM, BRIN, and Bloom.

`select amname from pg_am; -- access method` 可以查询支持哪些索引方式

---

> Each row is identified by TID (tuple id), which consists of the number of block in the file and the position of the row inside the block.

TID 的组成。

---

> Note that update of table fields for which indexes haven't been built does not result in index update;
> this technique is called HOT (Heap-Only Tuples).

HOT 这个，至少开始看相关文章之前，我是不知道 PG 还有这种构造的。

---

> The indexing engine accesses the table rows indicated by TIDs in turn,
> gets the row version,
> checks its visibility against multiversion concurrency rules,
> and returns the data obtained.

第一篇讲解了 explain 里 index 相关的输出，值得一看。

---

不同的索引方式

- `create index on t(a,b)`
- `create index on t(lower(b))`
- `create index on t(c) where c`

---

btree 还可以用于 order by，这是其他类型的索引做不到的。

---

## Hash
