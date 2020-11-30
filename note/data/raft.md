# raft

---

## basic raft algorithm

---

### overview

- leader-based
    - simplify the data flows
    - elect a new leader if the old one disconnected
    - 问题被简化成独立的小问题
        - leader election
        - log replication
        - safety (这个是 raft 满足的一些性质

---

### basic

- leader, follower, candidate
    - leader 只会变成 follower (new term
    - follower 只会变成 candidate (timeout
    - candidate 可以转移到三种角色

- the follower redirects all clients to the leader

- time is divided into terms.
    - there is at most one leader in a given term.
    - terms act as a logical clock

- RPC
    - RequestVote by follower
    - AppendEntries by leader
- raft 不依赖 RPC 的到达顺序
- raft RPC 是 at-least-once 语义，允许发送端重试

---

### leader election
- leader 靠 heartbeat 维持
- follower 在 election timeout 之后，会进行一堆操作
    - transfer into candidate
    - term++
    - vote for itself
    - issue RequestVote to other nodes
- each server will vote for at most one candidate in a given term
- election timeouts are chosen randomly from a fixed interval (e.g., 150-300 ms)

---

### log replication

- （这些个 index，用个 long long，随便增长，完全够用，不会溢出

- log 什么时候被 committed，也就是什么时候可以 safe to apply a log entry to the state machine
    - leader 收到 client 请求，把 entry 加入 log
    - leader 向其他节点广播 entry
    - 超过半数节点完成同步，leader 向 state machine 里 commit entry
        - 这里 commit 只发生在 leader，leader 在后续 RPC 中会携带 commitIndex，但这里不会阻塞响应 client
    - commit 后，leader 向 client 返回 response
    - （中间任何一步，leader/follower crash 了会怎么样

- AppendEntries perform consistency check
    - AppendEntries 会携带 当前的 entry 和 前一个 entry
    - 如果找不到 前一个 entry，这次 AppendEntries 会被节点拒绝
- leader 会维护 follower 的信息，每个 follower 都有一个 nextIndex
    - 选出新的 leader 之后，nextIndex 会初始化成 leader 当前的 log index
    - 如果 AppendEntries 因为 consistency check 被拒绝，说明 leader 和 follower 不同步，nextIndex 会回退一个，然后重新 AppendEntries
    - nextIndex 的回退，最终会达到 leader/follower 的共同起点，follower 就从这个起点开始同步数据
    - （感觉这个通信的效率很低啊，但论文里觉得不需要什么优化，实践中数据不一致的情况很少见
- 新 leader/follower 数据不一致的情况，就靠 consistency check 这个机制实现同步

### follower/candidate crashes

- Raft handles these failures by retrying indefinitely
    - 简单粗暴
    - raft 里的 RPC 都是没有副作用的，所以设计上都是失败就重试

---

### safety

- Leader Completeness Property -> State Machine Safety Property

- ensure the leader for any given term contains all of the entries committed in previous terms

- 只投票给那些，log 不比自己旧的节点
- the voter denies its vote if its own log is more up-to-date than that of the candidate
- comparing the index and term of the last entries in the logs
    - 虽然 follower 有之前 leader 的 commitIndex，但不考虑这个值，因为这个值可能不是最新的

- 新 leader 会等到新 term commit entry，才会把旧 term 视为 committed
- Raft never commits log entries from previous terms by counting replicas.
- Only log entries from the leader’s current term are committed by counting replicas.
- once an entry from the current term has been committed in this way, then all prior entries are committed indirectly

- 假想场景，五节点
    - leader A 和 follower B 大量写入，但是和 DEF 断开。发生选主，F 成为 leader，然后 AB 的数据被覆盖。
    - leader A 和 follower BC 大量写入，和 EF 未跟上。A 宕机，发生选主。只有 BC 有希望，因为 EF 数据太旧。

---

### persisted state / server restart

- term, vote, log 都需要被持久化
- 可以搞 snapshot 加快 state machine 构建，完全从日志重新构建也是可以的
- (其他状态都无所谓，可以启动后恢复回来

---

### time

- safety does not depend on time
- availability is depend on time
- leader election is depend on time
    - 必须满足 mean_time_between_failures >> election_timeout >> broadcast_time

数据安全，只和逻辑时间（也就是消息）有关，不依赖于时间。
但是各种 timeout 是物理时间，为了让系统能够正常运作，需要满足一定的条件。
否则一直选主失败，或者一直无法提交数据，系统实质上无法运行。

MTBF/broadcast_time 这是系统、网络自身决定的，算法层面做不了什么。
election_timeout 这个要自己判断。
论文里给了一个 broadcast_time=0.5~20ms，election_timeout=10~500ms。

---

### leadership transfer

停机维护之类的场景，需要主动交出 leadership。
先将目标节点的 log 更新至最新状态，然后发一个 `TimeoutNow` 过去，触发选主。
（这里是不是还要考虑下，自己又被选上的情况……不然自己被选上，状态机要加一点点条件

---

## cluster membership changes

- 增加两个 RPC 调用，AddServer/RemoveServer
- 用于支持动态增删节点

---

### safety

- 分析时要记住，raft leader 并不记录 follower 的 commit index

- only one server can be added or removed from the cluster at a time
    - disallow membership changes that could result in disjoint majorities
    - at least one server overlaps any majority during the change
    - preserving safety across configuration changes
    - 每次只允许 增/删 一个节点，保证了修改前后 majority 是有重叠的，也就保证了不会出现 split brain

- cluster configurations are stored and communicated using special entries in the replicated log
    - 增删节点，通过追加 log 实现
    - The configuration change is complete once the Cnew entry is committed
    - servers always use the latest configuration in their logs
    - 整个修改是 commit 才算完成，但是还没 commit 就已经在各个节点生效了
    - a log entry for a configuration change can be removed (if leadership changes)
    - 如果中途发生了选主，还把 Cnew 删除了，那么全部节点都要退回使用 Cold

- 每次增删只允许一个，commit 之后才算完成一次增删操作

- servers process incoming RPC requests without consulting their current configurations
    - A server accepts AppendEntries requests from a leader that is not part of the server’s latest configuration
    - A server grants its vote to a candidate that is not part of the server's latest configuration
    - 这两条都是保证新节点能加入 cluster

---

### availability

---

#### catch up new server

- when a server is added to the cluster, it typically will not store any log entries
- its log could take quite a while to catch up to the leader's
- until the new servers' logs were caught up to the leader's, the clusters would be unavailable
- 就是节点初始化的问题
- 如果出现新节点是 majority 成员的情况，新节点需要长时间去同步状态，可能导致 client 的响应时间很高

- a new server joins the cluster as a non-voting member
- The leader replicates log entries to it, but it is not yet counted towards majorities for **voting or commitment** purposes
- raft 的解决方案是，新节点在完成同步前，不参与 majority 统计
- The leader should also abort the change if the new server is unavailable or is so slow that it will never catch up
- 新节点完不成同步，甚至会被拒绝

（有没有必要追溯所有 log，没必要的话，定期 snapshot 可以加快新节点加入、异常恢复什么的

- 怎么判断新节点能否完成同步
    - The replication of entries to the new server is split into rounds
        - 当前 leader 的 log index 为 A
        - 新 follower 同步到 A 的时候，leader 新增 log 到了 log index B
        - 则 A 至 B 的 log 就算一个 round
    - The algorithm waits a fixed number of rounds (such as 10)
    - If the last round lasts less than an election timeout, then the leader adds the new server to the cluster

---

#### remove the current leader

- a leader that is asked to remove itself would transfer its leadership to another server, which would then carry out the membership change normally.
- 简单的方法，先移交 leadership，然后由新 leader 删除节点

- 没实现 leadership transfer 的话
- a leader that is removed from the configuration steps down once the Cnew entry is committed
- leader 确定 Cnew commit 了才下线。之后发生 timeout，触发选主

- it replicates log entries but does not count itself in majorities.
    - 广播了 Cnew 但还没 timeout，期间 leader 还会继续追加 log，但是自己不计入 majority

- a server that is not part of its own latest configuration should still start new elections
    - as it might still be needed until the Cnew entry is committed

---

#### disruptive servers

- once the cluster leader has created the Cnew entry, a server that is not in Cnew will no longer receive heartbeats
    - it will time out and start new elections
    - it will not know that it has been removed from the cluster
    - 自己被删了还不知道，还在努力的 RequestVote，怎么感觉有点惨呢
    - it will send RequestVote with new term numbers, this will cause the current leader to revert to follower state
    - 然后 leader 就变成 follower 了，然后再触发选主，再变 follower，无限循环

- the Pre-Vote phase
    - a candidate would first ask other servers whether its log was up-to-date enough to get their vote
    - pre-vote 成功才有希望成为新 leader，只有成功了才增加 term，发送 RequestVote
- 这并不能完全解决问题，如果被剔除的节点数据很新，pre-vote 可能成功
- no solution based on comparing logs alone (such as the Pre-Vote check) will be sufficient to tell if an election will be disruptive
    - 无解

- Raft's solution uses heartbeats to determine when a valid leader exists
    - if a server receives a RequestVote request within the minimum election timeout of hearing from a current leader
    - it does not update its term or grant its vote
- 节点收到 RequestVote，不会马上接受。要等节点达到 minimum election timeout 才会接受
- 这样就避免了被踢出去的节点更新 term

---

### integration

- it is preferable to add servers before removing servers
- with dynamic membership changes, the static configuration file is no longer needed
    - the system manages configurations in the Raft log
- we recommend that
    - the very first time a cluster is created
    - one server is initialized with a configuration entry as the first entry in its log
    - other servers from then on should be initialized with empty logs
    - 启动的时候，只给一个节点最初的 membership configuration，只包含节点自己
    - 之后其他节点都用动态添加的方式加入 cluster

---

## log compaction

- most of the responsibility of log compaction falls on the state machine
    - writing the state to disk
    - compacting the state
- each server compacts the committed prefix of its log independently
    - for very small state machines, a leader-based approach may be better
- Raft retains the index and term of the last entry and the latest configuration
    - last entry 用于 AppendEntries 定位
    - latest configuration 用于维护 membership
- 其他的 snapshot 用途不多说了，异常恢复、快速更新

---

### snapshot memory-based state machine

- copy-on-write
    - in-memory state machines can use fork to make a copy of the server's entire address space
    - the child process can write out the state machine's state and exit
    - the parent process continues servicing requests
    - 记得 redis 也是这么做的

- 什么时候生成 snapshot
- servers take a snapshot once the size of the log exceeds the size of the previous snapshot times a configurable expansion factor.

### snapshot disk-based state machine

- applying each entry from the Raft log mutates the on-disk state
    - once an entry is applied, it can be discarded from the Raft log
    - 就是完全用硬盘存储了

### incremental approach

- log cleaning or log-structured merge tree
- 作者讲了两种结构

### leader-based approach

- each follower already has the information needed to compact its own state
- the leader's outbound network bandwidth is usually Raft’s most precious (bottleneck) resource
    - 开篇讲了一堆 leader-based approach 的缺点

- snapshot 直接作为 entry，实现上简单
    - the leader would create a snapshot and store the snapshot as entries in the Raft log
    - servers would not need separate mechanisms to transfer snapshots or persist them

- 作者也觉得这个方案没啥用

---

## client interaction

- the consensus literature only addresses the communication between cluster servers
- in real Raft-based systems, client interaction can be a major source of bugs

---

### finding the cluster
- raft membership 可能变化，所以要怎么连上 raft cluster 呢
    - network broadcast or multicast
    - external directory service (such as, DNS

### routing requests to the leader
- when a client first starts up, it connects to a randomly chosen server
    - follower rejects the request and return to the client the address of the leader
    - follower proxies the request to the leader

### implementing linearizable semantics
- raft provides at-least-once semantics for clients
    - the at-least-once semantics are particularly **unsuitable** for a consensus-based system
    - clients typically need stronger guarantee
    - 不在 client 做任何判断，网络问题导致 raft 是 at-least-once 语义
    - 比如 leader commit 之后 crash，client 可能再次发送相同的指令

- 实现 exactly-once 语义，过滤重复请求
- to achieve linearizability in Raft, servers must filter out duplicate requests
    - each client is given a unique identifier
    - clients assign unique serial numbers to every command
    - server's state machine maintains a session for each client
    - the session tracks the latest serial number processed for the client
    - 前面这个只处理 latest 还是不够，需要支持并行就要记录所有完成前的指令
    - the client includes the lowest sequence number for which it has not yet received a response
    - the state machine then discards all responses for lower sequence numbers

- 怎么处理 client session 过期的问题
    - 每个 client 在最初都要申请一个 session id
    - raft leader 和 client 通过 heartbeat 保持 session 存活（这样 leader 压力会不会很大？
    - （要严格保证一致性，只能靠 client 自己做数据检查了？

### processing read-only queries more efficiently
- bypassing the log could lead to stale results for read-only query
- a approach that more efficient than committing read-only queries as new entries in the log (还是有一些地方可以优化
    - a leader has all committed entries, but at the start of its term (Leader Completeness Property
        - each leader commit a blank no-op entry into the log at the start of its term
        - 提交一个 no-op 保证当前 term 已经 commit
    - 请求进来的时候，记录 commit index
    - 通过一次 heartbeat 确保自己仍是 leader
    - 只要 state-machine 跟上 commit index，就可以直接读取

- lease
    - the leader would use the normal heartbeat mechanism to maintain a lease
    - once the leader’s heartbeats were acknowledged by a majority of the cluster, it would extends its lease
        - new_lease = heartbeat_start + (election_timeout / clock_drift_bound)
    - while the leader held its lease, it would service read-only queries without communication
- 在 election_timeout/clock_drift_bound 之内，系统不可能选出新的 leader
- the lease approach assumes a bound on clock drift across servers
    - 作者其实不推荐这个强依赖于时间的方案

- client 也可以配合一下，请求时携带 log index
    - stale leader 发现 client log index 比自己的 committed log index 还大，就知道自己处理不了这次的请求
    - 不能保证完全 linearizability，但可以保证递增

---

## leader election evaluation
- when election timeouts are chosen randomly from a range of 10-20 times the one-way network latency, leaders are elected within about 20 times the one-way network latency on average
- 99.9% of elections complete in less than 3 seconds when the one-way network latency is as high as 30-40 ms
