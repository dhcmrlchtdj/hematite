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

---

PG 里 hash 后是个 uint32（翻了下代码，PG 给每种数据都定义了 hash function (https://github.com/postgres/postgres/blob/REL_12_2/src/backend/access/hash/hashfunc.c

> The number of buckets initially equals two and dynamically increases to adjust to the data size.

> the access method asks the general indexing engine to verify each TID by rechecking the condition in the table row
> (the engine can do this along with the visibility check).

PG 里使用了 overflow page

---

> Note that hash index cannot decrease in size.
> The only option to decrease the index size is to rebuild it from scratch using REINDEX or VACUUM FULL command.

需要注意 hash index 的空间使用

---

## btree

> the most traditional and widely used index
> suitable for data that can be sorted

---

> index rows of the B-tree are packed into pages
> In leaf pages, these rows contain data to be indexed (keys) and references to table rows (TIDs)

存储的是 key 和 TID，放进 page 里（PG 的 page 默认是 8K

---

操作时需要注意的点

- 数据排列是单调递增的，查找到最后，可能需要查看左右节点是否相等。
- 并发操作要加锁

---

btree 的结果是有序的，但是要注意多个 field 的索引，写错顺序会导致索引失效。

---

> "btree" access method indexes NULLs and supports search by conditions IS NULL and IS NOT NULL.

---

> It is well-known, yet no less important, that for a large-size table, it is better to load data there without indexes and create needed indexes later. This is not only faster, but most likely the index will have smaller size.

数据排序再构造树，比慢慢插入比较要快吧。

---

`create type complex as (re float, im float)` 之后，还可以自己定义排序函数

---

## GiST

GiST means "generalized search tree", a balanced search tree, for geodata, text documents, images, ...

这些数据类型，并没有 greater/less 的概念

> GiST index permits defining a rule to distribute data of an arbitrary type across a balanced tree and a method to use this representation for access by some operator.

---

## SP-GiST

> "SP" stands for space partitioning.

> SP-GiST is suitable for structures where the space can be recursively split into non-intersecting areas. This class comprises quadtrees, k-dimensional trees (k-D trees), and radix trees.

---

## GIN

> GIN is the abbreviated Generalized Inverted Index
> The main application area for GIN method is speeding up full-text search

> Elements are never deleted from GIN index.

怎么感觉 btree 之外的索引都不怎么喜欢删除操作

> The thing is that data insertion or update in GIN index is pretty slow

维护起来很慢，需要考虑这点

> For many data types, operator classes are available for both GiST and GIN
> GIN beats GiST in accuracy and search speed.
> If the data is updated not frequently and fast search is needed, most likely GIN will be an option.
> if the data is intensively updated, overhead costs of updating GIN may appear to be too large.

选择 GIN 和 GiST 的依据之一，也是维护索引的速度

值得一提，GIN 还支持 ARRAY 和 JSONB，判断 array element 或者 json key 是否存在。

---

## RUM

> next-generation GIN

写这系列文章的 postgrespro 提供的插件。
