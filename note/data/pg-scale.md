# pg scale

https://blog.timescale.com/blog/scalable-postgresql-high-availability-read-scalability-streaming-replication-fb95023e2af/

---

> So if your workload peaks below 50,000 inserts a second (e.g., on a setup with 8 cores and 32GB memory),
> then you should have no problems scaling with PostgreSQL using streaming replication.
> scale read throughput and provide high availability in PostgreSQL using streaming replication

18 年的文章，8C32G 可以扛住 50000 的插入。

streaming replication

---

> PostgreSQL streaming replication leverages the Write Ahead Log (WAL).
> The replication works by continuously shipping segments of the WAL from the primary to any connected replicas.

> It ships the WAL to other servers;
> the other servers replay the WAL as if they were recovering at a server restart.

就是主从模式啦。

> one can set the replication mode on a per transaction basis.

这个比较强，主从同步的时候，异步还是同步，可以在事务级别控制。

> (Asynchronous Replication) the primary does not wait for the logs to be
> persisted to disk, nor do the replicas wait for the data to be applied on the primary.

> (Synchronous Apply) the primary now has to wait for the transaction to be
> applied twice (once on the primary, and once again in parallel on all replicas).

根据文章给出的数据，asynchronous replication 几乎不影响性能，而最严格的 synchronous apply 会导致性能下降一半。
synchronous write 就中庸一些。

---

https://www.postgresql.org/docs/13/warm-standby.html#STREAMING-REPLICATION

> Streaming replication is asynchronous by default
> This delay is typically under one second assuming the standby is powerful enough to keep up with the load.

按文档的说法，异步复制的延迟，可能要按秒计。
