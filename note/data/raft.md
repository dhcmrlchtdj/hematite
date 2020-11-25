# raft

---

- basic raft algorithm /20
- cluster membership changes /15
- log compaction /17
- client interaction /19

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

---

