# System Design Interview

https://blog.pragmaticengineer.com/system-design-interview-an-insiders-guide-review/

这篇文章吹得天花乱坠，看书时期待落空。
本书更多是讲系统可以怎么组装出来，不会深入去讲某个子系统如何实现。

用作者自己的话说
- system design interviews are not about building everything from scratch
- building scalable blob storage or CDN is extremely complex and costly
虽然确实是这样，但作为读者，最好奇的不就是复杂问题如何被一步步解决吗？

---

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

# unique id generator

## requirement
- generate 10k ID per second

## design
- UUID
- ticket server
    - a Flickr ticket server is a dedicated database server, with a single database on it
    - `REPLACE INTO Tickets64 (stub) VALUES ('a'); SELECT LAST_INSERT_ID();`
    - 靠 unique key 自增的方式获取新的 id
    - SPOF 的问题，双机做负载均衡，一个只生成奇数 ID，一个只生成偶数 ID
- snowflake
    - ID = time_stamp + data_center_id + machine_id + sequence_number

    这种 ID 生成器好像都是趋势递增，但不保证单调递增。没什么经验，不知道实际要求如何。

    美团的 leaf 服务类似 ticket server，不过在 client 和 DB 之间有个 proxy。
    会在 proxy 里一次取一段 id 而不是每次都到 DB 生成，而 proxy 是可以扩展的。


---

# url shortener
拿了一些篇幅讨论 hash function，我觉得直接拿 ID 就可以了

---

# web crawler

---

# notification system
（太水了，不是在讲系统怎么设计，而是在讲怎么当 API caller

---

# news feed system

> Fanout is the process of delivering a post to all friends
- fanout on write (also called push model)
    - the news feed is pre-computed during write time
    - 优点是用户读取快
    - 缺点是不适合头部用户（推送的量太大，而且推送给不活跃用户是在浪费算力）
- fanout on read (also called pull model)
    - the news feed is generated during read time
    - 优缺点相反
- hybrid
    - 普通用户，发消息时主动 push
    - 头部用户 follower 较多，让 follower 去 pull 消息

---

# chat system

> the choice of network protocols is important
但后文只是在讲 poll, long pull, websocket…

- use k-v store for chat history data

其实 chat, news feed, notification 三套系统很像吧，都是在推送消息。
多人群组，就像信息流的头部用户一样。

---

# autocompletion
- trie
- data gathering service 用于分析热词

---

# youtube
- CDN + S3

---

# google drive
有了 S3 这种服务，上层更多是 metadata 的维护吧。
