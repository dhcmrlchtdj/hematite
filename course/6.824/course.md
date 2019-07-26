# Distributed Systems

https://pdos.csail.mit.edu/6.824/schedule.html

---

## Introduction

- why distributed
    - to achieve security via isolation
    - to tolerate faults via replication
    - to scale up throughput via parallel CPUs/mem/disk/net
- topic
    - implementation
    - performance
    - fault tolerance
    - consistency

- MapReduce
    - overview
        - 基本思路、适用场景
        - 解决什么问题，如何解决
    - advantage
        - hide painful details, scale well
        - 比其他方案优势在哪
    - limitations
        - 哪些场景不适用，为什么不适用
        - 性能、效率的瓶颈在哪
    - implementation details
        - 如何应对 limitation
    - fault tolerance, crash recovery
        - 发现、处理、恢复

---

## Infrastructure: RPC and threads

- threading challenages
    - sharing data
        - synchronization
    - coordination
    - granularity
        - coarse-grained
        - fine-grained
- sharing+locks vs channels
    - state vs communication
- RPC
    - client/server communication
- RPC failure
    - failure-handling scheme
        - best effort (retry)
        - at most once (unique ID for each request)
            - how to create unique ID
            - when to discard old RPC response (heartbeat, received next UID)
        - exactly once

---

## GFS

- system design
    - trading consistency for simplicity and performance
    - performance, fault-tolerance, consistency
- consistency
    - replicate
        - multiply machines, reads and writes go across
    - strong consistency
        - bad for performance, easy for application writers
    - weak consistency
        - good for performance, easy for scale, bad for reason about
- consistency model
    - a replicated FS behaved like a non-replicated FS
        - what happens on a single machine?
    - challenges
        - concurrency
        - machine failures
        - network partitions

- GFS
    - TODO
    - read
        - 64MB chunk
        - 3x replication
        - master server
        - worker server
    - write

---

## Primary/Backup Replication

- ideal properties
    available: still useable despite  some class of failures
    strongly consistent: looks just like a single server to clients
    transparent to clients
    transparent to server software
    efficient
- fault tolerance, replication
    - two or more servers, if one replica fails, others can continue
- question
    - what state to replicate
    - when to cut over to backup
    - does primary have to wait for backup
- approaches
    - state transfer
        - primary executes the operations, sends new state to backups
        - more simpler
    - replicated state machine
        - all replicas execute all operations
        - more efficient
            - operations are small compared to data
            - complex to get right (same start state, same operations, same order, deterministic)

- Fault-Tolerant Virtual Machines
    - two machines, primary and backup
    - primary sends all inputs to backup over logging channel
    - the backup must lag by one event (one log entry)

---

## Raft

- fault-tolerant services using replicated state machines
    - same client-visible behavior as single non-replicated server
    - available despite some number of failed servers
    - each replica server executes same commands in same order
- how to avoid split brain
    - 节点故障了，应该忽略故障节点；网络故障了，应该等待网络恢复
    - 没有等待网络恢复，结果就是 split brain
    - computers cannot distinguish crashed machines vs a partitioned network
- majority vote
    - 2f+1 servers to tolerate f failures (3 servers can tolerate 1 failure)
    - must get majority (f+1) of servers ti agree to make progress
        - majority is out of all 2f+1 servers, not just out of live ones
    - 少数服从多数，始终保证 f+1 个节点的状态是一致的，也就是正确的状态
    - 存活的节点少于 f+1 个，那么投票始终是失败的
    - （网络真的坏了，那么这就是个牺牲可用性换取一致性的方案

- goal
    - same client-visible behavior as single non-replicated server
    - available despite minority of failed/disconnected servers

- two partition-tolerant replication schemes, Paxos and View-Stamped Replication

- Raft
    - elections, log handling, persistence, client behavior, snapshots
    - overview
        - diagram: clients, k/v layer, Raft layer
            - Raft 选出 leader
            - client 发送操作到 leader 的 kv
            - Raft 将操作发送到 followers，followers 记录到 local log 并返回给 leader
            - leader 等 majority 操作成功，所有 replica 开始操作 kv
            - leader 将 kv 的操作结果返回给 client
        - log
            - log 都是有编号的
            - 可以确定操作的执行顺序
            - 同时保证所有节点状态一致
    - leader election
        - client 只和 leader 交互，借此保证操作的执行顺序
        - terms (number)
            - 每个 term 可以有一个 leader（也可能选主失败没有 leader
                - leader 要有 majority 同意，所以能保证最多只有一个 leader
            - 谁大谁就是 leader，谁大谁就说了算
        - when
            - leader 发送 heartbeat 到 followers
            - 如果 followers 过了一段时间还没收到，就会认为 leader 故障了，开始新的选主程序（term 增大
            - （这种玩法可能导致不必要的选主，但是集群数据的正确性是有保证的
            - 可能由于其他问题选主失败。失败了会再次进入选主流程（term 最大那个尝试发起新的选主流程
                - majority 的节点都不可用，选主会失败（不管是真的不可能，还是网络故障，反正没 majority 同意就无法转变为 leader
                - 多个节点都试图变成 leader，可能由于并发导致投票失败（还是没达到 majority 同意，但节点还能正常通信
            - 得到 majority 支持的节点，发心跳给所有节点，让大家知道选主已经完成了
        - candidate
            - 尝试转换为 leader 的节点，进入 candidate 状态
            - majority 支持，就变成 leader
            - majority 支持了其他 candidate，就变回 followers
            - 选主失败，保持 candidate 状态，等 timeout 后重来
        - timeout
            - random，避免多个 followers 同时尝试转换为 candidate
            - lowest random delay
            - 网络可能各种问题，所以 timeout 至少要够几个 heartbeat 来回
            - 选主也要时间，所以 timeout 至少也要够整个系统完成一次选主
    - Raft log
        - replicated vs. committed entries
            - committed 说明 majority 同意，不会变了
            - replicated 只是完成复制，可能会变
        - servers can temporarily have different log
        - client 只和 leader 交互。那么 leader 发生更换的时候，client 会怎么样
        - 更换 leader 之后，server 的 log 可能处在不同状态
            - force followers adopt new leader's log
            - replicated 可能出现回滚
            - 要保证不能影响 committed 的状态
        - Raft needs to ensure elected leader has all committed log entries
            - at least as up to date
    - persistence
        - repair soon after crash to avoid dipping below a majority
        - strategies
            - 修复问题，重启节点（数据可能过期，但大部分还在
            - 启用新节点（需要复制之前的数据
        - persistent state
            - logList, 如果宕机之前属于 majority 一部分，那么里面包含 committed 的数据，要记下作为证据啊
            - votedFor, 不许给不同的 term 投赞成票，所以要记下
            - currentTerm, term 只许增不许减，所以要记下之前的
        - bottleneck for performance
            - 持久化到硬盘，要时间啊
    - snapshots, log compaction
        - 恢复状态时，如果重放完整日志，太慢
        - log 可能比 state 大得多，所以可以取 state 的快照，减少需要重放的日志数量
        - 做 state 快照的时候，未 committed 的 log 要保留（可能被算在 majority 里了
        - snapshot reflects only committed entries
        - service's on-disk state = service's snapshot + Raft's persistent log
    - configuration change
        - configuration = set of servers
            - 增删节点
        - problem
            - followers will learn new configuration at different times
            - 会给计算 majority 造成问题
            - （也要求 majority 同意即可？那么节点宕机的情况，永远无法达成 majority?
        - joint consensus
            - avoids any time when both old and new can choose leader independently
            - administrator asks the leader to switch to new configuration
            - leader 将新配置下发到 followers，新旧配置都 committed 之后，再切换到新配置
    - performance
        - many situations don't require high performance
        - (Raft) sacrifice performance for simplicity
    - faq
        - sacrifice performance for simplicity
            - 操作要持久化到硬盘
            - 乱序到达的消息，会被丢弃
            - 快照可能很大（创建、传输都慢）
            - 日志要求有序，可能导致无法利用多核
        - While Paxos requires some thought to understand, it is far simpler than Raft
            - But Paxos solves a much smaller problem than Raft
        - real-world systems are derived from Paxos
            - Chubby, Spanner, Megastore, ZooKeeper/ZAB
        - real-world users of Raft
            - docker, etcd, CockroachDB, RethinkDB, TiKV
        - systems can survive and continue to operate when only a minority of the cluster is active
            - do it with different assumptions, or different client-visible semantics
            - human decide，机器不知道宕机还是网络问题，但人能知道
            - allow split-brain operation (eventual consistency), such as Bayou and Dynamo
        - Raft works under all non-Byzantine conditions
            - either follow the Raft protocol correctly, or they halt
        - Raft may not preserve it across a leader change
            - the client will know that its request wasn't served, and will re-send it
            - the system has to be on its guard against duplicate requests
        - always a majority of all servers, dead and alive
        - randomize election timeouts
        - if more than half of the servers die
            - t will keep trying to elect a leader over and over
    - Raft 所有读写都经过 leader。加节点实现容错，并不能增加吞吐量。
    - raft
        - usage
            - fault-tolerant key/value database
            - fault-tolerant master
            - fault-tolerant locking service
        - read request and no-op
            - 为了保证 linearizable，可以先给 follower 发 no-op
            - 也可以使用 lease，在 heartbeat 之后一段时间内，不允许变更
                - lease 内，可以不发 no-op 直接返回
                - the no other leader is allowed to be elected for the next 100 milliseconds
                - the leader can serve read-only requests for the next 100 milliseconds without further communication with the followers
            - 刚成为 leader 的时候，需要发几次 no-op，保证 committed log 一致
        - linearizability
            - the most common and intuitive definition formalizes behavior expected of a single server
            - an execution history is linearizable if one can find a total order of all operations, and in which each read sees the value from the write preceding it in the order.
        - duplicate RPC detection
            - case
                - server deaded, or request dropped (safe)
                - server executed but response dropped (dangerous)
            - detection
                - client picks an ID for each request
                    - same ID in re-sends of same RPC
                - k/v service maintains table indexed by ID
                    - record value after executing
                - when can we delete table entries
                    - one table per client
                    - client numbers RPCs sequentially
                    - client won't re-send older RPCs
                    - so server can forget client's lower entries
                - how does a new leader get the duplicate table
                    - all replicas update their duplicate tables as they execute command
                - if server crash, how does it restore its table
                    - from snapshot or replay the log to build table
        - read-only operations
            - read-only 发送 no-op 是为了保证当前节点仍是 leader，当前的 committed log 是最新的
            - many applications are read-heavy. how to avoid commit for read-only operations?
            - idea: leases
                - a new leader cannot execute Put()s until previous lease period has expired
                - 保证不会有新 leader 修改数据，那么这段时间内即使已经不是 leader，返回的数据仍是正确的
                - 是为了保证 linearizable
        - 🤔️ 疑问 分布式里经常用数字做序号，数字自增，都不考虑溢出吗？

---

## ZooKeeper

- ZooKeeper
    - a generic coordination service
        - widely-used replicated state machine service
        - inspired by Chubby (google's global lock service)
    - many applications in datacenter cluster need to coordinate
        - application that need a fault-tolerant "master" don't need to roll their own
        - GFS, MapReduce, load balancer, crawler, ...
    - high performance
        - asynchronous calls
        - allows pipelining
        - (faster than raft (100x faster
    - alternative
        - vs DNS, too slow, fail-over will take a long time
- API overview
    - operations are performed in global order
    - znode, the replicated object
        - hierarchy, named by pathnames
        - types
            - regular
            - empheral
            - sequential (name + seq_no)
        - metadata of application
            - configuration (server list + which is the primary)
            - timestamps
            - version number
    - sessions
        - client sign into ZooKeeper
        - client must send a heartbeat to the server to refresh session
            - ZooKeeper considers client "dead" if timeout
- operations on znodes
    - all operations (exclude sync) are asynchronous
    - all operations are FIFO-ordered per client
    - op: create/delete/get/set/exist/get_child/sync
- ordering guarantees
    - all write operations are totally ordered
    - all operations are FIFO-ordered per client
    - implications
        - read can return stale data
- not an end-to-end solution
    - with ZooKeeper
        - at least master is fault tolerant
        - won't run into split-brain problem
- implementation
    - overview
        - two layers: ZooKeeper service + ZAB layer
            - vs. KV service + Raft layer
    - duplicate requests
        - primary 返回的结果丢失，客户端重试
        - in Raft, use table to detect duplicates
        - in ZooKeeper
            - test-version-and-then-do-op
    - read operations
        - performance is slow if read ops go through Raft
            - 每次都要 majority 同意
        - read may return stale data if only master performs it
            - master 可能不再是 master 了，但自己不知道（比如网络故障
        - ZooKeeper: don't promise non-stale data
            - reads can be executed by any replica
                - can increase throughput by adding servers
            - read returns the last zxid it has seen
                - new primary can catch up to zxid before serving the read
                - avoids reading from past
        - sync-read guarantees data is not stale
            - sync optimization
                - avoid ZAB layer for sync-read
                - leader puts sync in queue between it and replica
                - in same spirit read optimization with raft
    - performance
        - reads inexpensive ，吞吐量和机器数成正比
        - writes expensive ，吞吐量和机器数成反比
        - quick failure recovery
    - FAQ
        - linearizability and serializability
            - linearizability
                - used for systems without transactions
                - single-operation, single-object, real-time order
                - a real-time guarantee on the behavior of a set of single operations on a single object
                - linearizability is composable
                - atomic consistency, C in the CAP
            - serializability
                - used for systems that provide transactions
                - multi-operation, multi-object, arbitrary total order
                - the execution of a set of transactions over multiple items is equivalent to some serial execution (total ordering) of the transactions
                - serializability is not composable
                - I in the ACID (ACID 的 C 描述单个 transaction，I 描述多个 txn 之间的关系)
        - pipelining
            - ZK 的 async API 使用 callback 的方式告诉 client 调用结果
            - ZooKeeper guarantees FIFO for client operations
        - fuzzy snapshots
            - doesn't require blocking all writes while the snapshot is made
            - construct a consistent snapshot by replaying the logs
            - all updates in ZooKeeper are idempotent and delivered in the same order
            - leader turn the operation into a transaction which is idempotent
        - leader election
            - ZAB (ZooKeeper Atomic Broadcast)

---

- 截止目前反复出现的主题
    - 主从结构，多副本
    - WAL 日志、快照，用于异常恢复
    - 单 master 保证一致性、时序
    - 多机模拟单机表现，根据单机行为判断分布式行为是否符合预期

---


## Distributed Transactions

- transaction, hide interleaving and failure from application writers
    - atomic
    - serializable, transaction executed one by one
    - durable
- distributed transactions = concurrency control + atomic commit

- atomic commit by two-phase commit
    - transaction coordinator
        - PREPARE + COMMIT/ABORT
        - 2PC 由 transaction coordinator 居中协调
        - 所有节点都 prepare 则 commit，任一节点失败都 abort
        - if node voted YES, it must "block": wait for TC decision
    - used by distributed databases for multi-server transactions
        - when a transaction uses data on multiple shards
    - slow，每个操作都要求所有节点参与，全部成功，所以性能差，可靠性也差
    - vs Raft
        - Raft 通过 replicate 实现 high availability
            - 所有 server 都执行相同的操作，保证 majority 一致
        - 2PC 保证整个系统的一致性
            - 不同 node，执行不同的操作（比如一个事务的两张表，执行不同操作
        - Raft 的一致和 2PC 的一致，针对的不是一个层面的对象
        - 两个可以一起用

- concurrency control
    - serial means one at a time, no parallel execution
        - 具体实现可以并发，但执行结果要和序列执行一致
        - serializability lets programmer ignore concurrency
    - two classes
        - pessimistic, conflicts cause delays (waiting for locks)
        - optimistic, conflict causes abort+retry
- pessimistic concurrency control
    - two-phase locking，获得锁，释放锁
    - strong strict two-phase locking, locks until after commit/abort
        - serializable 的充分不必要条件
    - 2PC 的锁在 record 上，部分场景比 simple locking（全表加锁）更高效
- optimistic concurrency control (OCC)
    - works best if few conflicts

- NVRAM, non-volatile RAM
    - RAM write is faster than SSD/HDD
    - write to f+1 machines to tolerate f failures
    - 备用电池，断电后仍可运行几分钟
        - 停止处理事务
        - RAM 写入 SSD，待开机后恢复
- performance bottleneck, network
    - kernel bypass

---

- build a reliable system out of unreliable components
- metrics
    - MTTF = mean time to failure           = 30 days = 43,200 minutes
    - MTTR = mean time to repair            = 10 minutes
    - availability = MTTF / (MTTF + MTTR)   = 43,200 / 43,210 = .9997
- transactions, which provide atomicity and isolation, while not hindering performance
    - atomicity: shadow copies vs. logs
    - isolation: two-phase locking
- distributed transactions: to run transactions across multiple machines
    - message loss, message re-ordering
        - reliable transport
        - exactly-once semantics
    - two-phase commit (2PC)
        - two phases: prepare phase, commit phase
        - client + coordinator + worker
        - abort if failure happened before commit point
        - retry if failure happened after commit point

---

## Spark

- Spark
    - restricted programming model, but more powerful than MapReduce
    - better programming model for iterative computations
        - MapReduce 不是不能表达 iterative，不过需要拆分成多个 MapReduce 任务，比 Spark 复杂
    - targets batch, iterative applications
        - batch 之外，也有 streaming 等应用形态，然后 spark 也搞出了 Streaming Spark
    - not good for build key/value store
    - can express MapReduce, Pregel
- performance
    - MapReduce uses replicated storage after reduce
    - Spark only spills to local disk
    - 如果计算符合 MapReduce 模型，架构上讲，Spark 并没优势
        - Spark's in-memory RDD caching will offer no benefit since no RDD is ever re-used
        - 没有优势，但计算 MapReduce 类型的任务也没有劣势
- Spark keep data in memory
- RDDs (Resilient Distributed Dataset)
    - immutable
    - support transformations and actions
        - transformations compute a new RDD from existing RDDs
        - transformations are lazy
        - transformation is a description of the computation
        - actions is used for when results are needed
    - key ideas behind RDDs
        - deterministic, lineage-based re-execution
        - the collections-oriented API
    - after Spark 2.0, RDDs are replaced by Dataset
- RDD lineage
    - Spark creates a lineage graph on an action
    - Spark uses the lineage to schedule job
- lineage and fault tolerance
    - one machine fails, we want to recompute only its state
    - the lineage tells us what to recompute
    - follow the lineage to identify all partitions needed
    - 用户可以指定哪些 RDD 需要 replication
- RDD
    - list of partitions
    - list of (parent RDD, wide/narrow dependency)
        - wide, depends on serval parent partitions (eg, join)
        - narrow, depends on one parent partition (eg, map)
    - function to compute
    - partitioning scheme
    - computation placement hint
    - each RDD has location information associated with it, in its metadata

---








---

## Bayou

- ideas that are worth knowning
    - eventual consistency
    - conflict resolution
    - logging operations rather than data
    - use of timestamps to help agreement on order
    - version vectors
    - causal consistency via Lamport logical clocks
- ideas to remember
    - log of operations is equivalent to data
    - log helps eventual consistency (merge, order, and re-execute)
    - log helps conflict resolution (write operations easier than data)
    - causal consistency via Lamport-clock timestamps
    - quick log comparison via version vectors

- the log holds the truth; the DB is just an optimization
- ordered update log
    - syncing == ensure both devices have same log (same updates, same order)
    - DB is result of applying update functions in order
    - same log + same order = same DB content
- eventual consistency is the best you can do if you want to support disconnected operation
- timestamp
    - timestamp = (T, I)
    - T = creating device's wall-clock time
    - I = creating device's ID
- uses "Lamport logical clocks" for causal consistency
    - Lamport clock
        - Tmax = highest timestamp seen from any device
        - T = max(Tmax + 1, wall-clock time)
    - 保证新的 timestamp 不会比之前小
- "primary replica" to commit updates
    - one device is the "primary replica"
    - primary marks each received update with a Commit Sequence Number
- anti-entropy
- version vector
    - a summary of state known by a participant
- discard committed updates from log
    - keep a copy of the DB as of the highest known CSN
    - never need to roll back farther

---

## Naiad

- streaming and incremental computation
- Naiad vs Spark
    - Spark improved performance for iterative computations
    - better, incremental and streaming computations
    - equal (maybe better), batch and iterative processing
    - worse, interactive queries
    - worse, Spark is well-integrated with existed systems
- incremental processing
    - fixed data-flow
    - input vertices
        - file or stream of events
        - inject records into graph
    - stateful vertices
        - like cached RDDs but mutable
- data-flow cycles
    - vs Spark
        - Spark has no cycles (DAG)
        - iterate by adding new RDDs
        - no RDD can depend on its own child
    - loop contexts
        - can nest arbitrarily
        - cannot partially overlap
- ordering
    - avoid time-travelling updates
    - timestamps form a partial order
    - timely dataflow is low-level infrastructure
- low-level vertex API
    - deal with timestamps
    - different strategies
        - incrementally release records for a time, finish up with notification
        - buffer all records for a time, then release on notification
- progress tracking
    - protocol to figure out when to deliver notifications to vertices
    - single-threaded
    - distributed
        - aggregate events locally before broadcasting
        - global aggregator merges updates from different workers
- fault tolerance
    - log all messages to disk before sending
        - high common-case overhead
    - write globally synchronous, coordinated checkpoints
        - induces pause times while making checkpoints

---









---

## P2P, DHT

- decentralized systems
    - build reliable systems out of many unreliable computers
    - shift control/power from organizations to users
- peer-to-peer
    - spreads network/caching costs over users
    - advantage: 设备成本低，单用户故障不影响系统，每个用户的负担都不大
    - disadvantage: 数据分散不好找，用户机器不可靠，开放的网络有被攻击的风险
    - usage: file sharing, chat, bitcoin

- BitTorrent
    - the tracker is a weak part of the design
        - torrent file with content hash and IP address of tracker
        - app talks to tracker
    - tracker may not be reliable
- DHT (distributed hash table)
    - DHT is more reliable than tracker
    - DHT a decentralized key/value store
    - DHT is weak consistency
    - Kademlia
        - the key is the torrent file content hash
        - the value is the IP address of peers
    - each node has references to only a few other nodes
    - lookups traverse the data structure

- Chord, peer-to-peer lookup system
    - Kad (Kademlia) is inspired by Chord
    - topology
        - ring, all IDs are 160bit numbers
        - each node has an ID, hash(IP address)
        - each key has an ID, hash(key)
    - key_ID and node_ID
        - key is stored at the key ID's successor node
        - closeness is defined as the "clockwise distance"
        - 如果 hash 保证均匀分布，那么节点的负载就是均衡的
    - routing
        - basic
            - each node knows its successor on the ring
            - forward query in a clockwise direction until done
            - data structure is a linked list, linear search is slow
        - log(n) finger table
            - each node keep a finger table containing up to M nodes
            - periodically looks up each finger to maintain table
        - why not binary tree
            - hot-spot at the root
            - failure on root would be a big problem
            - finger table distributes the load
    - stabilization
        - each node keeps track of its current predecessor
    - node failures
        - recover from dead next hop by using next-closest finger-table entry

---

## Dynamo

- Database, eventually consistent, write any replica
    - Like Bayou, with reconciliation
    - Like Parameter Server, but geo-distributed
- SLA, constant failures, always writeable
- big picture: each item replicated at a few random nodes, by key hash

- consistent hashing
    - node_ID = random
    - key_ID = MD5(key)
    - coordinator: successor of key. (clients send put/get to coordinator)
    - preference list: replicas at successors
    - coordinator forwards put/get to nodes on the preference list
- failures
    - temporary, store new puts elsewhere until node is available
    - permanent, make new replica of all content
    - Dynamo itself treats all failures as temporary
        - administrator can remove node permanent
- always writeable
    - no master: sloppy quorums
    - conflicting versions (when failures happend): eventual consistency
- sloppy quorum
    - quorum: R+W > N
        - never wait for all N
    - sloppy quorum means R/W overlap not guaranteed
    - coordinator
        - sends put/get to first N reachable nodes, in parallel
        - put: waits for W replies
        - get: waits for R replies
- eventual consistency
    - allow reads to see stale or conflicting data
    - if conflicts, reader must merge and then write
    - no atomic operations (eg. CAS)
- version vectors
    - Dynamo deletes least-recently-updated entry (threshold=10 now)
- N, R, W
    - n3r2w2, default, reasonable fast R/W, reasonable durability
    - n3r1w3, fast R, slow W, durable

- anti-entropy using Merkle trees
    - to determine what is different between two replicas, Dynamo traverses a Merkle representation of the two replicas
- gossip protocol
    - a system that doesn't have a master that knows about all participants in the system
    - gossip protocol: the protocol used in such system to to find other members

---

## Bitcoin

- bitcoin
    - a digital currency
    - a public ledger to prevent double-spending
    - no centralized trust or mechanism
    - malicious users (Byzantine faults)
- problem
    - forgery
    - double spending
    - theft
- idea, signed sequence of transactions
- transaction record contains
    - pub(user1), public key of new owner
    - hash(prev), hash of this coin's previous transaction record
    - sig(user2), signature by previous owner's private key
- forgery
    - current owner's private key needed to sign next transaction
- block chain
    - goal, agreement on transaction log to prevent double-spending
    - 疑问。查所有交易记录，要拥有完整的日志。这个查询效率是怎么保证的？
    - the block chain contains transactions on all coins
    - payee doesn't believe transaction until it's in the block chain
    - block contains
        - hash(prev_block)
        - transactions
        - nonce
        - current time (wall clock timestamp)
    - create new block
        - requirement: hash(block) has N leading zeros
        - try nonce values until this works out
            - 易验证，难伪造
    - fork
        - switch to longer chain if peers become aware of one
        - temporary double spending is possible, due to forks

