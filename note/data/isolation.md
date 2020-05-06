# isolation

---

首先，先有了并发读写，才有了隔离的需求。
所以，应该先分析清楚并发读写可能出现哪些问题，然后分别可以用什么方式解决。

---

- dirty read
    - `A_write(x1) - B_read(x1) - A_abort`
    - B 读到脏数据

写入时，加锁不让读取即可

---

- dirty write
    - `A_write(x1) - B_write(x2) - B_write(y1) - B_commit - A_write(y2) - A_commit`
    - 部分是 A 写入的结果，部分是 B 写入的结果

- 写入时，加锁即可

---

- read skew / non-repeatable read
    - `A_read(x1) - B_write(x2) - B_commit - A_read(x2)`
    - A 两次读取 x，结果不同
    - 其他事务 update 字段导致的

需要 snapshot isolation，保证 A 每次都读到相同内容
可以靠 MVCC 实现

---

- lost update
    - `A_write(x1) - B_write(x2) - A_commit - B_commit`
    - A 写入的 x 被 B 覆盖了

需要 serializable isolation
可以靠 2PL/SSI 实现

---

- write skew
    - `A_read(x1) - B_read(y1) - A_write(y2) - B_write(z1) - A_commit - B_commit`
    - B 成立的前提，是 B_read 的结果符合预期
    - A commit 之后，破坏了 B 的前提

需要 serializable isolation
可以靠 2PL/SSI 实现

---

- phantom read
    - `A_read(x1) - B_write(x2) - B_commit - A_write(y1) - A_commit`
    - B_commit 前后，A_read 的结果不同，导致后续操作的前提不成立
    - 其他事务 insert/delete 字段导致的

需要 serializable isolation
可以靠 2PL/SSI 实现
