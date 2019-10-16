# redis cluster

---

https://redis.io/topics/cluster-tutorial

- data sharding
    - no consistent hashing
    - 16384 hash slots
        - the CRC16 of the key modulo 16384
        - 16384 个 slot 被分配到各个 node
- master-slave
    - 对 hash slot 进行 replicate
    - 多 master
    - failover
        - one of the salves will be promoted to master
- consistency guarantee
    - no strong consistency
    - asynchronous replication
        - 写入 master 后直接返回成功，不管 slave 同步情况
    - 可选的 synchronous write
        - 仍不保证 strong consistency

---

https://redis.io/topics/cluster-spec

- goals
    - linear scalability up to 1000 nodes, with asynchronous replication
- HASH_SLOT = CRC16(key) mod 16384
    - multi-key operations are implemented as well as long as the keys all hash to the same slot
    - hash tags, force certain keys to be stored in the same hash slot
- Redis Cluster Bus
    - every node is connected to every other node in the cluster using the cluster bus
    - gossip
- node will not proxy requests, clients may be redirected to other nodes
- availability
    - not available in the minority side of the partition
    - not a suitable solution for applications that require availability in the event of large net splits
