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

- raft
    - elections, log handling, persistence, client behavior, snapshots
    - overview
        - diagram: clients, k/v layer, raft layer
            - raft 选出 leader
            - client 发送操作到 leader 的 kv
            - raft 将操作发送到 followers，followers 记录到 local log 并返回给 leader
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
            - 谁大谁就是 leader，谁大谁就说了算（疑问，数字一直自增？溢出了怎么办？
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
    - raft log
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
        - service's on-disk state = service's snapshot + raft's persistent log
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
        - (raft) sacrifice performance for simplicity

- 截止目前反复出现的主题
    - 主从结构，多副本
    - 快照，用于异常恢复
    - 靠单 master 保证一致性、时序
    - 多机模拟单机表现，根据单机行为判断分布式行为是否符合预期
