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

---

## scale

- load balancer with multiple web servers
- CDN for statics
- master-slave replicas
- consistent hashing

---

## question

- when to update cache? how many strategies?
- sql or nosql? what's advantage or disadvantage?
- cache cluster design?
