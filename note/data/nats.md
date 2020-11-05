# nats streaming

---

- streaming server 和 streaming client 都是 nats client，通过 heartbeat 检测存活状态
    - the Streaming server is a client to a NATS Server
    - Streaming clients are communicate with the Streaming server through NATS Server
    - the server knows if a client is connected based on heartbeats
    - streaming server creates internal subscriptions on specific subjects to communicate with its clients and/or other servers

- streaming client 和 nats client 不能交换数据（一个是 protobuf 一个是 plaintext
    - Streaming messages are NATS messages made of a protobuf

- nats server 可能是 cluster
    - streaming client 和 streaming server 可能在和完全不同的 nats server 通信

---

- every streaming client has a unique client ID
    - 如果 client 奔溃，然后用同一个 ID 连接 server
        - server 会请求原 client，能连通就拒绝新 client，不能连通就替换到新 client

- streaming client 断开（没有回复 ACK），streaming server 会在 AckWait 的间隔后 redeliver
    - at-least-once delivery

---

- 通过 channel 通信
    - channel 里面是 message
    - client 会订阅 channel

- channels are subjects clients send data to and consume from
    - channel doesn't support wildcards
    - channel / message log is a First In First Out (FIFO) queue
        - when the limit is reached, older messages are removed to make room for the new ones
    - messages are not removed due to consumers consuming them
    - messages are stored regardless of the presence of subscriptions on that channel
    - message 和 client 无关，完全由 server 自己处理

- a client creates a subscription on a given channel
    - a subscription is tied to one and only one channel

---

- Channels Partitioning and Clustering are mutually exclusive
    - cluster 是 nats streaming server 靠 raft 实现的，server 间状态一致
    - channel partition 是不同 server 只处理各自的 channel，不同 server 状态不一致

- clustering mode 和 fault tolerance mode 也冲突
    - fault tolerance mode 就是主从模式，一个 active server 和一堆 standby server
        - client 只和 active server 通信
    - When the active server fails, all standby servers will try to activate.
        - The process consists of trying to get an exclusive lock on the storage.
        - standby server 竞争上岗，看谁拿到 storage 的锁

---

- 一些基本事实
    - Streaming is implemented as a request-reply service on top of NATS
    - Streaming messages are encoded as protocol buffers
    - the streaming clients use NATS to talk to the streaming server
    - The streaming server organizes messages in channels and stores them in files and databases
    - ACKs are used to ensure delivery in both directions
    - Clients send to and receive from channels instead of subjects
        - The streaming libraries hide some of the differences between channel and subject

- 选择 nats 还是 nats streaming
    - nats / at-most-once semantics
        - observation needs to be realtime
        - the most recent message is the most important
    - nats streaming / at-least-once semantics
        - observability is required
        - need to consume messages in the future
        - need to come consume at application's own pace
        - need all messages
    - at least once 需要更多的 compute 和 storage
