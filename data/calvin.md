# calvin

---

---

http://dbmsmusings.blogspot.com/2017/04/distributed-consistency-at-scale.html

- Spanner uses TrueTime for transaction ordering
- Calvin uses sequencing for transaction ordering
    - All transactions are inserted into a distributed, replicated log before being processed

http://dbmsmusings.blogspot.com/2018/09/newsql-database-systems-are-failing-to.html

- database systems use consensus protocols to enforce consistency (how they use these protocols?
    - calvin: uses a single, global consensus protocol per database
        - 有中心，性能怎么解决？（batch
    - spanner: partitions the data into shards, and applies a separate consensus protocol per shard
        - the system cannot guarantee CAP consistency without TrueTime

http://www.zenlife.tk/cockroach-parallel-commits.md

- calvin 模式无法支持交互式事务
