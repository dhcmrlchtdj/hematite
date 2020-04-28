# clustered index

https://use-the-index-luke.com/blog/2014-01/unreasonable-defaults-primary-key-clustering-key

---

> choosing a good clustering key is almost impossible if there are more than one
> or two indexes on the table

本文的作者对 clustered index 持否定态度。
这里的 impossible，即后文指出的 secondary index 开销。

---

> If a table has a clustered index, it basically means the index is the table.
> Clustered indexes have the advantage that they support very fast range scans.

使用 clustered index 的方式存储数据，最大的好处是 range scan 很方便，因为数据有序。
mysql 使用了这种方式。

PG 存储 tuple 用的是 HEAP，heap 里面是 slotted page。
tuple 之间是无序的，所以 range scan 只能遍历 btree 叶子节点，跟着指针去找 tuple。

（有个疑问，如果要插入数据，要移动前后的数据？开销会不会很大？

---

> A non-clustered index has just a sub-set of the table columns
> so it causes extra IOs for getting the missing columns from the primary table store if needed.
> using a non-clustered index generally involves resolving an extra level of indirection.

table 用 clustered index 的方式存储
那么 secondary index 就和 heap 方式一样，需要一个指针指向 table

但是 heap 方式存储数据，指针直接指向 tuple 的位置，属于 physical index。
而 non-clustered index 的指针，指向 primary key，需要在 table 里再查找一个 btree，属于 logical index。

> the pure presence of the clustered index affects they way
> the non-clustered index refers to the primary table storage

作者把这个开销称为 clustered index penalty

---

table 还是用 clustered index，然后 secondary index 存储 tuple 地址，可行吗？
