# make sense of stream processing

https://www.oreilly.com/library/view/making-sense-of/9781492042563/

---

- write-optimized event vs read-optimized aggregate
    - event log vs materialized view

> the decades-old debate over normalization (faster writes) versus
> denormalization (faster reads) exists only because of the assumption that
> writes and reads use the same schema.
> If you separate the two, you can have fast writes and fast reads.

> rather than performing destructive state mutaion on a database when writing to
> it, we should record every write as an immutable event.

- low-level matters
    - how to scale processing across multiple machines
    - how to deploy a job to a cluster
    - how to handle faults (crashes, machine failures, network outages)
    - how to achieve reliable performance in a multitenant environment

---

> a stream should be implemented as a log
> an append-only sequence of events in a fixed order

> different storage systems end up containing the same data but in different form.
> but keeping the data synchronized between all these various different
> representations becomes a real challenge.
> solutuon: store all writes in a fixed order, and apply them in that fixed
> order to the various places they need to go.
不管缓存还是索引，都是数据的一个切面。

> problem: the consumers of the log all update their datastores asynchronously,
> so they are eventually consistent.

---

> we are taking the database architecture we know and turning it inside out.

event 和 view 确实可以说是一体两面。
不过有个疑问，作者没有回答，transaction 怎么办？

---

（不管是 DDD 还是本文的 log，核心都是围绕 event stream 做数据处理
