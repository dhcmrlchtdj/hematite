# isolation

https://begriffs.com/posts/2017-08-01-practical-guide-sql-isolation.html

---

首先，先有了并发读写，才有了隔离的需求。
所以，应该先分析清楚并发读写可能出现哪些问题，然后分别可以用什么方式解决。

---

## dirty writes

- pattern
    - `A_write(x1) - B_write(x2) - A_commit/rollback`
    - B 覆盖了 A 写入的值
    - 两个事务共享一个变量

---

## dirty reads

- pattern
    - `A_write(x1) - B_read(x1) - A_abort`
    - B 读到未 commit 的数据

---

## non-repeatable reads, read skew

- non-repeatable read pattern
    - `A_read(x1) - B_write(x2) - B_commit - A_read(x2)`
    - A 两次读取 x，返回的结果不同
    - 和 dirty read 的区别在于，这里读到的都是已经 commit 的数据

- read skew pattern
    - `A_read(x1) - B_write(x2) - B_write(y1) - B_commit - A_read(y1)`
    - non-repeatable read 是 read skew 的特例 (x=y)

---

## phantom reads

- pattern
    - `A_read(xs1) - B_write(xs2) - B_commit - A_read(xs1)`
    - A 两次读取 xs，返回的结果不同
    - non-repeatable reads 读取单个值，phantom reads 读取多个值

---

## lost update, write skew

- lost update pattern
    - `A_read(x1) - B_write(x2) - A_write(x3) - A_commit`
    - B 写入的值被 A 覆盖了
    - B 的对 x 的修改，从数据库角度，和没有执行差不多。数据库之外的行为可能出现问题，比如发送了通知邮件。

- write skew pattern
    - `A_read(x1) - B_read(y1) - A_write(y2) - B_write(x1) - A_commit - B_commit`
    - lost update 是 write skew 的特例 (x=y)

---

## serialization anomaly

- pattern
    - ???

---

实现 row-level lock，就可以避免 dirty writes / dirty reads

实现 snapshot isolation 比如 MVCC，可以解决 non-repeatable reads / read skew / phantom reads

实现 serializable snapshot isolation 或者 2PL，可以解决 write skew
