# service discovery

---

https://twitter.com/laisky_sh/status/1271274145985097728

> 另一个意外发现是，虽然 CAP 已经烂大街，但其实大家对 CAP 的理解五花八门。
> 比如很多人都用过 euruka 和 zk，很多人也都知道一个是 AP 一个是 CP，但是具体差别在哪，为什么 zk 不适合做服务发现，就没多少人能答出来了。
> 一个有趣的深入方向是，consul 也是 CP，为什么适合做服务发现？

CP 的问题是，发生 partition 时无法读写 service 信息

---

## Open-Source Service Discovery

http://jasonwilder.com/blog/2014/02/04/service-discovery-in-the-cloud/

> How do clients determine the IP and port for a service that exist on multiple hosts?
> **Service Registration** and **Service Discovery**.
- 如何注册和发现服务，很现实的问题

> Availability / Monitor / Load Balance
- 服务自身的可用性（也就是前面 twitter 里的问题
- service 节点的可用性、流量分配

### Zookeeper
- ZK 提供数据读写，并不了解 service/client 的具体信息
    - service 去 ZK 注册信息
    - client 去 ZK 拉取信息
- monitor 通过 ephemeral nodes 实现，service 宕机 ephemeral nodes 消失，client 就获取不到了
- 没有 load balance，client 自己处理
- CP system，ZK 出问题时，处于少数派的一边无法读写 service 信息
    - > Specifically, on any non-quorum side, reads and writes will return an error.

### Etcd
- 和 ZK 一样的模式，service/client 都自己动手
    - 没有 ephemeral nodes，不过 key TTL 能提供一样的能力
- 也是 CP system，不过可以在 partition 时读取过期信息以保证可用性，但写入仍是不允许的
    - 其实就是牺牲了一定的 C

### Eureka
- 分为 Eureka server 和 Eureka client
    - running one Eureka server in each availability zone in AWS to form a cluster
    - 每个 zone 一个 server（这是假设 zone 内部不会出现 partition
- 服务 调用 client 注册服务，通过 heartbeat 保持 leases
- 客户端 调用 client 发现服务，会生成本地的缓存、定期刷新
- server 相对轻量，很多工作都是 client 完成的
- AP system，service 信息会在 partition 恢复后合并

---

## Consul
- 三种一致性模型，<https://www.consul.io/api-docs/features/consistency>，可以牺牲 C
- https://www.consul.io/docs/intro/vs/zookeeper
- https://www.consul.io/docs/intro/vs/eureka
- 我理解，这个 multiple datacenter 和 eureka 在每个 zone 部署一个 service 是类似的玩法
