# AWS builder

---

https://aws.amazon.com/builders-library/challenges-with-distributed-systems/

## challenges with distributed systems

- types
    - offline (example: batch processing system, big data analysis cluster, ...
    - soft real-time (example: search index builder, ...
    - hard real-time (example: front-end web server, the order pipeline, credit card transaction, ...

---

https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/

## timeouts, retries, and backoff with jitter

- to build resilient systems, we employ three essential tools
    - timeout
    - retry
    - backoff
- timeout
    - set a timeout on any remote call, and generally on any call across processes even on the same box
    - timeout value, start with the latency metrics of the downstream service
- retry
    - when failures are caused by overload, retries that increase load can make matters significantly worse.
- backoff
    - instead of retrying immediately and aggressively, the client waits some amount of time between tries
    - the most common pattern is an exponential backoff, where the wait time is increased exponentially after every attempt
    - capped exponential backoff (maximum backoff value, exponential functions grow quickly)
        - https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/
        - `sleep = min(cap, base * 2 ** attempt)`
        - full jitter `sleep = random_between(0, min(cap, base * 2 ** attempt))`
        - decorrelated jitter `sleep = min(cap, random_between(base, sleep * 3))`
        - equal jitter `temp = min(cap, base * 2 ** attempt); sleep = temp / 2 + random_between(0, temp / 2)`

- timeouts keep systems from hanging unreasonably long
- retries can mask those failures
- backoff can improve utilization and reduce congestion on systems

---

https://aws.amazon.com/builders-library/workload-isolation-using-shuffle-sharding/

## workload isolation using shuffle-sharding

- 通过 hash 进行 sharding 的分区，避免单个客户的故障，影响其他客户
- 应该也算是很常见方案，比如 gfs 的文件存储也是这样的

---

https://aws.amazon.com/builders-library/leader-election-in-distributed-systems/

## leader election in distributed systems

> Leases are relatively straightforward to understand and implement, and they
> offer built-in fault tolerance. Leases work by having a single database that
> stores the current leader. Then, the lease requires that the leader heartbeat
> periodically to show that it's still the leader. If the existing leader fails
> to heartbeat after some time, other leader candidates can try to take over.

> In distributed systems, it's not possible to guarantee that there is exactly
> one leader in the system. Instead, there can mostly be one leader, and there
> can be either zero leaders or two leaders during failures.

> Systems that perform work which is idempotent can often tolerate two leaders
> with minimal loss of efficiency. With two leaders, systems can achieve higher
> availability and choose weaker leader election approaches.

---

https://aws.amazon.com/builders-library/caching-challenges-and-strategies/

## caching challenges and strategies

- in-memory cache VS external cache
    - external
        - no cold start issue
        - increase system complexity and operational load
- read-through/write-through cache VS side cache
- expiration
    - TTL, LRU
    - when downstream service return error
- thundering herd
    - request coalescing
