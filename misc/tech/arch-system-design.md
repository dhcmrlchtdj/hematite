# how to design system

---

1. use cases, constrains, assumptions
    - calculation
        - space usage
            - memory, disk, network
        - time usage
            - per query, memory/disk read speed
        - QPS
2. high level design
    - architecture diagrams
3. implementation of core component
4. scale the design
    - benchmark
    - profile for bottlenecks
    - address bottlenecks while evaluating alternatives and trade-offs
    - repeat

---

## design && scale

- what bottlenecks you might encounter with the initial design
- how you might address each of them
- what are the alternatives and Trade-Offs for each

- 对 server 结构进行比较细的拆分
    - user => server => API => service => storage
    - cache (memory cache / CDN cache / ...)

---

## scale

- 看到文件存储，考虑能否使用 CDN
- 看到服务，考虑能否去单点，负载均衡
    - 进行多机部署，考虑是否需要一致性哈希等方法来进行负载均衡
- 看到数据库，考虑是否需要缓存，是否需要主从等拆分，是否需要 nosql

---

## question

- when to update cache? how many strategies?
- sql or nosql? what's advantage or disadvantage?
- cache cluster design?
    - where / when / how
