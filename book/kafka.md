# Kafka The Definitive Guide

---

## Kafka Internals

- how Kafka replication works
    - membership (broker list)
        - ZK `/brokers/ids`
        - broker 启动的时候到 ZK 注册，失联的时候被 ZK 剔除
        - broker 通过 ZK watch 即可知道其他节点的情况
    - controller
        - ZK `/controller`
        - broker 启动的时候尝试成为 controller，失败了就 watch 其状态，等当前 controller 失联的时候再次尝试
        - controller 的职责是在 partition leader 失联的时候，选出新的 partition leader 并 broadcast 给 followers
        - controller 有个 epoch，避免出现 network partition 恢复后有多个 controller 的情况。谁 epoch 大谁说了算
    - replication
        - 用户只需要关心 topic
        - topic 会被分成多个 partition，每个 partition 都有自己的 replica
        - replica 被分散在不同的 broker
        - follower 使用 Fetch 来和 leader 保持同步（和普通的 consumer 一样
        - 维护一个 stay in sync 的 follower 列表，当 leader 失联，从中选取新 leader
        - preferred leader （创建 topic 时的 leader
            - 最初创建的时候，leader 在 broker 的分布比较均衡，不会出现单个 broker 负载过高
            - 多次选主后，可能出现大量 leader 集中在某个 broker，导致负载增长
            - 假如 preferred leader 是 stay in sync 的，会切换 leader
    - 小结一下就是强依赖 ZooKeeper，利用 ZK 实现选主、维护成员列表

- how Kafka handles requests from producers and consumers
    - Kafka 按照接收的顺序处理 request
        - client_X -> network threads -> request queue
        - request queue -> IO threads -> response queue
        - response queue -> network threads -> client_X
    - requests: produce / fetch / metadata / ...
    - all produce/fetch requests need to be sent to leader replica
        - Kafka client 通过 metadata request 判断 leader 在哪个 broker
        - 发送到错误的 broker，请求会直接被拒绝
    - trade-off
        - acks=0/acks=1/acks=all, produce request 写入多少 replica 才被写入成功
        - 居然不能选择其他 ack 数量
        - 写入是指写入 filesystem cache，kafka 不关心写没写入 disk（反正有 replica，丢就丢吧
        - 读取数据的时候也是直接从 filesystem cache 到 network，都在内核里
        - 读取数据时可以选择让 broker 去 buffer 一会儿，合并小数据直到某个阈值后一起发送
        - 写入之后不是马上就能读取，要等 replica 同步成功。避免从异常中恢复后状态不一致
    - （截止到写书的时候，创建 topic 要去操作 ZooKeeper，不能直接在 Kafka 上完成

- how Kafka handles storage (file format, indexes, ...
    - allocate partition
        - 创建 topic 的时候
            - 先决定分几个 partition，每个 partition 几个 replica
            - 然后把这些 replica 分散到 broker 上
        - replica 就是最小单元了，甚至不支持写到多磁盘（空间不够就组 RAID 吧
    - file
        - split replica to segments
            - 1GB of data or a week of data (which is smaller
        - active segment is never deleted （正在写入的不会删除
        - 一个 segment 就是一个文件，写满了就打开新文件
        - 数据不是永久保存的，根据规则，旧的 segment 会被删除
    - format
    - index
        - map offsets to segment and position
        - indexes are broken into segment （删除 segment 连着 index 一起没了
        - no checksum （损坏或者被删除，直接重新生成
    - compaction
        - active segment is never compacted
        - start compacting when 50% of the topic contains dirty records

