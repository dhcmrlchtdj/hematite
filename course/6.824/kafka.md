# kafka

https://kafka.apache.org/documentation/

- motivation
    - use case
        - real-time log aggregation (high-throughput
        - traditional messaging (low-lantency
    - partitioned, distributed, real-time processing
    - guarantee fault-tolerance in the presence of machine failures
    - more akin to a database log than a traditional messaging system

- persistence
    - all data is immediately written to a persistent log on the filesystem without necessarily flushing to disk
        - 之前看的数据库课程一直讲，DB 比 OS 更清楚如何处理资源。但 kafka 选择了相信 OS 😂
        - 一个原因是 Kafka 使用了 JVM，而 Kafka 开发者觉得 JVM 对内存控制能力不强，不如直接上 OS pagecache
    - a properly designed disk structure can often be as fast as the network
        - persistent queue, built on simple reads and appends to files
        - all operations are O(1) and reads do not block writes or each other

- efficiency
    - poor disk access patterns
        - 上一章的 persistent queue 解决了这个问题
    - too many small I/O operations
        - batch
        - group messages together and amortize the overhead of the network roundtrip
    - excessive byte copying
        - binary message format (shared by the producer, the broker, the consumer)
        - sendfile system call (send data from pagecache to network directly)
    - network bandwidth
        - batch compression
        - compressing multiple messages together rather than compressing each message individually
        - producer 压缩数据，consumer 解压数据，中间的 broker 不处理

- data is pushed to the broker from the producer
    - the client controls which partition it publishes messages to
    - the broker is the leader for the partition
- data is pulled from the broker by the consumer
    - the consumer specifies its offset in the log

- message delivery semantics
    - guarantee （这和 RPC 是一样的
        - at most once （可能丢消息
        - at least once （可能重复
        - exactly once
    - committed log will not be lost as long as one broker remains alive
    - the producer
        - 场景：producer 发送请求后，发现网络异常，不知道 broker 收没收到，重新发送
        - at-least-once
            - broker 不校验，可能有重复的消息
        - exactly-once
            - 每个 producer 都有 producer_ID
            - 每条消息都带上 message_ID
            - broker 根据 ID 去重，实现 exactly once
        - transaction （producer 向多个 topic 发消息
    - the consumer
        - 场景：consumer 宕机，恢复后不知道处理到哪个 offset
        - at-most-once
            - 记录 position 后开始处理消息
            - 可能消息还没处理好就宕机了
        - at-least-once
            - 处理完消息后记录 position
            - 可能处理完还没记录就宕机了
        - exactly-once
            - 处理结果和 position 记录到一起。都存在或者都丢失
            - （不同系统间，也可以靠 2PC 实现
            - （两个 kafka 之间传递消息，也可以靠 transaction 实现

- replication
    - 一个 Kafka broker 集群有多个 topic，一个 topic 有多个 partition
    - a Kafka partition is a replicated log
    - each partition in Kafka has a single leader and zero or more followers
        - followers consume messages from the leader just as a Kafka consumer
        - all reads and writes go to the leader of the partition
        - member alive: ZooKeeper's heartbeat mechanism
    - a committed message will not be lost
        - as long as there is at least one in sync replica alive
        - a message is committed when all in sync replicas for that partition have applied it to their log
        - producer 可配置，是否等待 commit (latency vs durability
    - use a majority vote for both the commit decision and the leader election
        - a very nice property, the latency is dependent on only the fastest servers
        - downside, 实践中 2f+1 并不够，资源利用率太低了
            - F1 也说 3 个数据中心不够，部署了 5 个
    - Kafka dynamically maintains a set of in-sync replicas (ISR) that are caught-up to the leader
        - only members of this set are eligible for election as leader
        - the ISR set is persisted to ZooKeeper
        - ISR model and f+1 replicas, tolerate f failures without losing committed messages

- log compaction
    - retain at least the last known value for each message key within the log of data for a single topic partition
