# rate limiter

## algorithm
- token bucket
    - bucket 有一定的 capacity
    - refiller 定期生成 token，如果 bucket 已满，什么都不做
    - client 消耗 token，如果 bucket 已空，请求失败
    - 可以看出，bucket 就是个队列
    - 可以调节 bucket size 和 refill rate
    - 在设计上，允许短时间内有大量请求发送的服务器
- leaking bucket
    - 这里 bucket 也是个 queue
    - bucket 没满，request 就加入 queue，已满则请求失败
    - bucket 里的请求按固定速率发送给 server，甚至是 server 通过 pull 的方式处理请求
    - 可以调节 bucket size 和 outflow rate
    - 在设计上，服务器始终是以相同的速率接受到请求
- fixed window counter
    - 固定的时间窗口，每个周期内只处理一定数量的请求，其他请求失败
    - （感觉，移动窗口，效果和 refiller 一样
    - 时间窗口是固定的，所以请求峰值不是一个窗口的阈值，而是可能 2 倍的请求量正好挤在短时间到达
- sliding window log
    - 记录每个请求的时间戳，新的请求进来，计算整个时间窗口内的请求数是非超出阈值
    - 优点，accurate，是滚动窗口，所以周期内的请求肯定不会超过阈值
- sliding window counter
    - 结合 fixed window counter 和 sliding window
    - 固定窗口，但是考虑上个窗口处理的请求数量和当前窗口的剩余时间
        - current_window_request + previous_window_request * overlap_of_rolling_and_previous
    - （我觉得这是把事情搞复杂了……时间窗口划得小一些是不是就足以解决大部分问题

## architecture
- rate limiter middleware
- use redis to track the state

## detail design
- how are rules created? where are rules stored?
- how to handle the rejected request?

一个独立的服务记录规则，rate limiter 去该服务获取规则。
拒绝的请求可以被 HTTP 429 或者其他方式处理。

## scale
- race condition
    - redis 的记录更新，需要事务机制
- synchronization issue
    - 多个 rate limiter 之间怎么同步
    - 作者给出的建议是使用同一个 redis cluster
        - 这个回答有点取巧的感觉，不过 consensus 确实是放在数据层面做更好一些

## performance
- multi data center
- eventual consistency
感觉这两点和 consensus 都是矛盾的…

---

# consistent hashing

> To determine which server a key is stored on,
> go clockwise from the key position on the ring until a server is found.

> As the number of virtual nodes increases, the distribution of keys becomes more balanced.

其实就两点，一个是 hash ring，一个是 virtual node

---

# key-value store

> Since network failure is unavoidable, a distributed system must tolerate network partition.
> Thus, a CA system cannot exist in real- world applications.
之前看 RocksDB 的一个维护者喷 CAP 让问题变得模糊。
如果说 P 必然存在，所以 CA system 不存在，那为什么不叫 CA 定理。

## component
- data partition
- data replication
- consistency (sloppy quorum
- inconsistency resolution (version clock
- handling failures
    - gossip protocol 发现故障
    - merkle tree 同步数据（减少需要同步的数据量

## gossip
> each node maintains a node membership list
每个节点都只和几个节点进行定期通讯。（而不是和所有节点

---


